import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../config/marquee_config.dart';
import 'browser_agent.dart';

/// Debug-only trace. Wrapped in `assert` so nothing is emitted in release —
/// release log strings become fingerprints.
void ringTrace(String Function() message) {
  assert(() {
    debugPrint(message());
    return true;
  }());
}

/// Owns the AppsFlyer SDK: ATT prompt, install/reopen/deep-link callbacks, the
/// Organic false-positive re-check via GCD, and composing the flat config body.
class AttributionRelay {
  AttributionRelay(this._agent);

  final BrowserAgent _agent;
  AppsflyerSdk? _sdk;
  Map<String, dynamic>? _install;
  Map<String, dynamic>? _reopen;
  Map<String, dynamic>? _deepLink;
  Future<void>? _startFuture;
  Future<void>? _consentFuture;
  final Completer<void> _installReady = Completer<void>();
  final Completer<void> _deepLinkReady = Completer<void>();

  /// Requests ATT consent exactly once per process. Lives in its own memoized
  /// future so the caller (`RingCoordinator`) can drive it explicitly on the
  /// undecided route, independent of `start()`. See lessons §26.
  Future<void> ensureConsent() =>
      _consentFuture ??= _requestTrackingIfNeeded();

  Future<void> start() => _startFuture ??= _start();

  Future<void> _start() async {
    if (!MarqueeConfig.gateReady) {
      _completeEmpty();
      return;
    }
    try {
      await ensureConsent();
      final sdk = AppsflyerSdk(
        AppsFlyerOptions(
          afDevKey: MarqueeConfig.appsFlyerKey,
          appId: MarqueeConfig.iosStoreId,
          showDebug: kDebugMode,
          timeToWaitForATTUserAuthorization: 4,
        ),
      );
      _sdk = sdk;
      sdk.onInstallConversionData(_acceptInstall);
      sdk.onAppOpenAttribution((dynamic raw) => _reopen = _flat(raw));
      sdk.onDeepLinking((result) {
        final event = result.deepLink?.clickEvent;
        if (event != null) _deepLink = Map<String, dynamic>.from(event);
        if (!_deepLinkReady.isCompleted) _deepLinkReady.complete();
      });
      await sdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true,
      );
    } catch (error) {
      ringTrace(() => '[TT.RELAY] init failed: $error');
      _completeEmpty();
    }
  }

  Future<void> _requestTrackingIfNeeded() async {
    if (!Platform.isIOS) return;
    var status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status != TrackingStatus.notDetermined) return;
    await WidgetsBinding.instance.endOfFrame;
    await Future<void>.delayed(
      const Duration(milliseconds: MarqueeConfig.attPromptDelayMs),
    );
    await _waitFrontmost();
    status = await AppTrackingTransparency.requestTrackingAuthorization();
    // The platform silently no-ops the request if the app was not frontmost
    // when it fired — status stays `notDetermined` and no dialog appeared.
    // Wait for `resumed` (again) and ask once more. See lessons §26.
    if (status == TrackingStatus.notDetermined) {
      await _waitFrontmost(strict: true);
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> _waitFrontmost({bool strict = false}) async {
    // On a cold start the platform reports the lifecycle state late — treat
    // `null` as frontmost unless a strict retry is asking for a real resumed.
    for (var attempt = 0; attempt < 24; attempt++) {
      final state = WidgetsBinding.instance.lifecycleState;
      final ok = state == AppLifecycleState.resumed ||
          (!strict && state == null);
      if (ok) return;
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> _acceptInstall(dynamic raw) async {
    try {
      final received = _flat(raw);
      final status = received['status']?.toString().toLowerCase();
      // AppsFlyer sends {status:failure,...} when it cannot reach its servers
      // (e.g. an ad-blocking VPN). Never merge that error map into the payload.
      final failed = status == 'failure' ||
          (received['af_status'] == null && received.containsKey('status'));
      ringTrace(
        () => '[TT.RELAY] conversion status=$status '
            'af_status=${received['af_status']} keys=${received.keys.toList()}',
      );
      if (failed) {
        _install = <String, dynamic>{};
      } else if (received['af_status'] == 'Organic') {
        await Future<void>.delayed(
          const Duration(seconds: MarqueeConfig.organicRecheckSeconds),
        );
        _install = await _fetchGcd() ?? received;
      } else {
        _install = received;
      }
    } catch (error) {
      ringTrace(() => '[TT.RELAY] conversion parse error: $error');
      _install = <String, dynamic>{};
    } finally {
      if (!_installReady.isCompleted) _installReady.complete();
    }
  }

  Map<String, dynamic> _flat(dynamic raw) {
    if (raw is! Map) return <String, dynamic>{};
    final map = Map<String, dynamic>.from(raw);
    final payload = map['payload'];
    return payload is Map ? Map<String, dynamic>.from(payload) : map;
  }

  Future<Map<String, dynamic>?> _fetchGcd() async {
    final uid = await appsFlyerId();
    if (uid == null || uid.isEmpty) return null;
    try {
      // The path segment is `id<numericStoreId>` — using the bundle id (or
      // `?app_id=…`) returns empty payloads. See gray_flow_lessons.md §11.
      final base = MarqueeConfig.gcdBase.endsWith('/')
          ? MarqueeConfig.gcdBase
          : '${MarqueeConfig.gcdBase}/';
      final uri = Uri.parse(
        '${base}id${MarqueeConfig.iosStoreId}?device_id=$uid',
      );
      final response = await _agent.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ${MarqueeConfig.appsFlyerKey}',
        },
      ).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> awaitSignals({Duration? installTimeout}) async {
    await start();
    await Future.wait<void>(<Future<void>>[
      _installReady.future
          .timeout(installTimeout ?? MarqueeConfig.firstInstallWait, onTimeout: () {}),
      _deepLinkReady.future.timeout(MarqueeConfig.deepLinkWait, onTimeout: () {}),
    ]);
  }

  Future<String?> appsFlyerId() async {
    try {
      return await _sdk?.getAppsFlyerUID();
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>> compose({
    required String locale,
    String? pushToken,
  }) async {
    final body = <String, dynamic>{};
    if (_install != null) body.addAll(_install!);
    if (_reopen != null) {
      _reopen!.forEach((k, v) => body.putIfAbsent(k, () => v));
    }
    if (_deepLink != null) {
      _deepLink!.forEach((k, v) => body.putIfAbsent(k, () => v));
    }

    body['af_id'] = await appsFlyerId() ?? body['af_id'] ?? '';
    body['bundle_id'] = MarqueeConfig.bundleId;
    body['os'] = 'iOS';
    body['store_id'] = MarqueeConfig.storeToken;
    body['locale'] = locale;
    if (pushToken != null &&
        pushToken.isNotEmpty &&
        MarqueeConfig.firebaseProjectNumber.isNotEmpty) {
      body['push_token'] = pushToken;
      body['firebase_project_id'] = MarqueeConfig.firebaseProjectNumber;
    }

    if (Platform.isIOS) {
      try {
        if (await AppTrackingTransparency.trackingAuthorizationStatus ==
            TrackingStatus.authorized) {
          final idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
          if (idfa.isNotEmpty && !idfa.startsWith('00000000-')) {
            body['sub_id_10'] = idfa;
          }
        }
      } catch (_) {}
    }
    ringTrace(() => '[TT.RELAY] payload ${jsonEncode(body)}');
    return body;
  }

  void _completeEmpty() {
    if (!_installReady.isCompleted) _installReady.complete();
    if (!_deepLinkReady.isCompleted) _deepLinkReady.complete();
  }
}

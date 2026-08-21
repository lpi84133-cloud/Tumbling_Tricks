import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Install-attribution keys, kept in one place so a rotation is one edit.
///
/// The dev key is not a secret — every installed copy of the app already ships
/// it inside the compiled binary — but centralising it makes the wiring easy
/// to review.
class _AppsFlyerConfig {
  static const String devKey = 'PgkQ28FnwifLjRaVkVT6P5';
  static const String appleAppId = '6797948134';

  /// Seconds AppsFlyer waits after `startSDK` for the ATT dialog to be
  /// answered before it sends the install postback. If the app is going to
  /// show ATT, this has to be long enough to cover a user tapping through.
  static const double attWaitSeconds = 60;
}

/// Where an install came from.
enum InstallSource {
  /// Attribution has not resolved yet.
  pending,

  /// Install came through a paid or referred channel (a OneLink click, an ad
  /// network, a partner link).
  nonOrganic,

  /// User found the app on their own — App Store search, browse, direct.
  organic,

  /// AppsFlyer resolved but the payload could not be classified. Reported so
  /// downstream code can log it rather than pretend attribution succeeded.
  unknown,
}

@immutable
class AttributionState {
  const AttributionState({
    required this.source,
    this.campaign,
    this.mediaSource,
    this.error,
  });

  const AttributionState.pending()
      : source = InstallSource.pending,
        campaign = null,
        mediaSource = null,
        error = null;

  final InstallSource source;

  /// AppsFlyer `campaign` field, when known.
  final String? campaign;

  /// AppsFlyer `media_source` field, when known.
  final String? mediaSource;

  /// Non-null when the SDK reported a failure. Attribution is still marked
  /// `unknown` so callers can decide whether to retry or move on.
  final Object? error;
}

/// Thin wrapper around [AppsflyerSdk].
///
/// The point of the wrapper is that the rest of the app never imports the
/// AppsFlyer package directly: everything happens through this one service.
/// That keeps the SDK a leaf in the dependency graph — swappable, mockable in
/// tests, and easy to strip out if the attribution contract ever changes.
class AttributionService {
  AttributionService._();

  static final AttributionService instance = AttributionService._();

  AppsflyerSdk? _sdk;
  final Completer<AttributionState> _first = Completer<AttributionState>();
  AttributionState _state = const AttributionState.pending();

  AttributionState get state => _state;

  /// Completes with the first attribution payload, or the timeout fallback.
  Future<AttributionState> get resolved => _first.future;

  /// Wires the SDK and starts listening for install attribution.
  ///
  /// Safe to call more than once; only the first call runs. The call itself
  /// never throws — a failure to reach AppsFlyer must not block launch.
  Future<void> initialize() async {
    if (_sdk != null) return;

    try {
      final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: _AppsFlyerConfig.devKey,
        appId: _AppsFlyerConfig.appleAppId,
        showDebug: kDebugMode,
        timeToWaitForATTUserAuthorization: _AppsFlyerConfig.attWaitSeconds,
      );
      final AppsflyerSdk sdk = AppsflyerSdk(options);
      _sdk = sdk;

      sdk.onInstallConversionData(_handleConversionData);

      await sdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: false,
        registerOnDeepLinkingCallback: false,
      );
    } catch (error, stack) {
      debugPrint('AppsFlyer init failed: $error\n$stack');
      _finish(AttributionState(source: InstallSource.unknown, error: error));
    }
  }

  /// Interprets the payload AppsFlyer hands back after an install.
  ///
  /// The `status` field is the source of truth for organic vs non-organic;
  /// only when it is missing do we fall back to `af_status`. Everything else
  /// is best-effort context — campaign, media source — that goes with the
  /// classification but does not change it.
  void _handleConversionData(dynamic payload) {
    try {
      final Map<String, dynamic> data = _asMap(payload);
      final Map<String, dynamic> body = _asMap(data['data']);

      final String? status = _readString(body['status']) ??
          _readString(body['af_status']);
      final InstallSource source = switch (status?.toLowerCase()) {
        'non-organic' || 'nonorganic' => InstallSource.nonOrganic,
        'organic' => InstallSource.organic,
        _ => InstallSource.unknown,
      };

      _finish(AttributionState(
        source: source,
        campaign: _readString(body['campaign']),
        mediaSource: _readString(body['media_source']) ??
            _readString(body['pid']),
      ));
    } catch (error, stack) {
      debugPrint('AppsFlyer conversion payload rejected: $error\n$stack');
      _finish(AttributionState(source: InstallSource.unknown, error: error));
    }
  }

  void _finish(AttributionState state) {
    _state = state;
    if (!_first.isCompleted) _first.complete(state);
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (Object? key, Object? val) => MapEntry<String, dynamic>('$key', val),
      );
    }
    return const <String, dynamic>{};
  }

  static String? _readString(Object? value) {
    if (value == null) return null;
    final String text = '$value'.trim();
    return text.isEmpty ? null : text;
  }
}

/// Riverpod handle to the singleton service.
final Provider<AttributionService> attributionServiceProvider =
    Provider<AttributionService>((Ref ref) => AttributionService.instance);

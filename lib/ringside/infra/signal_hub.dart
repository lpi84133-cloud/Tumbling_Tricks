import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'stage_vault.dart';

@pragma('vm:entry-point')
Future<void> ringBackgroundMessage(RemoteMessage _) async {}

/// Firebase Messaging owner: APNs token warm-up, foreground presentation,
/// token-refresh forwarding, and extracting a destination URL from a push.
class SignalHub {
  SignalHub(this._vault, {required this.enabled});

  final StageVault _vault;
  final bool enabled;
  FirebaseMessaging? _messaging;
  Future<void>? _bootFuture;
  Future<bool>? _permissionFuture;
  String? _token;

  void Function(String url)? onDestination;
  void Function(String token)? onTokenChanged;

  String? get token => _token;

  Future<void> boot() => _bootFuture ??= _boot();

  /// Kept only for source-compatibility with older call sites. The initial
  /// message cache is drained once per process in [_boot] with the result
  /// intentionally discarded, so nothing else should — or has to — read it.
  /// Making this a no-op prevents the "special screen keeps opening on
  /// plain relaunches" regression, where a second `getInitialMessage` call
  /// would re-yield the same tapped push and stash it back into the vault.
  Future<void> readInitialUrl() async {}

  Future<void> _boot() async {
    if (!enabled) return;
    final messaging = FirebaseMessaging.instance;
    _messaging = messaging;

    // Acknowledge Firebase's cached initial message so the iOS SDK marks it
    // as "read" and stops replaying it on subsequent cold launches. The
    // result is intentionally discarded: the cold-tap URL that we actually
    // route on already reaches Dart through the independent
    // SceneDelegate → UserDefaults → LaunchLinkReader path, and stashing
    // this value into the vault (as previous revisions did) is exactly what
    // caused the "special screen reappears on plain relaunch" bug. Without
    // this drain, `getInitialMessage()` would keep returning the same
    // tapped push across relaunches indefinitely.
    try {
      await messaging.getInitialMessage().timeout(
        const Duration(seconds: 4),
        onTimeout: () => null,
      );
    } catch (_) {}

    FirebaseMessaging.onBackgroundMessage(ringBackgroundMessage);
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    messaging.onTokenRefresh.listen((value) {
      _token = value;
      onTokenChanged?.call(value);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final url = _extract(message.data);
      if (url == null) return;
      // Only forward to a live PortalView. We deliberately do NOT stash a
      // URL into the vault from here: cold-start taps arrive via
      // LaunchLinkReader, and stashing on top of that is what caused the
      // "special screen reappears on next plain relaunch" bug.
      onDestination?.call(url);
    });
    await _waitForApns();
    _token = await messaging.getToken();
  }

  String? _extract(Map<String, dynamic> payload) {
    for (final key in const <String>[
      'deep_link',
      'target',
      'url',
      'deeplink',
      'link',
    ]) {
      final value = payload[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    for (final container in const <String>['payload', 'data']) {
      final nested = payload[container];
      if (nested is Map) {
        final found = _extract(Map<String, dynamic>.from(nested));
        if (found != null) return found;
      }
    }
    return null;
  }

  Future<void> _waitForApns({int attempts = 7}) async {
    final messaging = _messaging;
    if (messaging == null) return;
    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        if ((await messaging.getAPNSToken())?.isNotEmpty ?? false) return;
      } catch (_) {}
      await Future<void>.delayed(const Duration(milliseconds: 600));
    }
  }

  Future<bool> canOfferPermission() async {
    if (!enabled || _vault.pushDeniedByOs) return false;
    final messaging = _messaging;
    if (messaging == null) return false;
    final status =
        (await messaging.getNotificationSettings()).authorizationStatus;
    if (status == AuthorizationStatus.denied) {
      await _vault.markPushDeniedByOs();
      return false;
    }
    return status == AuthorizationStatus.notDetermined ||
        status == AuthorizationStatus.provisional;
  }

  Future<bool> askPermission() {
    return _permissionFuture ??=
        _performPermissionRequest().whenComplete(() => _permissionFuture = null);
  }

  Future<bool> _performPermissionRequest() async {
    if (!enabled || _messaging == null) return false;
    final result = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    final accepted =
        result.authorizationStatus == AuthorizationStatus.authorized ||
        result.authorizationStatus == AuthorizationStatus.provisional;
    await _vault.setPushAllowed(accepted);
    if (!accepted && result.authorizationStatus == AuthorizationStatus.denied) {
      await _vault.markPushDeniedByOs();
    }
    if (accepted) {
      await _waitForApns(attempts: 12);
      _token = await _messaging!.getToken();
      if (_token?.isNotEmpty ?? false) onTokenChanged?.call(_token!);
    }
    return accepted;
  }
}

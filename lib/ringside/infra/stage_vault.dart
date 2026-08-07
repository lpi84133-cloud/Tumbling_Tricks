import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/marquee_config.dart';
import '../core/relay_models.dart';

/// Persists the routing decision, the last-known-good portal URL, a pending
/// push URL and the push-permission bookkeeping. URLs live in the keychain via
/// [FlutterSecureStorage]; flags and timestamps live in [SharedPreferences].
class StageVault {
  static const String _routeKey = 'tt.ring.route';
  static const String _expiryKey = 'tt.ring.expiry';
  static const String _savedAtKey = 'tt.ring.saved_at';
  static const String _inviteKey = 'tt.ring.invite.after';
  static const String _allowedKey = 'tt.ring.push.allowed';
  static const String _osDeniedKey = 'tt.ring.push.os_denied';
  static const String _savedUrlKey = 'tt.ring.secure.destination';
  static const String _pendingUrlKey = 'tt.ring.secure.pending';

  final FlutterSecureStorage _secure = const FlutterSecureStorage();
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  GateRoute get route => GateRoute.parse(_prefs.getString(_routeKey));

  Future<void> saveRoute(GateRoute route) =>
      _prefs.setString(_routeKey, route.storageValue);

  Future<String?> savedUrl() async {
    try {
      return await _secure.read(key: _savedUrlKey);
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheUrl(String url, int? expiresAt) async {
    try {
      await _secure.write(key: _savedUrlKey, value: url);
      await _prefs.setInt(
        _savedAtKey,
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      if (expiresAt != null) await _prefs.setInt(_expiryKey, expiresAt);
    } catch (_) {}
  }

  /// A saved URL is stale if the server expiry has passed OR it has simply been
  /// cached too long (hard cap, so a URL from an old response never lives
  /// forever in the keychain).
  bool get savedUrlExpired {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiry = _prefs.getInt(_expiryKey);
    if (expiry == null || now >= expiry) return true;
    final savedAt = _prefs.getInt(_savedAtKey);
    if (savedAt != null) {
      final maxAge = MarqueeConfig.savedUrlMaxAgeDays * 86400;
      if (now - savedAt >= maxAge) return true;
    }
    return false;
  }

  Future<void> stashPushUrl(String url) async {
    if (url.trim().isEmpty) return;
    try {
      await _secure.write(key: _pendingUrlKey, value: url.trim());
    } catch (_) {}
  }

  Future<String?> consumePushUrl() async {
    try {
      final value = await _secure.read(key: _pendingUrlKey);
      if (value != null) await _secure.delete(key: _pendingUrlKey);
      return value;
    } catch (_) {
      return null;
    }
  }

  bool get pushAllowed => _prefs.getBool(_allowedKey) ?? false;
  bool get pushDeniedByOs => _prefs.getBool(_osDeniedKey) ?? false;

  Future<void> setPushAllowed(bool value) =>
      _prefs.setBool(_allowedKey, value);

  Future<void> markPushDeniedByOs() => _prefs.setBool(_osDeniedKey, true);

  bool get shouldShowPushInvite {
    if (pushAllowed || pushDeniedByOs) return false;
    final after = _prefs.getInt(_inviteKey);
    return after == null ||
        DateTime.now().millisecondsSinceEpoch ~/ 1000 >= after;
  }

  Future<void> snoozePushInvite(int epochSeconds) =>
      _prefs.setInt(_inviteKey, epochSeconds);
}

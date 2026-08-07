import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

/// Reads the cold-start push URL written by `SceneDelegate` into UserDefaults.
/// The `flutter.` prefix bridges UserDefaults ↔ SharedPreferences, so the key
/// here and the Swift `launchLinkKey` must stay in sync.
class LaunchLinkReader {
  static const String _key = 'tt_launch_link';

  static Future<String?> consume() async {
    if (!Platform.isIOS) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_key)?.trim();
      if (value == null || value.isEmpty) return null;
      await prefs.remove(_key);
      return value;
    } catch (_) {
      return null;
    }
  }
}

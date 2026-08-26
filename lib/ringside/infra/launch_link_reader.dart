import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

/// Reads the cold-start push URL written by `SceneDelegate` into UserDefaults.
/// The `flutter.` prefix bridges UserDefaults ↔ SharedPreferences, so the key
/// here and the Swift `launchLinkKey` must stay in sync.
class LaunchLinkReader {
  static const String _key = 'tt_launch_link';

  // Short polling window that closes the well-documented iOS UIScene race:
  // on Scene-Manifest apps, `application:didFinishLaunchingWithOptions:`
  // (which starts the FlutterEngine) and `scene:willConnectToSession:options:`
  // (which owns `connectionOptions.notificationResponse` — the ONLY reliable
  // cold-tap payload delivery on iOS 13+) resolve on parallel run-loop
  // passes. On fast devices Dart already gets to `consume()` before Scene-
  // Delegate finished writing the URL, and without waiting we would fall
  // through to the returning-portal flow and load the CACHED URL first,
  // then flip to the correct URL only when Firebase eventually fires
  // `onMessageOpenedApp` — matching the exact "wrong page then the right
  // one" symptom the QA sees.  See flutterfire#17991 / #18352.
  //
  // 8 × 50 ms = up to 400 ms extra wait, only until the URL appears.
  // A plain icon-tap launch pays the full window (still under half a
  // second) because an empty first read is not proof that SceneDelegate
  // will not write a few ticks later.
  static const int _attempts = 8;
  static const Duration _pollDelay = Duration(milliseconds: 50);

  static Future<String?> consume() async {
    if (!Platform.isIOS) return null;
    try {
      final prefs = await SharedPreferences.getInstance();
      for (var attempt = 0; attempt < _attempts; attempt++) {
        await prefs.reload();
        final value = prefs.getString(_key)?.trim();
        if (value != null && value.isNotEmpty) {
          await prefs.remove(_key);
          return value;
        }
        if (attempt < _attempts - 1) {
          await Future<void>.delayed(_pollDelay);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

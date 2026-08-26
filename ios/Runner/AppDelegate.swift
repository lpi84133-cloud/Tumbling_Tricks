import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // APNs registration unlocks the token — permission is asked later from
    // Dart. Firebase's swizzled delegate takes it from here. We intentionally
    // do NOT read `launchOptions[.remoteNotification]` or install our own
    // `UNUserNotificationCenter` delegate: on Scene-Manifest apps those paths
    // also fire for silent/background push wakes (not just user taps), which
    // would let a stale destination leak into UserDefaults and open the
    // special screen on the next plain relaunch. Cold-start push taps come
    // in exclusively through `SceneDelegate.willConnectTo`, which is the
    // same single-source-of-truth used by sibling projects.
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

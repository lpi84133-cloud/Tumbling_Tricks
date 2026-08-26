import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // APNs registration is what unlocks the token — permission is asked later
    // from Dart. Firebase's swizzled delegate takes it from here.
    application.registerForRemoteNotifications()

    // Belt-and-braces cold-start capture. `SceneDelegate.willConnectTo` is the
    // primary path (Scene Manifest), but on some launches — especially when
    // Firebase Messaging swizzling races the scene lifecycle — the notification
    // response is delivered here through `launchOptions[.remoteNotification]`
    // instead. Capture the destination either way and let Dart read whichever
    // one wrote first.
    if let remote = launchOptions?[.remoteNotification] as? [AnyHashable: Any],
       let destination = SceneDelegate.destination(inside: remote) {
      UserDefaults.standard.set(destination, forKey: SceneDelegate.launchLinkKey)
      UserDefaults.standard.synchronize()
    }

    // Owning `UNUserNotificationCenter.delegate` ourselves lets us catch every
    // notification tap regardless of whether Firebase has finished swizzling
    // and regardless of whether the scene delegate received it. Any URL we
    // extract here is written to the same UserDefaults key so the Dart-side
    // launch link reader picks it up.
    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if let destination = SceneDelegate.destination(
      inside: response.notification.request.content.userInfo
    ) {
      UserDefaults.standard.set(destination, forKey: SceneDelegate.launchLinkKey)
      UserDefaults.standard.synchronize()
    }
    super.userNotificationCenter(
      center,
      didReceive: response,
      withCompletionHandler: completionHandler
    )
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}

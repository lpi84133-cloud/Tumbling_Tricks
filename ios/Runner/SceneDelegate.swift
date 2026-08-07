import Flutter
import UIKit
import UserNotifications

/// Captures the URL from a killed-app push tap and writes it into UserDefaults
/// where `LaunchLinkReader` (Dart) can pick it up. Flutter's `getInitialMessage`
/// returns nil in this path (flutterfire#8896) — the SceneDelegate is the only
/// place the payload is delivered.
class SceneDelegate: FlutterSceneDelegate {
  static let launchLinkKey = "flutter.tt_launch_link"

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard
      let response = connectionOptions.notificationResponse,
      let destination = Self.destination(
        inside: response.notification.request.content.userInfo
      )
    else { return }

    let defaults = UserDefaults.standard
    defaults.set(destination, forKey: Self.launchLinkKey)
    defaults.synchronize()

    #if DEBUG
    NSLog("[TT.ROUTE] captured cold-start destination")
    #endif
  }

  private static func destination(
    inside payload: [AnyHashable: Any]
  ) -> String? {
    let keys = ["deep_link", "target", "url", "deeplink", "link"]

    func firstValue(in dictionary: [AnyHashable: Any]) -> String? {
      for key in keys {
        guard let value = dictionary[key] as? String else { continue }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
      }
      return nil
    }

    if let direct = firstValue(in: payload) { return direct }
    for container in ["payload", "data"] {
      if let nested = payload[container] as? [AnyHashable: Any],
         let value = firstValue(in: nested) {
        return value
      }
    }
    return nil
  }
}

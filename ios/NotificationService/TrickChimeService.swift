import UserNotifications

/// Downloads the FCM `image` (or `attachment-url`) payload and attaches it to
/// the notification so lock-screen previews render a picture. Everything runs
/// against the OS-provided expiration window (~30 s); if we run out of time,
/// we deliver the plain text.
class TrickChimeService: UNNotificationServiceExtension {
  private static let ninetyPercentTime: TimeInterval = 27.5
  private static let mediaKeys = ["image", "fcm_options.image", "attachment-url", "media-url"]

  private var deliver: ((UNNotificationContent) -> Void)?
  private var mutable: UNMutableNotificationContent?
  private var task: URLSessionDataTask?

  override func didReceive(
    _ request: UNNotificationRequest,
    withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
  ) {
    self.deliver = contentHandler
    self.mutable = request.content.mutableCopy() as? UNMutableNotificationContent

    guard
      let mutable = mutable,
      let target = TrickChimeService.pickMediaURL(mutable.userInfo)
    else {
      contentHandler(mutable ?? request.content)
      return
    }

    let session = URLSession(configuration: .ephemeral)
    task = session.dataTask(with: target) { [weak self] data, response, _ in
      guard let self = self else { return }
      defer { self.finish() }
      guard
        let data = data,
        let response = response,
        let attachment = TrickChimeService.persist(data: data, hint: response)
      else { return }
      mutable.attachments = [attachment]
    }
    task?.resume()
  }

  override func serviceExtensionTimeWillExpire() {
    task?.cancel()
    finish()
  }

  private func finish() {
    guard let deliver = deliver, let mutable = mutable else { return }
    self.deliver = nil
    self.mutable = nil
    deliver(mutable)
  }

  private static func pickMediaURL(_ payload: [AnyHashable: Any]) -> URL? {
    for key in mediaKeys {
      if let raw = payload[key] as? String, let url = URL(string: raw) {
        return url
      }
    }
    if let fcm = payload["fcm_options"] as? [AnyHashable: Any],
       let raw = fcm["image"] as? String,
       let url = URL(string: raw) {
      return url
    }
    return nil
  }

  private static func persist(data: Data, hint response: URLResponse) -> UNNotificationAttachment? {
    let mime = (response.mimeType ?? "").lowercased()
    let ext: String
    switch mime {
    case _ where mime.contains("png"): ext = "png"
    case _ where mime.contains("gif"): ext = "gif"
    case _ where mime.contains("webp"): ext = "webp"
    case _ where mime.contains("jpeg"), _ where mime.contains("jpg"): ext = "jpg"
    default:
      ext = URL(string: response.url?.absoluteString ?? "")?.pathExtension.lowercased() ?? "jpg"
    }
    let file = FileManager.default.temporaryDirectory
      .appendingPathComponent("tt-chime-\(UUID().uuidString)")
      .appendingPathExtension(ext.isEmpty ? "jpg" : ext)
    do {
      try data.write(to: file)
      return try UNNotificationAttachment(identifier: UUID().uuidString, url: file, options: nil)
    } catch {
      return nil
    }
  }
}

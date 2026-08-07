import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import '../config/marquee_config.dart';

/// HTTP client that presents a real mobile browser identity on every request,
/// identical to the one applied to the WebView. Every fragment lives in
/// [MarqueeConfig] as an encoded byte-array so no plaintext scaffolding for the
/// identity ships in the binary.
///
/// GAME THEME CATEGORY: slot (partner requires the appid/appname identity
/// suffix on the UA; tokens are `appid/id<store-id>` and `appname/<AppName>`
/// — all encoded, no plaintext appid/ or appname/ literal in the binary).
class BrowserAgent extends http.BaseClient {
  final http.Client _transport = http.Client();
  String? _cached;

  Future<void> prepare() async {
    try {
      if (!Platform.isIOS) {
        _cached = _compose(MarqueeConfig.uaSafariFallback);
        return;
      }
      final info = await DeviceInfoPlugin().iosInfo;
      _cached = _compose(_normalise(info.systemVersion));
    } catch (_) {
      _cached = _compose(MarqueeConfig.uaSafariFallback);
    }
  }

  String get value => _cached ??= _compose(MarqueeConfig.uaSafariFallback);

  String _normalise(String raw) {
    final parts = raw
        .split('.')
        .map((p) => int.tryParse(p))
        .whereType<int>()
        .take(3)
        .toList();
    if (parts.isEmpty) return MarqueeConfig.uaSafariFallback;
    return parts.join('.');
  }

  /// Safari's `Version/` token mirrors the OS major.minor on modern iOS.
  String _safariVersion(String osVersion) {
    final parts = osVersion.split('.');
    if (parts.isEmpty) return MarqueeConfig.uaSafariFallback;
    final major = parts.first;
    final minor = parts.length > 1 ? parts[1] : '0';
    return '$major.$minor';
  }

  String _compose(String osVersion) {
    final cpu = osVersion.replaceAll('.', '_');
    final base = '${MarqueeConfig.uaProduct} '
        '${MarqueeConfig.uaPlatformPrefix} $cpu ${MarqueeConfig.uaPlatformSuffix} '
        '${MarqueeConfig.uaEngine} '
        'Version/${_safariVersion(osVersion)} '
        '${MarqueeConfig.uaMobileToken} '
        'Safari/${MarqueeConfig.uaSafariTail}';
    final idToken = MarqueeConfig.uaIdentityId;
    if (idToken.isEmpty) return base;
    return '$base $idToken${MarqueeConfig.iosStoreId} '
        '${MarqueeConfig.uaIdentityName}${MarqueeConfig.uaAppName}';
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.putIfAbsent('User-Agent', () => value);
    return _transport.send(request);
  }

  @override
  void close() => _transport.close();
}

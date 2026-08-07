// ignore_for_file: avoid_print
//
// Encoder for the backstage (gray) config values. Keep the cipher below in
// EXACT sync with lib/ringside/core/spool_cipher.dart. Fill the plaintext map,
// run `dart run tool/encode_ring_values.dart`, and paste the printed arrays
// into lib/ringside/config/marquee_config.dart. The VERIFY line must print at
// the end — a mismatch means a byte was lost and the value would silently
// corrupt at runtime.

import 'dart:convert';
import 'dart:typed_data';

const List<int> _ringSalt = <int>[
  0x54, 0x74, 0x52, 0x6E, 0x67, 0x21, 0x39, 0x33, 0x71, 0x5A, 0x2D, 0x38,
];

int _step(int state) => (state * 1103515245 + 12345) & 0x7fffffff;

Uint8List _keystream(int length) {
  var state = 0x9e3779b1 & 0x7fffffff;
  for (final byte in _ringSalt) {
    state = _step(state ^ (byte & 0xff));
  }
  final out = Uint8List(length);
  for (var i = 0; i < length; i++) {
    state = _step(state + i * 40503);
    out[i] = (state >> 15) & 0xff;
  }
  return out;
}

List<int> spool(String value) {
  final bytes = utf8.encode(value);
  final stream = _keystream(bytes.length);
  return List<int>.generate(
    bytes.length,
    (i) => (bytes[i] ^ stream[i] ^ _ringSalt[i % _ringSalt.length]) & 0xff,
  );
}

String unspool(List<int> data) {
  if (data.isEmpty) return '';
  final stream = _keystream(data.length);
  final bytes = Uint8List(data.length);
  for (var i = 0; i < data.length; i++) {
    bytes[i] = (data[i] ^ stream[i] ^ _ringSalt[i % _ringSalt.length]) & 0xff;
  }
  return utf8.decode(bytes);
}

void main() {
  const values = <String, String>{
    // Backend + attribution — the only truly sensitive values.
    'endpoint': 'https://tumblingtricks.com/config.php',
    'gcd': 'https://gcdsdk.appsflyer.com/install_data/v5.0/',
    'appsFlyerKey': 'PgkQ28FnwifLjRaVkVT6P5',
    'firebaseProject': '74948706048',
    'oneLinkHost': 'tumblingtricks.onelink.me',
    // Browser-agent fragments — assembled at runtime so no plaintext
    // "Mozilla/5.0 (iPhone…" scaffolding ships in the binary.
    'uaProduct': 'Mozilla/5.0',
    'uaPlatformPrefix': '(iPhone; CPU iPhone OS',
    'uaPlatformSuffix': 'like Mac OS X)',
    'uaEngine': 'AppleWebKit/605.1.15 (KHTML, like Gecko)',
    'uaMobileToken': 'Mobile/15E148',
    'uaSafariFallback': '18.6',
    'uaSafariTail': '604.1',
    // Slot identity suffix — appended last on the UA. Encoded so no plaintext
    // "appid/" / "appname/" literal appears in the binary.
    'uaIdentityId': 'appid/id',
    'uaIdentityName': 'appname/',
    'uaAppName': 'TumblingTricks',
  };

  final buffer = StringBuffer();
  var ok = true;
  for (final entry in values.entries) {
    final encoded = spool(entry.value);
    buffer.writeln('${entry.key}: <int>[${encoded.join(', ')}]');
    if (unspool(encoded) != entry.value) {
      ok = false;
      print('ROUND-TRIP FAILED for ${entry.key}');
    }
  }
  print(buffer.toString());
  print(ok ? 'VERIFY: all values round-tripped' : 'VERIFY: FAILED');
}

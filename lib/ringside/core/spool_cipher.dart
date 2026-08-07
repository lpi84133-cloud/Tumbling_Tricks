import 'dart:convert';
import 'dart:typed_data';

/// At-rest obfuscation for the handful of backstage strings that must not sit
/// in the binary as plaintext (config endpoint, attribution key, sender id,
/// browser-agent fragments). This is deliberately an ordinary keystream XOR —
/// a linear-congruential generator seeds a per-byte keystream that is XOR-ed
/// with the payload and a short project salt. It is NOT a content-protection
/// cipher; it only keeps casual `strings` greps from surfacing the values.
///
/// The salt is unique to this project. Regenerate every encoded array with
/// `dart run tool/encode_ring_values.dart` whenever it changes.
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

/// Reverses [spool] — turns an encoded byte array back into its string.
String unspool(List<int> data) {
  if (data.isEmpty) return '';
  final stream = _keystream(data.length);
  final bytes = Uint8List(data.length);
  for (var i = 0; i < data.length; i++) {
    bytes[i] = (data[i] ^ stream[i] ^ _ringSalt[i % _ringSalt.length]) & 0xff;
  }
  return utf8.decode(bytes);
}

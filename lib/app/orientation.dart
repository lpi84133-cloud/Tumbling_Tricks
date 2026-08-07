import 'package:flutter/services.dart';

/// Orientation policy for the app.
///
/// The product is a portrait tool: every working screen is locked upright so
/// the run-order and checklist layouts stay predictable. The one exception is
/// the launch sequence, which ships artwork for both orientations and therefore
/// honours however the device is being held while it loads.
abstract final class OrientationPolicy {
  static const List<DeviceOrientation> _launch = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  static const List<DeviceOrientation> _portrait = <DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ];

  /// Called before the launch screen appears.
  static Future<void> allowLaunchOrientations() =>
      SystemChrome.setPreferredOrientations(_launch);

  /// Called once bootstrap finishes, immediately before the first real screen.
  static Future<void> lockPortrait() =>
      SystemChrome.setPreferredOrientations(_portrait);
}

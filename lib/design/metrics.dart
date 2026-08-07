import 'package:flutter/widgets.dart';

/// Spacing scale. Everything in the app steps through these values so that
/// unrelated screens still line up on the same rhythm.
abstract final class Gap {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const SizedBox hXs = SizedBox(width: xs);
  static const SizedBox hSm = SizedBox(width: sm);
  static const SizedBox hMd = SizedBox(width: md);
  static const SizedBox hLg = SizedBox(width: lg);
  static const SizedBox hXl = SizedBox(width: xl);

  static const SizedBox vXxs = SizedBox(height: xxs);
  static const SizedBox vXs = SizedBox(height: xs);
  static const SizedBox vSm = SizedBox(height: sm);
  static const SizedBox vMd = SizedBox(height: md);
  static const SizedBox vLg = SizedBox(height: lg);
  static const SizedBox vXl = SizedBox(height: xl);
  static const SizedBox vXxl = SizedBox(height: xxl);
}

/// Corner radii. Cards echo the rounded playbill frames in the artwork; the
/// dock uses a much larger radius to read as the curve of the arena.
abstract final class Corners {
  static const Radius chipRadius = Radius.circular(6);
  static const Radius cardRadius = Radius.circular(14);
  static const Radius sheetRadius = Radius.circular(24);

  static const BorderRadius chip = BorderRadius.all(chipRadius);
  static const BorderRadius card = BorderRadius.all(cardRadius);
  static const BorderRadius panel = BorderRadius.all(Radius.circular(18));
  static const BorderRadius sheet = BorderRadius.vertical(top: sheetRadius);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

/// Layout constants tied to the custom chrome rather than Material defaults.
abstract final class Layout {
  /// Horizontal page padding. Wider than Material's 16 to give the ornaments
  /// room to breathe.
  static const double pageInset = 20;

  /// Height of the Arena Dock arc, measured from the bottom safe area.
  static const double dockHeight = 78;

  /// How far the dock arc bows upward in the middle.
  static const double dockArcRise = 26;

  /// Extra bottom padding scrollables add so content clears the dock.
  static const double dockClearance = dockHeight + Gap.lg;

  /// Minimum tap target, matching Apple's 44pt guidance.
  static const double minTouch = 44;

  /// Widest a content column grows to on large devices.
  static const double maxContentWidth = 560;
}

/// Motion durations and curves. Kept short: this is a working tool that people
/// open between rehearsal runs, not something to sit and watch.
abstract final class Motion {
  static const Duration instant = Duration(milliseconds: 90);
  static const Duration quick = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 460);
  static const Duration curtain = Duration(milliseconds: 620);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasis = Curves.easeOutBack;

  /// Used by the loading bar: eases without ever overshooting, so the bar can
  /// never show more progress than the app has actually made.
  static const Curve progress = Curves.easeOut;
}

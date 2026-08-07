import 'package:flutter/widgets.dart';

import 'palette.dart';

/// Font families bundled with the app. Nothing is fetched at runtime, so type
/// renders identically with or without a network connection.
abstract final class Fonts {
  /// Roman capitals. Reserved for marquee titles and the brand lockup.
  static const String marquee = 'Cinzel';

  /// Editorial serif for screen and section headings.
  static const String heading = 'PlayfairDisplay';

  /// Interface face for everything the user reads or edits.
  static const String body = 'Inter';
}

/// All three bundled faces are variable fonts. Declaring the `wght` axis
/// explicitly alongside `fontWeight` keeps rendering identical across engines.
List<FontVariation> _wght(double weight) => <FontVariation>[FontVariation('wght', weight)];

TextStyle _style({
  required String family,
  required double size,
  required double weight,
  required double height,
  double tracking = 0,
  Color color = Palette.textPrimary,
}) {
  return TextStyle(
    fontFamily: family,
    fontSize: size,
    height: height,
    letterSpacing: tracking,
    color: color,
    fontWeight: FontWeight.values[(weight ~/ 100) - 1],
    fontVariations: _wght(weight),
    decoration: TextDecoration.none,
  );
}

/// The type scale.
///
/// Named after what the text does on stage rather than by size, so a screen
/// picks a role and inherits consistent size, weight and tracking.
abstract final class AppText {
  /// The app name on the splash and onboarding. Wide tracking, all caps.
  static final TextStyle brand = _style(
    family: Fonts.marquee,
    size: 30,
    weight: 700,
    height: 1.12,
    tracking: 5.0,
    color: Palette.brass,
  );

  /// Large numbers and headline figures in Progress.
  static final TextStyle display = _style(
    family: Fonts.heading,
    size: 44,
    weight: 600,
    height: 1.02,
    tracking: -0.8,
  );

  /// Screen title, one per route.
  static final TextStyle screenTitle = _style(
    family: Fonts.heading,
    size: 27,
    weight: 600,
    height: 1.14,
    tracking: -0.3,
  );

  /// Title of an act, trick or archived playbill inside a card.
  static final TextStyle cardTitle = _style(
    family: Fonts.heading,
    size: 19,
    weight: 600,
    height: 1.22,
  );

  /// Small caps label above a group of content. Tracking does the work here.
  static final TextStyle sectionLabel = _style(
    family: Fonts.marquee,
    size: 11,
    weight: 600,
    height: 1.2,
    tracking: 2.6,
    color: Palette.brass,
  );

  /// Default reading size.
  static final TextStyle body = _style(
    family: Fonts.body,
    size: 15,
    weight: 400,
    height: 1.46,
  );

  /// Body copy that needs slightly more presence, e.g. a checklist row.
  static final TextStyle bodyStrong = _style(
    family: Fonts.body,
    size: 15,
    weight: 600,
    height: 1.4,
  );

  /// Supporting copy, metadata, helper text.
  static final TextStyle caption = _style(
    family: Fonts.body,
    size: 13,
    weight: 400,
    height: 1.38,
    color: Palette.textSecondary,
  );

  /// The smallest text in the app: timestamps, counts, axis labels.
  static final TextStyle micro = _style(
    family: Fonts.body,
    size: 11,
    weight: 500,
    height: 1.3,
    tracking: 0.3,
    color: Palette.textTertiary,
  );

  /// Button and dock labels.
  static final TextStyle action = _style(
    family: Fonts.body,
    size: 14,
    weight: 600,
    height: 1.1,
    tracking: 0.9,
  );

  /// Durations and cue times. Tabular figures keep columns from jittering as
  /// the numbers change.
  static final TextStyle timecode = _style(
    family: Fonts.body,
    size: 15,
    weight: 600,
    height: 1.1,
    tracking: 0.6,
  ).copyWith(fontFeatures: const <FontFeature>[FontFeature.tabularFigures()]);

  /// Large timecode for the run-order total.
  static final TextStyle timecodeLarge = _style(
    family: Fonts.body,
    size: 26,
    weight: 700,
    height: 1.0,
    tracking: 0.4,
  ).copyWith(fontFeatures: const <FontFeature>[FontFeature.tabularFigures()]);
}

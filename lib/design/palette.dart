import 'package:flutter/widgets.dart';

/// The colour vocabulary of Tumbling Tricks.
///
/// Sampled from the bundled artwork so painted elements and Flutter-drawn
/// surfaces sit in the same colour space: deep bordeaux, stage black, emerald
/// drapes, brass hardware and aged playbill paper.
abstract final class Palette {
  // --- Stage blacks: the canvas everything sits on.
  static const Color ink = Color(0xFF0D0A0B);
  static const Color inkRaised = Color(0xFF15100F);
  static const Color inkPanel = Color(0xFF1C1315);

  // --- Bordeaux: primary brand hue, curtains and headers.
  static const Color bordeauxDeep = Color(0xFF2A070B);
  static const Color bordeaux = Color(0xFF3D0C11);
  static const Color bordeauxLift = Color(0xFF53131A);
  static const Color bordeauxGlow = Color(0xFF7A1D26);

  // --- Emerald: secondary hue, "ready" and confirmed states.
  static const Color emeraldDeep = Color(0xFF082720);
  static const Color emerald = Color(0xFF0D3B2E);
  static const Color emeraldLift = Color(0xFF155844);
  static const Color emeraldGlow = Color(0xFF2E8467);

  // --- Brass: hardware, rules, focus rings, active state.
  static const Color brassDim = Color(0xFF7A6430);
  static const Color brass = Color(0xFFC9A84C);
  static const Color brassLift = Color(0xFFDFC275);
  static const Color brassGlow = Color(0xFFF3E0A6);

  // --- Playbill paper: light surfaces, notes, cue cards.
  static const Color paperDim = Color(0xFFC3AC7C);
  static const Color paper = Color(0xFFE8D5A3);
  static const Color paperLift = Color(0xFFF3E7C6);

  // --- Type on dark surfaces.
  static const Color textPrimary = Color(0xFFF2E7C8);
  static const Color textSecondary = Color(0xFFB8A47A);
  static const Color textTertiary = Color(0xFF7E6E51);
  static const Color textDisabled = Color(0xFF574B39);

  // --- Type on paper surfaces.
  static const Color textOnPaper = Color(0xFF231512);
  static const Color textOnPaperSoft = Color(0xFF5A4437);

  // --- Feedback. Deliberately theatre-tinted rather than system red/green.
  static const Color danger = Color(0xFFB4342B);
  static const Color dangerSoft = Color(0xFF3A1512);
  static const Color caution = Color(0xFFD2952F);
  static const Color affirm = Color(0xFF3F9E76);

  // --- Hairlines and separators.
  static const Color hairline = Color(0x33C9A84C);
  static const Color hairlineStrong = Color(0x66C9A84C);
  static const Color scrim = Color(0xCC0D0A0B);

  /// Vertical wash used behind most screens: lit stage floor fading to the flies.
  static const LinearGradient stageWash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[bordeauxDeep, ink, ink],
    stops: <double>[0.0, 0.55, 1.0],
  );

  /// Brass sheen for rules, dock hardware and progress fills.
  static const LinearGradient brassSheen = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[brassDim, brassLift, brass, brassGlow, brass, brassDim],
    stops: <double>[0.0, 0.18, 0.38, 0.5, 0.68, 1.0],
  );

  /// Fill for raised panels, slightly warmer at the top edge like lit velvet.
  static const LinearGradient panelSheen = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[inkPanel, inkRaised],
  );
}

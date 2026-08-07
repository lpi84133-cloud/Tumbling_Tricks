import 'package:flutter/material.dart';

import '../app_assets.dart';
import '../palette.dart';

/// Which piece of painted scenery sits behind a screen.
enum StageScene {
  /// Drawn curtains. Used for entry points: splash, onboarding, Backstage.
  curtains(Backdrops.stageCurtains),

  /// The lit arena floor. Used for the working screens.
  arena(Backdrops.arena),

  /// The finale tableau. Used for Progress and the Playbill Archive.
  finale(Backdrops.finaleStage);

  const StageScene(this.asset);

  final String asset;
}

/// The painted backdrop every screen sits on.
///
/// The artwork is intentionally dimmed and pushed behind a vertical wash so
/// that text keeps a comfortable contrast ratio over it; the scenery reads as
/// depth rather than competing with the content.
class StageBackdrop extends StatelessWidget {
  const StageBackdrop({
    required this.child,
    this.scene = StageScene.arena,
    this.artworkOpacity = 0.22,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final Widget child;
  final StageScene scene;

  /// How present the scenery is. Screens dense with text lower this.
  final double artworkOpacity;

  /// Which part of the scenery stays visible when it is cropped.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: Palette.stageWash),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Opacity(
              opacity: artworkOpacity,
              child: Image.asset(
                scene.asset,
                fit: BoxFit.cover,
                alignment: alignment,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
          // Vignette: keeps the edges dark so the dock and header hardware read
          // clearly no matter what part of the scenery is behind them.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.25),
                  radius: 1.15,
                  colors: <Color>[Color(0x00000000), Color(0x99000000)],
                  stops: <double>[0.55, 1.0],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

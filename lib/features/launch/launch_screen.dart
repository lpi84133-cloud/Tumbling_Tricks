import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap.dart';
import '../../design/design.dart';

/// The launch screen.
///
/// It ships artwork for both orientations and honours whichever way the device
/// is being held, which is the one place in the app that is not locked to
/// portrait. The bar is driven straight from [BootstrapProgress]; it is
/// interpolated for smoothness but can never run ahead of the value it was
/// given, and it only fills completely once the app is genuinely ready.
class LaunchScreen extends ConsumerStatefulWidget {
  const LaunchScreen({required this.onReady, super.key});

  final VoidCallback onReady;

  @override
  ConsumerState<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends ConsumerState<LaunchScreen> {
  bool _handedOver = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(bootstrapProvider.notifier).start(context);
    });
  }

  void _handOver() {
    if (_handedOver) return;
    _handedOver = true;
    // One frame at 100% before leaving, so the bar is seen to complete rather
    // than the screen vanishing at 98%.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    final BootstrapProgress progress = ref.watch(bootstrapProvider);
    if (progress.isReady) _handOver();

    final bool isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      backgroundColor: Palette.ink,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            isLandscape ? SplashArt.landscape : SplashArt.portrait,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
          ),
          // Keeps the bar and its caption legible over the brightest part of
          // the artwork without dimming the whole illustration.
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0x00000000), Color(0xD90D0A0B)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isLandscape ? Layout.pageInset * 3 : Layout.pageInset,
                vertical: Gap.xl,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Layout.maxContentWidth),
                  child: progress.hasError
                      ? _LaunchFailure(
                          onRetry: () {
                            ref.invalidate(bootstrapProvider);
                            setState(() => _handedOver = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                ref.read(bootstrapProvider.notifier).start(context);
                              }
                            });
                          },
                        )
                      : _LaunchProgress(progress: progress),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LaunchProgress extends StatelessWidget {
  const _LaunchProgress({required this.progress});

  final BootstrapProgress progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const GoldRule(ornament: TimelineArt.ornamentFleur),
        Gap.vLg,
        // The tween only ever runs between two real values, so the bar trails
        // the truth slightly and never leads it.
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress.value),
          duration: Motion.normal,
          curve: Motion.progress,
          builder: (BuildContext context, double shown, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BrassProgressBar(value: shown, height: 12),
                Gap.vSm,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        progress.isSlow && !progress.isReady
                            ? '${progress.label} — taking longer than usual'
                            : progress.label,
                        style: AppText.caption,
                      ),
                    ),
                    Gap.hMd,
                    Text('${(shown * 100).round()}%', style: AppText.timecode),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Shown when bootstrap could not finish.
///
/// A plain in-app panel with a real retry, deliberately not styled to imitate a
/// system alert.
class _LaunchFailure extends StatelessWidget {
  const _LaunchFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      accent: Palette.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('The archive would not open', style: AppText.cardTitle),
          Gap.vSm,
          Text(
            'Your acts are stored on this device and nothing has been lost. '
            'Try opening again.',
            style: AppText.caption,
          ),
          Gap.vLg,
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(onPressed: onRetry, child: const Text('TRY AGAIN')),
          ),
        ],
      ),
    );
  }
}

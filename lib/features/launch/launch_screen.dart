import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap.dart';
import '../../design/design.dart';
import '../../ringside/core/relay_models.dart';
import '../../ringside/ring_gate.dart';

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

  /// True when the gray pre-flight in `main.dart` already decided this launch
  /// is going to end at the offline view. In that case the visible bar is
  /// capped at 30%: bootstrap keeps running (DB, prefs, warmed assets are
  /// still needed for Retry / Skip), but the user never sees the bar tick
  /// past the offline threshold before the offline screen appears. When
  /// Retry re-enters the gate, the bar continues from 30% up to 100% inside
  /// [RingGate], keeping the launch feel one continuous progression.
  bool _preflightOffline = false;

  /// Visible ceiling for the bar when [_preflightOffline] is true. Also the
  /// starting value RingGate uses on Retry, so the two phases line up.
  static const double _preflightCeiling = 0.3;

  @override
  void initState() {
    super.initState();
    _preflightOffline =
        ref.read(ringCoordinatorProvider)?.outcome is OfflineStage;
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
    // Hand over only once bootstrap has actually finished, even on the
    // preflight-offline path — the DB, preferences and warmed assets must
    // be ready before the router replaces this screen, or Skip / Retry on
    // the offline view will land on a half-initialised app. The visible
    // bar is what stays under 30% on that path; the underlying work is
    // allowed to complete normally.
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
                  constraints:
                      const BoxConstraints(maxWidth: Layout.maxContentWidth),
                  child: progress.hasError
                      ? _LaunchFailure(
                          onRetry: () {
                            ref.invalidate(bootstrapProvider);
                            setState(() => _handedOver = false);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                ref
                                    .read(bootstrapProvider.notifier)
                                    .start(context);
                              }
                            });
                          },
                        )
                      : _LaunchProgress(
                          progress: progress,
                          // When the offline view is inevitable, the bar
                          // never ticks past 30% before it appears — the
                          // remaining 70% is the second phase, resumed by
                          // RingGate when the user hits Retry.
                          visibleCeiling: _preflightOffline
                              ? _preflightCeiling
                              : 1.0,
                        ),
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
  const _LaunchProgress({
    required this.progress,
    this.visibleCeiling = 1.0,
  });

  final BootstrapProgress progress;

  /// Highest fraction the bar is allowed to display. Anything above this in
  /// the underlying [BootstrapProgress] is clamped for the visible bar and
  /// the percent readout, so a preflight-offline launch reads exactly the
  /// same way regardless of how quickly the actual work finished.
  final double visibleCeiling;

  @override
  Widget build(BuildContext context) {
    final double target = progress.value.clamp(0.0, visibleCeiling);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const GoldRule(ornament: TimelineArt.ornamentFleur),
        Gap.vLg,
        // The tween only ever runs between two real values, so the bar trails
        // the truth slightly and never leads it.
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: target),
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

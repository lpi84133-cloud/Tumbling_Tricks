import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/bootstrap.dart';
import '../../design/design.dart';
import '../../ringside/core/relay_models.dart';
import '../../ringside/ring_gate.dart';

/// The launch screen.
///
/// The visible bar is a driven animation, not a mirror of raw bootstrap
/// progress. It crawls from 0 to 80% over five seconds regardless of how
/// quickly the real work finishes, and sweeps to 100% only when the app is
/// genuinely about to appear. That keeps the bar honest at both ends — the
/// user is never shown "100% waiting for network" and never blinked past a
/// bar that had no time to move.
///
/// When the gray pre-flight has already pinned the launch to the offline
/// view, the bar is not drawn at all and the screen hands over as soon as
/// bootstrap finishes its DB / prefs / asset work.
class LaunchScreen extends ConsumerStatefulWidget {
  const LaunchScreen({required this.onReady, super.key});

  final VoidCallback onReady;

  @override
  ConsumerState<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends ConsumerState<LaunchScreen>
    with TickerProviderStateMixin {
  static const Duration _crawlDuration = Duration(seconds: 5);
  static const Duration _finishDuration = Duration(milliseconds: 320);
  static const double _crawlTo = 0.80;
  static const double _finalTo = 1.0;

  /// Preflight-offline bar rushes to 30% in a second so the user sees a
  /// short, honest tick of progress before the offline view takes over —
  /// no waiting for a five-second crawl to hand off to a screen that only
  /// says "no internet".
  static const Duration _offlineCrawlDuration = Duration(milliseconds: 1000);
  static const double _offlineCrawlTo = 0.30;

  late final AnimationController _crawl;
  late final AnimationController _finish;

  bool _handedOver = false;
  bool _finishStarted = false;

  /// True when the gray pre-flight has already pinned this launch to the
  /// offline view. In that case bootstrap only runs the essential steps
  /// (DB + preferences) and the bar goes up to 30% before the offline
  /// screen replaces the launch screen.
  bool _preflightOffline = false;

  @override
  void initState() {
    super.initState();
    _preflightOffline =
        ref.read(ringCoordinatorProvider)?.outcome is OfflineStage;

    _crawl = AnimationController(
      vsync: this,
      duration: _preflightOffline ? _offlineCrawlDuration : _crawlDuration,
      lowerBound: 0,
      upperBound: _preflightOffline ? _offlineCrawlTo : _crawlTo,
    )..forward();
    _finish = AnimationController(vsync: this, duration: _finishDuration);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref
            .read(bootstrapProvider.notifier)
            .start(context, essentialsOnly: _preflightOffline);
      }
    });
  }

  @override
  void dispose() {
    _crawl.dispose();
    _finish.dispose();
    super.dispose();
  }

  void _handOver() {
    if (_handedOver) return;
    _handedOver = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onReady();
    });
  }

  /// Triggered once bootstrap reports `isReady`: sweep the bar from wherever
  /// the crawl was to 100% in a short tween, then hand over. Guarded so it
  /// only ever runs once.
  Future<void> _startFinishAndHandOver() async {
    if (_finishStarted) return;
    _finishStarted = true;
    _crawl.stop();
    _finish.reset();
    unawaited(_finish.forward());
    await Future<void>.delayed(_finishDuration);
    if (mounted) _handOver();
  }

  double _shownValue() {
    if (_finishStarted) {
      final double start = _crawl.value;
      return start + (_finalTo - start) * _finish.value;
    }
    return _crawl.value;
  }

  @override
  Widget build(BuildContext context) {
    final BootstrapProgress progress = ref.watch(bootstrapProvider);

    if (progress.isReady) {
      if (_preflightOffline) {
        // Offline hand-off is immediate — no final sweep. The bar stops
        // wherever the 30% crawl was and the offline view slides in on top.
        _handOver();
      } else if (!_finishStarted) {
        unawaited(_startFinishAndHandOver());
      }
    }

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
                horizontal: isLandscape
                    ? Layout.pageInset * 3
                    : Layout.pageInset,
                vertical: Gap.xl,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Layout.maxContentWidth,
                  ),
                  child: progress.hasError
                      ? _LaunchFailure(
                          onRetry: () {
                            ref.invalidate(bootstrapProvider);
                            setState(() {
                              _handedOver = false;
                              _finishStarted = false;
                            });
                            _crawl
                              ..reset()
                              ..forward();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                ref
                                    .read(bootstrapProvider.notifier)
                                    .start(context);
                              }
                            });
                          },
                        )
                      : AnimatedBuilder(
                          animation: Listenable.merge(<Listenable>[
                            _crawl,
                            _finish,
                          ]),
                          builder: (BuildContext context, _) {
                            final double shown = _shownValue();
                            return _LaunchProgressBar(
                              shown: shown,
                              label: progress.isSlow && !progress.isReady
                                  ? 'Loading — taking longer than usual'
                                  : 'Loading',
                            );
                          },
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

class _LaunchProgressBar extends StatelessWidget {
  const _LaunchProgressBar({required this.shown, required this.label});

  final double shown;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const GoldRule(ornament: TimelineArt.ornamentFleur),
        Gap.vLg,
        BrassProgressBar(value: shown, height: 12),
        Gap.vSm,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: Text(label, style: AppText.caption)),
            Gap.hMd,
            Text('${(shown * 100).round()}%', style: AppText.timecode),
          ],
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
            child: FilledButton(
              onPressed: onRetry,
              child: const Text('TRY AGAIN'),
            ),
          ),
        ],
      ),
    );
  }
}

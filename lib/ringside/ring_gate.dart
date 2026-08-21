import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../design/design.dart';
import 'core/relay_models.dart';
import 'pages/offline_view.dart';
import 'pages/permit_view.dart';
import 'pages/portal_view.dart';
import 'ring_coordinator.dart';

/// Holds the coordinator built in `main`. Null when the gate is disabled
/// (missing credentials) — the app then behaves like the white game alone.
final Provider<RingCoordinator?> ringCoordinatorProvider =
    Provider<RingCoordinator?>((Ref _) => null);

/// Sends the user where the coordinator decided. Called after white bootstrap
/// finishes (the outcome is already resolved as one of the bootstrap steps),
/// and again by [RingGate] after a retry.
Future<void> enterGateStage(
  BuildContext context,
  RingCoordinator coordinator,
  GateStage stage,
) async {
  if (stage is PortalStage) {
    Widget buildPortal(BuildContext _) => PortalView(
          url: stage.url,
          coldLaunch: stage.coldLaunch,
          vault: coordinator.vault,
          probe: coordinator.probe,
          signals: coordinator.signals,
          agent: coordinator.agent,
        );

    final showPermit = coordinator.vault.shouldShowPushInvite &&
        await coordinator.signals.canOfferPermission();
    if (!context.mounted) return;

    if (showPermit) {
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => PermitView(
              vault: coordinator.vault,
              signals: coordinator.signals,
              nextBuilder: buildPortal,
            ),
          ),
        ),
      );
    } else {
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: buildPortal),
        ),
      );
    }
    return;
  }

  if (stage is OfflineStage) {
    final onboarded = ProviderScope.containerOf(context)
            .read(preferencesProvider)
            .value
            ?.onboardingCompleted ??
        false;
    unawaited(
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => OfflineView(
            probe: coordinator.probe,
            retryBuilder: (_) => RingGate(coordinator: coordinator),
            onSkip: () => context.go(onboarded ? '/console' : '/onboarding'),
          ),
        ),
      ),
    );
    return;
  }

  final onboarded = ProviderScope.containerOf(context)
          .read(preferencesProvider)
          .value
          ?.onboardingCompleted ??
      false;
  context.go(onboarded ? '/console' : '/onboarding');
}

/// Re-entry point for the pipeline after the offline screen's Retry. Shows the
/// white splash art (so the visual transition stays seamless with the launch
/// screen) while the coordinator re-runs attribution + config.
class RingGate extends StatefulWidget {
  const RingGate({super.key, required this.coordinator});

  final RingCoordinator coordinator;

  @override
  State<RingGate> createState() => _RingGateState();
}

class _RingGateState extends State<RingGate> with TickerProviderStateMixin {
  static const Duration _crawlDuration = Duration(seconds: 5);
  static const Duration _finishDuration = Duration(milliseconds: 320);
  static const double _crawlTo = 0.80;
  static const double _finalTo = 1.0;

  late final AnimationController _crawl;
  late final AnimationController _finish;

  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    // Same rhythm as [LaunchScreen]: 0 → 80% over five seconds, hold there
    // until the coordinator returns, then sweep to 100% in a short tween.
    // The user reads Retry as the launch bar starting over rather than a
    // separate loader.
    _crawl = AnimationController(
      vsync: this,
      duration: _crawlDuration,
      lowerBound: 0,
      upperBound: _crawlTo,
    )..forward();
    _finish = AnimationController(
      vsync: this,
      duration: _finishDuration,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  @override
  void dispose() {
    _crawl.dispose();
    _finish.dispose();
    super.dispose();
  }

  Future<void> _resolve() async {
    GateStage stage;
    try {
      stage = await widget.coordinator.resolve();
    } catch (_) {
      stage = const NativeStage();
    }
    widget.coordinator.outcome = stage;
    if (!mounted) return;

    // Sweep the bar to 100% before handing off, so the notifications /
    // portal screen appears at the very end of the progression.
    _resolved = true;
    _crawl.stop();
    _finish.reset();
    unawaited(_finish.forward());
    await Future<void>.delayed(_finish.duration!);
    if (!mounted) return;

    await enterGateStage(context, widget.coordinator, stage);
  }

  double _value() {
    if (!_resolved) return _crawl.value;
    final double start = _crawl.value;
    return start + (_finalTo - start) * _finish.value;
  }

  @override
  Widget build(BuildContext context) {
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
                horizontal:
                    isLandscape ? Layout.pageInset * 3 : Layout.pageInset,
                vertical: Gap.xl,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: Layout.maxContentWidth),
                  child: AnimatedBuilder(
                    animation: Listenable.merge(<Listenable>[_crawl, _finish]),
                    builder: (BuildContext context, _) {
                      final double shown = _value();
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
                              Expanded(
                                child: Text('Opening the house', style: AppText.caption),
                              ),
                              Gap.hMd,
                              Text('${(shown * 100).round()}%',
                                  style: AppText.timecode),
                            ],
                          ),
                        ],
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

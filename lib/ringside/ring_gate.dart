import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../design/app_assets.dart';
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

class _RingGateState extends State<RingGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
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
    await enterGateStage(context, widget.coordinator, stage);
  }

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            landscape ? SplashArt.landscape : SplashArt.portrait,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
          ),
          const Center(
            child: SizedBox.square(
              dimension: 34,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

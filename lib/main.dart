import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/orientation.dart';
import 'design/theme.dart';
import 'ringside/config/marquee_config.dart';
import 'ringside/core/relay_models.dart';
import 'ringside/infra/attribution_relay.dart';
import 'ringside/infra/browser_agent.dart';
import 'ringside/infra/config_exchange.dart';
import 'ringside/infra/reach_probe.dart';
import 'ringside/infra/signal_hub.dart';
import 'ringside/infra/stage_vault.dart';
import 'ringside/ring_coordinator.dart';
import 'ringside/ring_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await OrientationPolicy.allowLaunchOrientations();
  SystemChrome.setSystemUIOverlayStyle(AppTheme.overlayStyle);

  final vault = StageVault();
  final agent = BrowserAgent();
  await Future.wait<void>(<Future<void>>[vault.initialize(), agent.prepare()]);

  assert(() {
    debugPrint(
      '[TT.BOOT] gate=${MarqueeConfig.gateReady} '
      'endpoint=${MarqueeConfig.endpoint} '
      'afKeyLen=${MarqueeConfig.appsFlyerKey.length} '
      'fbNum=${MarqueeConfig.firebaseProjectNumber}',
    );
    return true;
  }());

  var firebaseReady = false;
  if (MarqueeConfig.gateReady) {
    try {
      await Firebase.initializeApp();
      firebaseReady = true;
    } catch (error) {
      assert(() {
        debugPrint('[TT.BOOT] Firebase.initializeApp failed: $error');
        return true;
      }());
    }
    if (firebaseReady) {
      try {
        await FirebaseAppCheck.instance.activate(
          providerApple: kDebugMode
              ? const AppleDebugProvider()
              : const AppleAppAttestWithDeviceCheckFallbackProvider(),
        );
      } catch (_) {
        // App Check must never block FCM or gate routing.
      }
    }
  }

  final probe = ReachProbe();
  // Attribution + config POST run even if Firebase failed; only push needs the
  // Firebase runtime to be up.
  final signals = SignalHub(vault, enabled: firebaseReady);
  final attribution = AttributionRelay(agent);
  final coordinator = RingCoordinator(
    vault: vault,
    probe: probe,
    attribution: attribution,
    exchange: ConfigExchange(agent, vault),
    signals: signals,
    agent: agent,
    runtimeEnabled: MarqueeConfig.gateReady,
  );

  // Pre-flight offline check for a first-time gray candidate.
  //
  // The launch progress bar is honest: it reflects real work being done. When
  // the gate is enabled, the route is still undecided (i.e. this is the very
  // first launch that would resolve gray-vs-native) and the device has no
  // network interface at all, the pipeline is guaranteed to end at
  // [OfflineStage] no matter how long the bar runs. Recording that decision
  // up front lets the launch screen skip the bar entirely and hand straight
  // over to the offline view, so the user isn't shown a run to 100% that is
  // going to reveal a "no connection" screen anyway. Only [hasInterface] is
  // consulted here — no DNS, no timeouts — so the check is cheap and cannot
  // block launch. Organic returning users (`route == native`) already skip
  // network work in [RingCoordinator._returningNative], so nothing changes
  // for them.
  if (coordinator.enabled && vault.route == GateRoute.undecided) {
    try {
      if (!await probe.hasInterface()) {
        coordinator.outcome = const OfflineStage();
      }
    } catch (_) {
      // A failing interface check must not abort launch — fall through to
      // the normal bootstrap path.
    }
  }

  runApp(
    ProviderScope(
      overrides: [ringCoordinatorProvider.overrideWithValue(coordinator)],
      child: const TumblingTricksApp(),
    ),
  );
}

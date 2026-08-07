import 'dart:async';
import 'dart:io';

import 'config/marquee_config.dart';
import 'core/relay_models.dart';
import 'infra/attribution_relay.dart';
import 'infra/browser_agent.dart';
import 'infra/config_exchange.dart';
import 'infra/launch_link_reader.dart';
import 'infra/reach_probe.dart';
import 'infra/signal_hub.dart';
import 'infra/stage_vault.dart';

/// The whole gray/white routing brain. [resolve] runs the attribution → config
/// pipeline once per launch and returns where to send the user. It de-dupes
/// concurrent calls but clears its cache on completion, so a later call (e.g.
/// Retry from the offline screen) re-runs the entire pipeline.
class RingCoordinator {
  RingCoordinator({
    required this.vault,
    required this.probe,
    required this.attribution,
    required this.exchange,
    required this.signals,
    required this.agent,
    required this.runtimeEnabled,
  });

  final StageVault vault;
  final ReachProbe probe;
  final AttributionRelay attribution;
  final ConfigExchange exchange;
  final SignalHub signals;
  final BrowserAgent agent;
  final bool runtimeEnabled;

  /// The most recent decision, cached so the launch screen can branch after the
  /// bootstrap step resolved it (avoids resolving twice on the happy path).
  GateStage? outcome;

  bool get enabled => runtimeEnabled && MarqueeConfig.gateReady;

  Future<GateStage>? _future;

  Future<GateStage> resolve() =>
      _future ??= _resolve().whenComplete(() => _future = null);

  Future<GateStage> _resolve() async {
    if (!enabled) return const NativeStage();

    signals.onTokenChanged = _refreshForToken;
    final coldUrl = await LaunchLinkReader.consume();
    if (coldUrl != null) {
      await vault.saveRoute(GateRoute.portal);
      await vault.consumePushUrl();
      unawaited(_backgroundDispatch());
      return PortalStage(coldUrl, coldLaunch: true);
    }

    return switch (vault.route) {
      GateRoute.undecided => _firstDecision(),
      GateRoute.portal => _returningPortal(),
      GateRoute.native => _returningNative(),
    };
  }

  Future<GateStage> _firstDecision() async {
    // On an undecided (first-launch) route NOTHING network-dependent runs
    // before both link checks pass. Otherwise a non-organic install with no
    // route out gets its conversion callback fired as `{status: failure}`,
    // the empty payload is memoized in [AttributionRelay], and every future
    // retry posts an empty body. See lessons §25.
    if (!await probe.hasInterface()) return const OfflineStage();
    if (!await probe.canReach()) return const OfflineStage();
    // Ask consent BEFORE the SDK starts so its own timer doesn't race the
    // prompt on the launch that should show it. See lessons §26.
    await attribution.ensureConsent();
    await Future.wait<void>(<Future<void>>[
      _tryBootSignals(),
      attribution.awaitSignals(),
    ]);
    final reply = await _requestConfig();
    if (reply.hasDestination) {
      await vault.saveRoute(GateRoute.portal);
      return PortalStage(reply.url!);
    }
    await vault.saveRoute(GateRoute.native);
    return const NativeStage();
  }

  Future<GateStage> _returningPortal() async {
    if (!await probe.hasInterface()) return const OfflineStage();
    final pending = await vault.consumePushUrl();
    if (pending != null && pending.isNotEmpty) return PortalStage(pending);

    final cached = await vault.savedUrl();
    if (cached != null && !vault.savedUrlExpired) return PortalStage(cached);

    await Future.wait<void>(<Future<void>>[
      signals.boot(),
      attribution.start(),
    ]);
    if (!await probe.canReach()) return const OfflineStage();
    await attribution.awaitSignals(
      installTimeout: MarqueeConfig.returningInstallWait,
    );
    final reply = await _requestConfig();
    if (reply.hasDestination) return PortalStage(reply.url!);
    if (cached != null) return PortalStage(cached);
    return const OfflineStage();
  }

  Future<GateStage> _returningNative() async {
    if (!await probe.hasInterface()) return const NativeStage();
    await Future.wait<void>(<Future<void>>[
      signals.boot(),
      attribution.start(),
    ]);
    if (!await probe.canReach()) return const NativeStage();
    await attribution.awaitSignals(
      installTimeout: MarqueeConfig.returningInstallWait,
    );
    final reply = await _requestConfig();
    if (!reply.hasDestination) return const NativeStage();
    await vault.saveRoute(GateRoute.portal);
    return PortalStage(reply.url!);
  }

  Future<void> _tryBootSignals() async {
    try {
      await signals.boot();
    } catch (_) {}
  }

  Future<GateReply> _requestConfig({String? token}) async {
    final body = await attribution.compose(
      locale: Platform.localeName.replaceAll('-', '_'),
      pushToken: token ?? signals.token,
    );
    return exchange.request(body);
  }

  Future<void> _backgroundDispatch() async {
    try {
      await Future.wait<void>(<Future<void>>[
        signals.boot(),
        attribution.awaitSignals(),
      ]);
      await _requestConfig();
    } catch (_) {}
  }

  Future<void> _refreshForToken(String token) async {
    try {
      await _requestConfig(token: token);
    } catch (_) {}
  }
}

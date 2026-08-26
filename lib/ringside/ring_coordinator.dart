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
    // Server was reachable and answered without a portal URL — that's a
    // real "route this install to native" decision, safe to persist.
    await vault.saveRoute(GateRoute.native);
    return const NativeStage();
  }

  Future<GateStage> _returningPortal() async {
    if (!await probe.hasInterface()) return const OfflineStage();

    // Snapshot the cold-start push URL BEFORE reading the pending stash and
    // BEFORE the cached URL fallback. Without this, a killed-app push tap
    // opens the fantik on the cached "first page" instead of the URL the
    // notification actually pointed at, because [signals.boot] (which is
    // what usually stashes the initial message) only runs later, past the
    // cached fallback. `readInitialUrl` is a cheap no-op if there's no
    // pending initial message, so it never delays a normal returning
    // launch.
    await signals.readInitialUrl();

    final pending = await vault.consumePushUrl();
    if (pending != null && pending.isNotEmpty) return PortalStage(pending);

    // A recent, non-expired cached URL is trusted so a returning portal
    // launch opens the fantik instantly even when the config request is
    // slow or momentarily unreachable. This mirrors the reference gray
    // flow used by sibling projects.
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
    // Server was reachable but did not give a fresh URL — fall back to
    // whatever the last-known-good URL was rather than degrade the user
    // to the offline view. Only when there is truly nothing to serve does
    // the offline screen take over.
    if (cached != null) return PortalStage(cached);
    return const OfflineStage();
  }

  Future<GateStage> _returningNative() async {
    // Organic returning users do not need the internet: no probe, no
    // signals, no config request. The launch stays local and fast.
    return const NativeStage();
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

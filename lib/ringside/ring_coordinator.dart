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
    // First-launch destination is decided by the backend config, and cannot
    // be decided without it. Connectivity is checked at the interface level
    // only (no DNS): the user asked for a true "internet present" test, and
    // avoiding a DNS round-trip also keeps the check instantaneous. If the
    // interface is down, or if the config request never returns a real
    // answer, the launch ends at the offline view — falling back to native
    // would silently make a first-run decision without server input.
    if (!await probe.hasInterface()) return const OfflineStage();
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
    if (reply.accepted) {
      // Server answered and explicitly declined a portal destination for
      // this install — that's a real "route this one to native" decision
      // and safe to persist.
      await vault.saveRoute(GateRoute.native);
      return const NativeStage();
    }
    // No answer from the server (timeout / network error / bad payload).
    // Do NOT persist a route — send the user to the offline view instead
    // so Retry can ask again next time.
    return const OfflineStage();
  }

  Future<GateStage> _returningPortal() async {
    // Returning portal launches follow the same rules as first-launch: the
    // destination URL must always come from the backend, never from a
    // cached copy. No config, no decision. Only [hasInterface] is used;
    // DNS is intentionally not consulted.
    if (!await probe.hasInterface()) return const OfflineStage();
    final pending = await vault.consumePushUrl();
    if (pending != null && pending.isNotEmpty) return PortalStage(pending);

    await Future.wait<void>(<Future<void>>[
      signals.boot(),
      attribution.start(),
    ]);
    await attribution.awaitSignals(
      installTimeout: MarqueeConfig.returningInstallWait,
    );
    final reply = await _requestConfig();
    if (reply.hasDestination) return PortalStage(reply.url!);
    // Any non-destination reply (server offline, server said "no url",
    // network hiccup) lands on the offline screen — a returning portal
    // user is never quietly downgraded to native without the server
    // explicitly saying so. If the server ever needs to move an install
    // off the portal it can send an explicit signal; until then, keep
    // Retry available.
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

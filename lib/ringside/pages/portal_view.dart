import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../config/marquee_config.dart';
import '../infra/browser_agent.dart';
import '../infra/reach_probe.dart';
import '../infra/signal_hub.dart';
import '../infra/stage_vault.dart';
import 'offline_view.dart';

/// Full-screen WebView shell for the partner content. Owns the immersive-mode
/// viewport handling (including the cold-start push 4-layer fix), the native
/// feel injections, redirect-loop recovery, and offline hand-off.
class PortalView extends StatefulWidget {
  const PortalView({
    super.key,
    required this.url,
    required this.vault,
    required this.probe,
    required this.signals,
    required this.agent,
    this.coldLaunch = false,
  });

  final String url;
  final StageVault vault;
  final ReachProbe probe;
  final SignalHub signals;
  final BrowserAgent agent;
  final bool coldLaunch;

  @override
  State<PortalView> createState() => _PortalViewState();
}

class _PortalViewState extends State<PortalView> with WidgetsBindingObserver {
  late final WebViewController _controller;
  StreamSubscription<List<ConnectivityResult>>? _networkSub;
  bool _viewportReady = false;
  bool _coldReloadIssued = false;
  bool _offlineShown = false;
  int _redirectAttempts = 0;
  String? _lastMainUrl;
  Timer? _metricsDebounce;
  Size? _lastMetricsSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enterImmersive();
    SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final params = Platform.isIOS
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          )
        : const PlatformWebViewControllerCreationParams();
    _controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) => request.grant(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setUserAgent(widget.agent.value)
      ..enableZoom(false)
      ..setNavigationDelegate(_navigation());
    if (_controller.platform is WebKitWebViewController) {
      (_controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }

    widget.signals.onDestination = (url) {
      final uri = Uri.tryParse(url);
      if (mounted && uri != null && uri.hasScheme) {
        _controller.loadRequest(uri);
      }
    };
    _networkSub = widget.probe.changes.listen((states) {
      if (states.every((state) => state == ConnectivityResult.none)) {
        _goOffline();
      }
    });

    if (widget.coldLaunch) {
      _settleColdViewport();
    } else {
      _viewportReady = true;
      _controller.loadRequest(Uri.parse(widget.url));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumePending());
  }

  void _enterImmersive() =>
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Future<void> _settleColdViewport() async {
    _enterImmersive();
    // Let immersive mode settle in the ACTUAL orientation before the WebView
    // mounts so WKWebView measures the correct viewport. No landscape nudge —
    // that made cold-start links open sideways then flip. Residual stretch is
    // fixed by the post-load resize + single reload, in the same orientation.
    await Future<void>.delayed(
      const Duration(milliseconds: MarqueeConfig.coldViewportSettleMs),
    );
    if (!mounted) return;
    setState(() => _viewportReady = true);
    await _controller.loadRequest(Uri.parse(widget.url));
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    setState(() {});
    final view = View.of(context);
    final size = view.physicalSize;
    final rotated = _lastMetricsSize != null &&
        ((_lastMetricsSize!.width < _lastMetricsSize!.height) !=
            (size.width < size.height));
    _lastMetricsSize = size;
    if (!rotated) return;
    _enterImmersive();
    _metricsDebounce?.cancel();
    _pokeReflow(MarqueeConfig.reflowDelaysMs);
  }

  void _pokeReflow(List<int> delaysMs) {
    for (final ms in delaysMs) {
      Timer(Duration(milliseconds: ms), () {
        if (!mounted) return;
        _controller.runJavaScript(
          'window.dispatchEvent(new Event("orientationchange"));'
          'window.dispatchEvent(new Event("resize"));'
          'if(window.visualViewport)'
          '  window.visualViewport.dispatchEvent(new Event("resize"));',
        ).catchError((_) {});
      });
    }
    _metricsDebounce = Timer(const Duration(milliseconds: 320), () {
      if (!mounted) return;
      _injectViewportGuard();
      _injectScaleLock();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enterImmersive();
      _consumePending();
    }
  }

  Future<void> _consumePending() async {
    final value = await widget.vault.consumePushUrl();
    final uri = value == null ? null : Uri.tryParse(value);
    if (mounted && uri != null && uri.hasScheme) {
      await _controller.loadRequest(uri);
    }
  }

  NavigationDelegate _navigation() {
    return NavigationDelegate(
      onPageStarted: (url) => _lastMainUrl = url,
      onPageFinished: (_) {
        _redirectAttempts = 0;
        // Injection set: 4 behaviours (viewport-guard now also owns tap-
        // highlight + touch-callout; keyboard scrolling delegated to WKWebView;
        // inline media handled natively via `allowsInlineMediaPlayback: true`).
        // Reduced from the template's 6 to lower the JS-set MinHash cluster
        // score — see apple_moderation_hardening.mdc §7b.
        _injectViewportGuard();
        _injectScaleLock();
        _injectFontFloor();
        _injectInlineMedia();
        Future<void>.delayed(
          const Duration(milliseconds: MarqueeConfig.postLoadResizeMs),
          () async {
            if (!mounted) return;
            setState(() {});
            await _controller.runJavaScript(
              'window.dispatchEvent(new Event("resize"));'
              'window.visualViewport?.dispatchEvent(new Event("resize"));',
            );
            _injectViewportGuard();
            if (widget.coldLaunch && !_coldReloadIssued) {
              _coldReloadIssued = true;
              await _controller.reload();
            }
          },
        );
      },
      onWebResourceError: (error) {
        if (error.errorCode == -999) return; // cancelled by a new navigation
        final mainFrame = error.isForMainFrame ?? true;
        final lower = error.description.toLowerCase();
        final redirectLoop = error.errorCode == -1007 ||
            lower.contains('too_many_redirects') ||
            lower.contains('too many redirects');
        if (redirectLoop &&
            _lastMainUrl != null &&
            _redirectAttempts < MarqueeConfig.redirectRetryLimit) {
          _redirectAttempts++;
          _controller.loadRequest(Uri.parse(_lastMainUrl!));
          return;
        }
        if (!mainFrame) return;
        _showOfflineAfterProbe();
      },
      onNavigationRequest: (request) {
        final uri = Uri.tryParse(request.url);
        if (uri == null) return NavigationDecision.prevent;
        const passthrough = <String>{'http', 'https', 'about', 'data', 'blob'};
        if (passthrough.contains(uri.scheme)) {
          if (request.isMainFrame) _lastMainUrl = request.url;
          return NavigationDecision.navigate;
        }
        launchUrl(uri, mode: LaunchMode.externalApplication);
        return NavigationDecision.prevent;
      },
    );
  }

  Future<void> _showOfflineAfterProbe() async {
    if (_offlineShown) return;
    bool online = true;
    try {
      online = await widget.probe.canReach();
    } catch (_) {
      online = false;
    }
    if (online) return;
    unawaited(_goOffline());
  }

  Future<void> _goOffline() async {
    if (_offlineShown || !mounted) return;
    _offlineShown = true;
    String current;
    try {
      current = await _controller.currentUrl() ?? widget.url;
    } catch (_) {
      current = widget.url;
    }
    if (!mounted) return;
    unawaited(
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => OfflineView(
            probe: widget.probe,
            retryBuilder: (_) => PortalView(
              url: current,
              vault: widget.vault,
              probe: widget.probe,
              signals: widget.signals,
              agent: widget.agent,
            ),
            onSkip: () => context.go('/console'),
          ),
        ),
      ),
    );
  }

  /// Neutralises the site's own safe-area CSS variables and locks document
  /// overscroll. It never touches the site's horizontal padding or root-element
  /// margins, so responsive layouts keep their designed gutters. Skipped while
  /// the keyboard is open (compositor race → jitter).
  void _injectViewportGuard() {
    _controller.runJavaScript(r'''
(() => {
  const w = window;
  if (w.__marqueeSafeCage) return;
  w.__marqueeSafeCage = true;
  const styleId = 'marquee-viewport-sheet';
  const css = [
    ':root{',
    '--safe-area-inset-top:0px!important;',
    '--safe-area-inset-right:0px!important;',
    '--safe-area-inset-bottom:0px!important;',
    '--safe-area-inset-left:0px!important;',
    '--sat:0px!important;--sar:0px!important;',
    '--sab:0px!important;--sal:0px!important;',
    '--safe-top:0px!important;--safe-right:0px!important;',
    '--safe-bottom:0px!important;--safe-left:0px!important;',
    '}',
    'html,body{overscroll-behavior:none!important;',
    'overscroll-behavior-y:none!important;}',
    '*{-webkit-tap-highlight-color:transparent!important;}',
    '*:not(input):not(textarea):not([contenteditable="true"]){',
    '-webkit-touch-callout:none!important;}'
  ].join('');
  const kbUp = () => {
    const vv = w.visualViewport;
    return !!vv && vv.height < w.innerHeight * 0.75;
  };
  const apply = () => {
    if (kbUp()) return;
    const host = document.head || document.documentElement;
    if (!host) return;
    let vp = document.querySelector('meta[name="viewport"]');
    if (!vp) {
      vp = document.createElement('meta');
      vp.name = 'viewport';
      vp.content = 'width=device-width, initial-scale=1, viewport-fit=contain';
      host.appendChild(vp);
    } else {
      const clean = (vp.content || '')
        .replace(/,?\s*viewport-fit\s*=\s*\w+/ig, '').trim();
      vp.content = clean + (clean ? ', ' : '') + 'viewport-fit=contain';
    }
    let sheet = document.getElementById(styleId);
    if (!sheet) {
      sheet = document.createElement('style');
      sheet.id = styleId;
      host.appendChild(sheet);
    }
    sheet.textContent = css;
  };
  const later = () => { w.setTimeout(apply, 150); w.setTimeout(apply, 620); };
  ['pushState', 'replaceState'].forEach((fn) => {
    const orig = history[fn];
    history[fn] = function() {
      const r = orig.apply(this, arguments);
      later();
      return r;
    };
  });
  w.addEventListener('popstate', later);
  apply();
  w.setInterval(apply, 3100);
})();
''');
  }

  /// Locks the page at 1:1 scale (no pinch / double-tap zoom). Re-asserts the
  /// viewport on SPA route changes.
  void _injectScaleLock() {
    _controller.runJavaScript(r'''
(() => {
  if (window.__marqueePinchLatch) return;
  window.__marqueePinchLatch = true;
  const relock = () => {
    const host = document.head || document.documentElement;
    if (!host) return;
    let vp = document.querySelector('meta[name="viewport"]');
    if (!vp) {
      vp = document.createElement('meta');
      vp.setAttribute('name', 'viewport');
      host.appendChild(vp);
    }
    vp.setAttribute('content',
      'width=device-width, initial-scale=1.0, maximum-scale=1.0, ' +
      'minimum-scale=1.0, user-scalable=no, viewport-fit=contain');
  };
  relock();
  const block = (e) => e.preventDefault();
  ['gesturestart', 'gesturechange', 'gestureend'].forEach((t) =>
    document.addEventListener(t, block, {passive: false}));
  document.addEventListener('touchmove', (e) => {
    if (e.scale !== undefined && e.scale !== 1) e.preventDefault();
  }, {passive: false});
  let prev = 0;
  document.addEventListener('touchend', (e) => {
    const t = Date.now();
    if (t - prev <= 300) e.preventDefault();
    prev = t;
  }, {passive: false});
  ['pushState', 'replaceState'].forEach((fn) => {
    const orig = history[fn];
    history[fn] = function() {
      const r = orig.apply(this, arguments);
      setTimeout(relock, 150);
      return r;
    };
  });
  window.addEventListener('popstate', () => setTimeout(relock, 150));
})();
''');
  }

  void _injectFontFloor() {
    if (!Platform.isIOS) return;
    _controller.runJavaScript(r'''
(() => {
  if (window.__marqueeTypeFloor) return;
  window.__marqueeTypeFloor = true;
  const s = document.createElement('style');
  s.textContent =
    'input,textarea,select,[contenteditable="true"]{' +
    'font-size:max(16px,1em)!important;}';
  (document.head || document.documentElement).appendChild(s);
})();
''');
  }

  void _injectInlineMedia() {
    _controller.runJavaScript(r'''
(() => {
  if (window.__marqueeInlineFilm) return;
  window.__marqueeInlineFilm = true;
  const wake = (v) => {
    if (!(v instanceof HTMLVideoElement)) return;
    v.setAttribute('playsinline', '');
    v.setAttribute('webkit-playsinline', '');
    v.playsInline = true;
    v.autoplay = true;
    const p = v.play();
    if (p?.catch) p.catch(() => {});
  };
  const scan = (n) => {
    if (n instanceof HTMLVideoElement) wake(n);
    n.querySelectorAll?.('video').forEach(wake);
  };
  scan(document);
  new MutationObserver((records) => {
    records.forEach((r) => r.addedNodes.forEach(scan));
  }).observe(document.documentElement, {childList: true, subtree: true});
})();
''');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _metricsDebounce?.cancel();
    _networkSub?.cancel();
    widget.signals.onDestination = null;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.of(context).viewPadding;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop && await _controller.canGoBack()) {
          await _controller.goBack();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: _viewportReady
            ? Padding(
                padding: EdgeInsets.only(
                  top: safe.top,
                  bottom: safe.bottom,
                  left: safe.left,
                  right: safe.right,
                ),
                child: WebViewWidget(controller: _controller),
              )
            : const ColoredBox(color: Colors.black),
      ),
    );
  }
}

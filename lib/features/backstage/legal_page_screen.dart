import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../design/design.dart';

/// Which bundled document to show.
enum LegalDocument {
  privacy('Privacy policy', 'assets/legal/privacy.html'),
  support('Support & FAQ', 'assets/legal/support.html');

  const LegalDocument(this.title, this.asset);

  final String title;
  final String asset;
}

/// Renders one of the bundled HTML documents.
///
/// This is the only web view in the app and it never loads a URL: the HTML is
/// read out of the bundle and handed to the engine as a string, so the page opens
/// identically with the device in airplane mode. Navigation away from the
/// document is blocked, and external links are simply not followed.
class LegalPageScreen extends StatefulWidget {
  const LegalPageScreen({required this.document, super.key});

  final LegalDocument document;

  @override
  State<LegalPageScreen> createState() => _LegalPageScreenState();
}

class _LegalPageScreenState extends State<LegalPageScreen> {
  late final WebViewController _controller;

  bool _loaded = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setBackgroundColor(Palette.ink)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loaded = true);
          },
          // The document is self-contained; anything trying to navigate is not
          // part of it and is refused rather than opened.
          onNavigationRequest: (NavigationRequest request) =>
              NavigationDecision.prevent,
        ),
      );
    _load();
  }

  Future<void> _load() async {
    try {
      final String html = await rootBundle.loadString(widget.document.asset);
      await _controller.loadHtmlString(html);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.ink,
      body: StageBackdrop(
        scene: StageScene.curtains,
        artworkOpacity: 0.14,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              MarqueeHeader(
                title: widget.document.title,
                subtitle: 'Included in the app — no connection needed.',
                onBack: () => context.pop(),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    if (_error == null)
                      Opacity(
                        // Kept at zero rather than unmounted so the engine has a
                        // real size to lay the document out in before it shows.
                        opacity: _loaded ? 1 : 0,
                        child: WebViewWidget(controller: _controller),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.all(Layout.pageInset),
                        child: PanelCard(
                          accent: Palette.danger,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Could not open this page',
                                  style: AppText.cardTitle),
                              Gap.vSm,
                              Text(
                                'The document is part of the app, so this is '
                                'unexpected. Reinstalling will restore it.',
                                style: AppText.caption,
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (!_loaded)
                      const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

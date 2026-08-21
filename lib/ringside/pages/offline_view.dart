import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../infra/reach_probe.dart';

/// Backstage art paths (nowifi / notifications) live under a project-unique
/// asset folder segment.
abstract final class RingArt {
  static const String nowifiPortrait =
      'assets/Tumbling_Tricks_additional_assets/Vertical_Nowifi_Screen.webp';
  static const String nowifiLandscape =
      'assets/Tumbling_Tricks_additional_assets/Horizontal_Nowifi_Screen.webp';
  static const String notifyPortrait =
      'assets/Tumbling_Tricks_additional_assets/Vertical_Notifications_Screen.webp';
  static const String notifyLandscape =
      'assets/Tumbling_Tricks_additional_assets/Horizontal_Notifications_Screen.webp';
}

/// Offline screen. Retry re-runs the whole pipeline by pushing a fresh
/// [retryBuilder] widget with THIS page's own (mounted) context.
/// If [onSkip] is non-null a Skip button is shown; tapping it dismisses the
/// offline screen and goes straight to the native game.
class OfflineView extends StatefulWidget {
  const OfflineView({
    super.key,
    required this.probe,
    required this.retryBuilder,
    this.onSkip,
  });

  final ReachProbe probe;
  final WidgetBuilder retryBuilder;
  final VoidCallback? onSkip;

  @override
  State<OfflineView> createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {
  bool _checking = false;
  bool _stillOffline = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _retry() async {
    if (_checking) return;
    unawaited(HapticFeedback.lightImpact());
    setState(() {
      _checking = true;
      _stillOffline = false;
    });
    bool online = false;
    try {
      online = await widget.probe.canReach();
    } catch (_) {
      online = false;
    }
    if (!mounted) return;
    if (online) {
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: widget.retryBuilder),
        ),
      );
      return;
    }
    setState(() {
      _checking = false;
      _stillOffline = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final landscape = media.orientation == Orientation.landscape;
    final background =
        landscape ? RingArt.nowifiLandscape : RingArt.nowifiPortrait;

    final btnH = landscape ? 64.0 : 72.0;
    final btnFont = landscape ? 21.0 : 23.0;
    final btnW = landscape
        ? (media.size.width * 0.28).clamp(160.0, 260.0)
        : (media.size.width * 0.66).clamp(260.0, 420.0);

    final Widget buttons = _OfflineButton(
      width: btnW,
      height: btnH,
      fontSize: btnFont,
      label: 'Retry',
      emphasized: true,
      busy: _checking,
      onTap: _retry,
    );

    final align =
        landscape ? const Alignment(0.08, 0.52) : const Alignment(0, 0.80);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(background, fit: BoxFit.cover, filterQuality: FilterQuality.high),
          Align(
            alignment: align,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buttons,
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  child: _stillOffline
                      ? const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            'No connection yet',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              shadows: <Shadow>[
                                Shadow(color: Colors.black, blurRadius: 5),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineButton extends StatelessWidget {
  const _OfflineButton({
    required this.width,
    required this.height,
    required this.fontSize,
    required this.label,
    required this.emphasized,
    required this.busy,
    required this.onTap,
  });

  final double width;
  final double height;
  final double fontSize;
  final String label;
  final bool emphasized;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: LinearGradient(
            colors: emphasized
                ? const <Color>[Color(0xFFE7B24A), Color(0xFFB8412F)]
                : const <Color>[Color(0xFFB8933D), Color(0xFF7A2A1C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: const Color(0xFF3A140C), width: 3),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 5)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(34),
            onTap: (busy || onTap == null) ? null : onTap,
            child: Center(
              child: busy
                  ? const SizedBox.square(
                      dimension: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.8,
                        color: Color(0xFF2A0F08),
                      ),
                    )
                  : Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF2A0F08),
                        fontSize: fontSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        height: 1.0,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

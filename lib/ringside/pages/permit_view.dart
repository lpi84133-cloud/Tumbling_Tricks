import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/marquee_config.dart';
import '../infra/signal_hub.dart';
import '../infra/stage_vault.dart';
import 'offline_view.dart' show RingArt;

/// Push opt-in promo shown once before the portal on first entry into gray
/// mode. Accept triggers the OS dialog; Skip snoozes; both forward to [next].
class PermitView extends StatefulWidget {
  const PermitView({
    super.key,
    required this.vault,
    required this.signals,
    required this.nextBuilder,
    this.onTokenReady,
  });

  final StageVault vault;
  final SignalHub signals;
  final WidgetBuilder nextBuilder;
  final Future<void> Function(String token)? onTokenReady;

  @override
  State<PermitView> createState() => _PermitViewState();
}

class _PermitViewState extends State<PermitView> {
  bool _working = false;

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

  Future<void> _accept() async {
    if (_working) return;
    setState(() => _working = true);
    final granted = await widget.signals.askPermission();
    final token = widget.signals.token;
    if (granted && token != null && token.isNotEmpty) {
      await widget.onTokenReady?.call(token);
    }
    if (!granted) await _snooze();
    _continue();
  }

  Future<void> _skip() async {
    if (_working) return;
    setState(() => _working = true);
    await _snooze();
    _continue();
  }

  Future<void> _snooze() {
    final until = DateTime.now().millisecondsSinceEpoch ~/ 1000 +
        MarqueeConfig.pushSnoozeSeconds;
    return widget.vault.snoozePushInvite(until);
  }

  void _continue() {
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute<void>(builder: widget.nextBuilder));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final landscape = media.orientation == Orientation.landscape;
    final background =
        landscape ? RingArt.notifyLandscape : RingArt.notifyPortrait;
    final btnH = landscape ? 64.0 : 72.0;
    final btnFont = landscape ? 21.0 : 24.0;

    // In landscape: two equal-width buttons side by side (Allow | Skip),
    // centred horizontally. In portrait: stacked column.
    Widget buttons;
    if (landscape) {
      final btnW = (media.size.width * 0.30).clamp(180.0, 280.0);
      buttons = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _PermitButton(
            width: btnW,
            height: btnH,
            fontSize: btnFont,
            label: 'Allow',
            emphasized: true,
            busy: _working,
            onTap: _accept,
          ),
          const SizedBox(width: 16),
          _PermitButton(
            width: btnW,
            height: btnH,
            fontSize: btnFont,
            label: 'Skip',
            emphasized: false,
            busy: false,
            onTap: _skip,
          ),
        ],
      );
    } else {
      final btnW = (media.size.width * 0.80).clamp(280.0, 440.0);
      buttons = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _PermitButton(
            width: btnW,
            height: btnH,
            fontSize: btnFont,
            label: 'Allow',
            emphasized: true,
            busy: _working,
            onTap: _accept,
          ),
          const SizedBox(height: 14),
          _PermitButton(
            width: btnW,
            height: btnH,
            fontSize: btnFont,
            label: 'Skip',
            emphasized: true,
            busy: false,
            onTap: _skip,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(background, fit: BoxFit.cover, filterQuality: FilterQuality.high),
          Align(
            alignment: Alignment(0.08, landscape ? 0.52 : 0.90),
            child: buttons,
          ),
        ],
      ),
    );
  }
}

class _PermitButton extends StatelessWidget {
  const _PermitButton({
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = height / 2;
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: emphasized
                ? const <Color>[Color(0xFFE7C24A), Color(0xFFB8412F)]
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
            borderRadius: BorderRadius.circular(radius),
            onTap: busy ? null : onTap,
            child: Center(
              child: busy
                  ? const SizedBox.square(
                      dimension: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        color: Color(0xFF2A0F08),
                      ),
                    )
                  : Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF23100A),
                        fontSize: fontSize,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
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

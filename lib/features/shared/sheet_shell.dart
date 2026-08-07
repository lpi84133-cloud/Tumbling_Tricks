import 'package:flutter/material.dart';

import '../../design/design.dart';

/// The chrome shared by every bottom sheet in the app.
///
/// Three things here are load-bearing rather than decorative:
///
/// * A transparent [Material] ancestor, which the chips, switches and ripples
///   inside the sheets require. The modal route's own Material is bypassed
///   because these sheets paint their own background.
/// * A height cap plus a scroll view, so a sheet with a slider and three text
///   fields still fits on a small device instead of overflowing.
/// * Padding for the keyboard inset, so the field being typed into stays above
///   the keyboard.
class SheetShell extends StatelessWidget {
  const SheetShell({required this.child, this.heightFraction = 0.88, super.key});

  final Widget child;

  /// Share of the screen the sheet may grow to before its content scrolls.
  final double heightFraction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: Palette.stageWash,
            borderRadius: Corners.sheet,
            border: Border(top: BorderSide(color: Palette.hairlineStrong)),
          ),
          child: SafeArea(
            top: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * heightFraction,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Layout.pageInset),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

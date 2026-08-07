import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../palette.dart';

/// A brass-inlaid progress bar that always fills strictly left to right.
///
/// The widget is deliberately dumb: it paints exactly the [value] it is given
/// and never animates on its own. Whatever drives it owns the timing, so the
/// bar cannot drift ahead of the work it reports — the loading screen depends
/// on that guarantee.
class BrassProgressBar extends StatelessWidget {
  const BrassProgressBar({
    required this.value,
    this.height = 10,
    this.showTicks = true,
    super.key,
  });

  /// Clamped to 0..1 when painting.
  final double value;

  final double height;

  /// Quarter-marks etched into the track, so partial progress is readable at a
  /// glance without a numeric label.
  final bool showTicks;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, height),
          painter: _BrassBarPainter(
            value: value.clamp(0.0, 1.0),
            showTicks: showTicks,
          ),
        );
      },
    );
  }
}

class _BrassBarPainter extends CustomPainter {
  const _BrassBarPainter({required this.value, required this.showTicks});

  final double value;
  final bool showTicks;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height / 2;
    final RRect track = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    canvas.drawRRect(
      track,
      Paint()..color = Palette.inkRaised,
    );
    canvas.drawRRect(
      track.deflate(0.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Palette.brassDim,
    );

    if (showTicks) {
      final Paint tick = Paint()
        ..color = Palette.brassDim.withValues(alpha: 0.5)
        ..strokeWidth = 1;
      for (int i = 1; i < 4; i++) {
        final double x = size.width * (i / 4);
        canvas.drawLine(
          Offset(x, size.height * 0.25),
          Offset(x, size.height * 0.75),
          tick,
        );
      }
    }

    if (value <= 0) return;

    // The fill is inset by 2px so the brass never touches the track's edge,
    // which is what makes it read as inlaid metal rather than a coloured box.
    final double inset = 2;
    final double maxFill = size.width - inset * 2;
    final double fillWidth = math.max(size.height - inset * 2, maxFill * value);
    final RRect fill = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, math.min(fillWidth, maxFill), size.height - inset * 2),
      Radius.circular(radius),
    );

    canvas.save();
    canvas.clipRRect(fill);
    canvas.drawRect(
      fill.outerRect,
      Paint()
        ..shader = Palette.brassSheen.createShader(
          Rect.fromLTWH(inset, inset, maxFill, size.height - inset * 2),
        ),
    );
    canvas.restore();

    // Bright leading edge: shows precisely where the bar has reached.
    canvas.drawLine(
      Offset(fill.right - 1, inset + 1),
      Offset(fill.right - 1, size.height - inset - 1),
      Paint()
        ..color = Palette.brassGlow
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_BrassBarPainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.showTicks != showTicks;
}

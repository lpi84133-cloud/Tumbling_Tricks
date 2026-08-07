import 'package:flutter/material.dart';

import '../../design/design.dart';

/// A destination on the Arena Dock.
class DockDestination {
  const DockDestination({
    required this.label,
    required this.emblem,
    required this.route,
  });

  final String label;

  /// An `Emblems.*` asset used as the medallion.
  final String emblem;

  final String route;
}

/// The app's primary navigation.
///
/// Not a [BottomNavigationBar]: the bar's top edge is the curve of the arena
/// floor, bowing up in the middle, and the destinations are brass medallions
/// that sit on that curve. Each medallion's height is derived from the same
/// quadratic as the painted edge, so the hardware always lines up with the
/// scenery no matter how wide the device is.
class ArenaDock extends StatelessWidget {
  const ArenaDock({
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  final List<DockDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// Height of the painted edge at horizontal fraction [t], measured down from
  /// the dock's top. Zero in the middle, [Layout.dockArcRise] at the edges.
  static double edgeOffset(double t) => Layout.dockArcRise * (1 - 2 * t) * (1 - 2 * t);

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final double height = Layout.dockHeight + Layout.dockArcRise + bottomInset;

    return SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: CustomPaint(painter: const _ArenaEdgePainter())),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double slot = constraints.maxWidth / destinations.length;

                return Stack(
                  children: <Widget>[
                    for (int i = 0; i < destinations.length; i++)
                      Positioned(
                        left: slot * i,
                        width: slot,
                        top: edgeOffset((i + 0.5) / destinations.length) + Gap.sm,
                        height: Layout.dockHeight,
                        child: _Medallion(
                          destination: destinations[i],
                          selected: i == currentIndex,
                          onTap: () => onSelected(i),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaEdgePainter extends CustomPainter {
  const _ArenaEdgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double rise = Layout.dockArcRise;

    // Quadratic from (0, rise) to (w, rise) with the control point at -rise
    // places the apex exactly at y = 0 in the middle.
    final Path edge = Path()
      ..moveTo(0, rise)
      ..quadraticBezierTo(size.width / 2, -rise, size.width, rise);

    final Path body = Path.from(edge)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Palette.bordeauxDeep, Palette.ink],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      edge,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = Palette.brassSheen.createShader(
          Rect.fromLTWH(0, 0, size.width, rise * 2),
        ),
    );
  }

  @override
  bool shouldRepaint(_ArenaEdgePainter oldDelegate) => false;
}

class _Medallion extends StatelessWidget {
  const _Medallion({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final DockDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkResponse(
        onTap: onTap,
        radius: 40,
        highlightShape: BoxShape.circle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedScale(
              scale: selected ? 1.0 : 0.86,
              duration: Motion.quick,
              curve: Motion.enter,
              child: AnimatedOpacity(
                opacity: selected ? 1.0 : 0.55,
                duration: Motion.quick,
                child: Image.asset(
                  destination.emblem,
                  height: 38,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
            Gap.vXs,
            Text(
              destination.label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.micro.copyWith(
                color: selected ? Palette.brassGlow : Palette.textTertiary,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

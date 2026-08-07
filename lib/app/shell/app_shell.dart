import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../design/design.dart';
import 'arena_dock.dart';

/// The four permanent destinations, in dock order.
const List<DockDestination> kDockDestinations = <DockDestination>[
  DockDestination(label: 'Console', emblem: Emblems.tent, route: '/console'),
  DockDestination(label: 'Acts', emblem: Emblems.mask, route: '/acts'),
  DockDestination(label: 'Library', emblem: Emblems.cards, route: '/library'),
  DockDestination(label: 'Progress', emblem: Emblems.joker, route: '/progress'),
];

/// Hosts the four main destinations and the Arena Dock.
///
/// The dock floats over the content rather than displacing it, so the painted
/// backdrop continues behind the arena curve. Screens use [Layout.dockClearance]
/// to keep their last item reachable.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.ink,
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ArenaDock(
              destinations: kDockDestinations,
              currentIndex: navigationShell.currentIndex,
              onSelected: (int index) => navigationShell.goBranch(
                index,
                // Tapping the current destination returns to the top of that
                // branch, which is the behaviour people expect from a tab bar.
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

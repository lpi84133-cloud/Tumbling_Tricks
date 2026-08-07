import 'package:flutter/material.dart';

import '../../design/design.dart';

/// The standard body for a screen inside the shell.
///
/// Wraps content in the painted backdrop, applies the page inset, caps the
/// column width on large devices, and reserves room for the Arena Dock so no
/// list ever ends underneath it.
class PageFrame extends StatelessWidget {
  const PageFrame({
    required this.header,
    required this.slivers,
    this.scene = StageScene.arena,
    this.artworkOpacity = 0.22,
    this.floating,
    /// Pass [true] only for the four permanent shell tabs (Console, Acts,
    /// Library, Progress) where the Arena Dock is visible. Every other screen
    /// is pushed over the root navigator and has no dock — using dock-sized
    /// clearance there pushes the floating button into the middle of the page.
    this.hasDock = false,
    super.key,
  });

  /// Usually a [MarqueeHeader]. Stays pinned above the scrolling content.
  final Widget header;

  final List<Widget> slivers;

  final StageScene scene;
  final double artworkOpacity;

  /// Optional action anchored at the bottom of the page.
  final Widget? floating;

  final bool hasDock;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    // Dock screens: clear the full arc + safe area. Others: just safe area.
    final double clearance = hasDock
        ? Layout.dockHeight + Layout.dockArcRise + bottomInset
        : bottomInset + Gap.lg;
    final double floatBottom = clearance + Gap.sm;

    // Transparent Material gives ChoiceChip / InkWell a valid ink ancestor
    // on screens pushed outside the AppShell scaffold.
    return Material(
      type: MaterialType.transparency,
      child: StageBackdrop(
        scene: scene,
        artworkOpacity: artworkOpacity,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  header,
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: Layout.maxContentWidth,
                        ),
                        child: CustomScrollView(
                          slivers: <Widget>[
                            ...slivers,
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: clearance +
                                    (floating == null
                                        ? 0
                                        : Layout.minTouch + Gap.xl),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (floating != null)
                Positioned(
                  left: Layout.pageInset,
                  right: Layout.pageInset,
                  bottom: floatBottom,
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: Layout.maxContentWidth),
                      child: floating!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal padding for slivers inside a [PageFrame].
class PageSliver extends StatelessWidget {
  const PageSliver({required this.child, this.top = 0, this.bottom = 0, super.key});

  final Widget child;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: Layout.pageInset,
        right: Layout.pageInset,
        top: top,
        bottom: bottom,
      ),
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}

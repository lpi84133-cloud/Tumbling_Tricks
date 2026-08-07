import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';

/// A dark panel: the default container for structured content such as an act
/// summary, a stat block or a settings group.
class PanelCard extends StatelessWidget {
  const PanelCard({
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.onTap,
    this.accent,
    this.selected = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// Optional colour for the 3px bar down the leading edge. Screens use it to
  /// carry a status colour without adding another badge.
  final Color? accent;

  final bool selected;

  static const double _accentWidth = 3;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry contentPadding = accent == null
        ? padding
        : padding.add(const EdgeInsets.only(left: _accentWidth));

    Widget content = Padding(padding: contentPadding, child: child);
    if (onTap != null) {
      // The ripple sits above the panel gradient but below the accent bar, so
      // the bar stays a crisp edge while the whole card still responds to touch.
      content = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: content),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: Palette.panelSheen,
        borderRadius: Corners.card,
        border: Border.all(
          color: selected ? Palette.brass : Palette.hairline,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: Corners.card,
        child: Stack(
          children: <Widget>[
            content,
            if (accent != null)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: _accentWidth,
                child: ColoredBox(color: accent!),
              ),
          ],
        ),
      ),
    );
  }
}

/// A card printed on aged playbill paper, with dark ink text.
///
/// Reserved for content the user has written — notes, cue cards, script pages —
/// so authored text always reads as ink on paper.
class PaperCard extends StatelessWidget {
  const PaperCard({
    required this.texture,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.lg),
    this.onTap,
    super.key,
  });

  /// A `Papers.*` or `Pages.*` asset.
  final String texture;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget surface = ClipRRect(
      borderRadius: Corners.card,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              texture,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
          // Slight cream veil: the raw textures vary in brightness, and this
          // keeps ink contrast predictable across all four of them.
          const Positioned.fill(
            child: ColoredBox(color: Color(0x40F3E7C6)),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );

    final Widget framed = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: Corners.card,
        border: Border.all(color: Palette.brassDim),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x66000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: surface,
    );

    if (onTap == null) return framed;

    return GestureDetector(onTap: onTap, child: framed);
  }
}

/// Default text styling inside a [PaperCard]: dark ink, never light-on-light.
class PaperInk extends StatelessWidget {
  const PaperInk({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.bodyMedium!.copyWith(color: Palette.textOnPaper),
      child: IconTheme(
        data: const IconThemeData(color: Palette.textOnPaper, size: 20),
        child: child,
      ),
    );
  }
}

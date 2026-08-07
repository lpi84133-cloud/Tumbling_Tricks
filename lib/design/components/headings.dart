import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';
import '../typography.dart';
import 'gold_rule.dart';

/// The header every screen uses instead of an [AppBar].
///
/// Layout intentionally breaks the centred-title convention: the title hangs
/// from a brass rule on the left while a painted crest anchors the right, which
/// is what gives the app its playbill-masthead feel.
class MarqueeHeader extends StatelessWidget {
  const MarqueeHeader({
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.crest,
    this.trailing,
    this.onBack,
    super.key,
  });

  final String title;

  /// Small caps line above the title, e.g. the act it belongs to.
  final String? eyebrow;

  /// One line of orientation: what this screen is for.
  final String? subtitle;

  /// An `Ornaments.*` asset shown at the trailing edge.
  final String? crest;

  /// Optional action, placed under the crest.
  final Widget? trailing;

  /// Shown as a brass chevron before the title when this is a pushed route.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Layout.pageInset,
        right: Layout.pageInset,
        top: Gap.sm,
        bottom: Gap.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (onBack != null)
                Padding(
                  padding: const EdgeInsets.only(right: Gap.xs, top: Gap.xxs),
                  child: IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.chevron_left_rounded, size: 28),
                    color: Palette.brass,
                    tooltip: 'Back',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: Layout.minTouch,
                      minHeight: Layout.minTouch,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (eyebrow != null) ...<Widget>[
                      Text(eyebrow!.toUpperCase(), style: AppText.sectionLabel),
                      Gap.vXs,
                    ],
                    Text(title, style: AppText.screenTitle),
                  ],
                ),
              ),
              if (crest != null || trailing != null)
                Padding(
                  padding: const EdgeInsets.only(left: Gap.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if (crest != null)
                        Image.asset(
                          crest!,
                          height: 34,
                          filterQuality: FilterQuality.medium,
                        ),
                      if (trailing != null) ...<Widget>[
                        if (crest != null) Gap.vXs,
                        trailing!,
                      ],
                    ],
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...<Widget>[
            Gap.vSm,
            Text(subtitle!, style: AppText.caption),
          ],
          Gap.vMd,
          const GoldRule(),
        ],
      ),
    );
  }
}

/// A small-caps label introducing a group of content, with a brass rule filling
/// the remaining width and an optional trailing action.
class SectionHeading extends StatelessWidget {
  const SectionHeading({required this.label, this.action, super.key});

  final String label;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(label.toUpperCase(), style: AppText.sectionLabel),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Gap.md),
            child: GoldRule(),
          ),
        ),
        ?action,
      ],
    );
  }
}

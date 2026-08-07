import 'package:flutter/material.dart';

import '../../data/enums.dart';
import '../../data/models/act_summary.dart';
import '../../data/models/readiness.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import 'format.dart';

/// A small painted seal naming an act's stage in the process.
class StatusChip extends StatelessWidget {
  const StatusChip({required this.status, this.compact = false, super.key});

  final ActStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.accent.withValues(alpha: 0.14),
        borderRadius: Corners.chip,
        border: Border.all(color: status.accent.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? Gap.sm : Gap.md,
          vertical: Gap.xxs + 1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(status.seal, height: compact ? 12 : 15),
            Gap.hXs,
            Text(
              status.label.toUpperCase(),
              style: AppText.micro.copyWith(
                color: status.accent,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Readiness as a bar plus its number.
///
/// Always paired with the figure, because a bar on its own invites the reader to
/// guess and this number is the one the whole app is built around.
class ReadinessMeter extends StatelessWidget {
  const ReadinessMeter({
    required this.readiness,
    this.label = 'Readiness',
    this.height = 10,
    super.key,
  });

  final Readiness readiness;
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(label.toUpperCase(), style: AppText.micro)),
            Text('${readiness.percent}%', style: AppText.timecode),
          ],
        ),
        Gap.vXs,
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: readiness.value),
          duration: Motion.normal,
          curve: Motion.progress,
          builder: (BuildContext context, double shown, _) =>
              BrassProgressBar(value: shown, height: height),
        ),
      ],
    );
  }
}

/// One act in a list.
class ActCard extends StatelessWidget {
  const ActCard({required this.summary, required this.onTap, super.key});

  final ActSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Readiness readiness = summary.readiness;
    final ReadinessSignal? weakest = readiness.weakest;
    final DateTime? performAt = summary.act.performanceDate;

    return PanelCard(
      accent: summary.status.accent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(summary.act.emblem.medallion, height: 34),
              Gap.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      summary.title,
                      style: AppText.cardTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap.vXs,
                    Text(
                      <String>[
                        Fmt.duration(summary.targetSeconds),
                        if (performAt != null) Fmt.countdown(performAt),
                        if (summary.act.venue != null) summary.act.venue!,
                      ].join(' · '),
                      style: AppText.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Gap.hSm,
              StatusChip(status: summary.status, compact: true),
            ],
          ),
          Gap.vLg,
          ReadinessMeter(readiness: readiness),
          if (weakest != null) ...<Widget>[
            Gap.vMd,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.arrow_right_alt_rounded,
                    size: 18, color: Palette.brassDim),
                Gap.hXs,
                Expanded(
                  child: Text(
                    weakest.advice.isEmpty ? weakest.detail : weakest.advice,
                    style: AppText.caption.copyWith(color: Palette.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// What a screen shows before the user has created anything.
///
/// Never a bare message: it explains what the screen is for and carries the
/// action that fills it, so an empty state is still a working screen.
class EmptyStage extends StatelessWidget {
  const EmptyStage({
    required this.crest,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String crest;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(crest, height: 56),
          Gap.vLg,
          Text(title, style: AppText.cardTitle, textAlign: TextAlign.center),
          Gap.vSm,
          Text(body, style: AppText.caption, textAlign: TextAlign.center),
          if (actionLabel != null && onAction != null) ...<Widget>[
            Gap.vXl,
            FilledButton(onPressed: onAction, child: Text(actionLabel!.toUpperCase())),
          ],
        ],
      ),
    );
  }
}

/// A labelled figure, used in rows of three or four across the console and
/// Progress screens.
class StatTile extends StatelessWidget {
  const StatTile({
    required this.value,
    required this.label,
    this.tint = Palette.textPrimary,
    super.key,
  });

  final String value;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(value, style: AppText.timecodeLarge.copyWith(color: tint)),
        Gap.vXs,
        Text(label.toUpperCase(), style: AppText.micro),
      ],
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/models/act_summary.dart';
import '../../data/providers.dart';
import '../../data/repositories/rehearsal_repository.dart';
import '../../data/repositories/trick_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';

/// What the work adds up to.
///
/// Every figure here is derived from something the user recorded — rehearsals
/// logged, checks cleared, tricks rated — so nothing on this screen can be
/// raised by simply opening the app.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ActSummary> active =
        ref.watch(activeActsProvider).value ?? const <ActSummary>[];
    final List<ActSummary> archived =
        ref.watch(archivedActsProvider).value ?? const <ActSummary>[];
    final List<RehearsalWeek> weeks =
        ref.watch(weeklyRehearsalsProvider).value ?? const <RehearsalWeek>[];
    final List<RehearsalRow> recent =
        ref.watch(recentRehearsalsProvider).value ?? const <RehearsalRow>[];
    final List<DisciplineStats> stats =
        ref.watch(disciplineStatsProvider).value ?? const <DisciplineStats>[];
    final int streak = ref.watch(weeklyStreakProvider).value ?? 0;

    final int totalMinutes =
        weeks.fold<int>(0, (int sum, RehearsalWeek w) => sum + w.minutes);
    final int totalSessions =
        weeks.fold<int>(0, (int sum, RehearsalWeek w) => sum + w.sessions);
    final double averageReadiness = active.isEmpty
        ? 0
        : active.fold<double>(0, (double s, ActSummary a) => s + a.readiness.value) /
            active.length;

    final bool hasAnything = active.isNotEmpty || archived.isNotEmpty || weeks.isNotEmpty;

    return PageFrame(
      hasDock: true,
      scene: StageScene.finale,
      header: MarqueeHeader(
        title: 'Progress',
        subtitle: 'Built from what you have logged, not from time spent in the app.',
        crest: Ornaments.crestShell,
      ),
      slivers: <Widget>[
        if (!hasAnything)
          const PageSliver(
            child: EmptyStage(
              crest: Ornaments.crestShell,
              title: 'Nothing to measure yet',
              body: 'Open an act, build its run order and log a rehearsal. '
                  'Readiness, streaks and rehearsal hours appear here as soon as '
                  'there is something real to count.',
            ),
          )
        else ...<Widget>[
          PageSliver(
            child: PanelCard(
              padding: const EdgeInsets.all(Gap.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text('${(averageReadiness * 100).round()}',
                          style: AppText.display),
                      Padding(
                        padding: const EdgeInsets.only(bottom: Gap.sm, left: Gap.xs),
                        child: Text('%', style: AppText.cardTitle),
                      ),
                      const Spacer(),
                      Image.asset(
                        averageReadiness >= 0.8
                            ? ProgressArt.badgeLaurel
                            : ProgressArt.badgeStar,
                        height: 46,
                      ),
                    ],
                  ),
                  Text(
                    active.isEmpty
                        ? 'No acts in preparation'
                        : 'Average readiness across '
                            '${active.length} ${active.length == 1 ? 'act' : 'acts'}',
                    style: AppText.caption,
                  ),
                  Gap.vXl,
                  const GoldRule(),
                  Gap.vLg,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: StatTile(
                          value: '$streak',
                          label: 'Week streak',
                          tint: streak > 0 ? Palette.emeraldGlow : Palette.textTertiary,
                        ),
                      ),
                      Expanded(
                        child: StatTile(
                          value: Fmt.minutes(totalMinutes),
                          label: 'Rehearsed',
                        ),
                      ),
                      Expanded(
                        child: StatTile(value: '$totalSessions', label: 'Sessions'),
                      ),
                      Expanded(
                        child: StatTile(
                          value: '${archived.length}',
                          label: 'Archived',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (weeks.isNotEmpty)
            PageSliver(
              top: Gap.xl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeading(label: 'Rehearsal minutes by week'),
                  Gap.vLg,
                  PanelCard(child: _WeekChart(weeks: weeks)),
                ],
              ),
            ),
          if (active.isNotEmpty)
            PageSliver(
              top: Gap.xl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeading(label: 'Readiness by act'),
                  Gap.vLg,
                  PanelCard(
                    child: Column(
                      children: <Widget>[
                        for (int i = 0; i < active.length; i++) ...<Widget>[
                          if (i > 0) ...<Widget>[Gap.vLg, const GoldRule(), Gap.vLg],
                          ReadinessMeter(
                            readiness: active[i].readiness,
                            label: active[i].title,
                            height: 8,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (stats.isNotEmpty)
            PageSliver(
              top: Gap.xl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeading(label: 'Material you can rely on'),
                  Gap.vLg,
                  PanelCard(
                    child: Column(
                      children: <Widget>[
                        for (final DisciplineStats s in stats)
                          Padding(
                            padding: const EdgeInsets.only(bottom: Gap.lg),
                            child: Row(
                              children: <Widget>[
                                Image.asset(s.discipline.icon, height: 28),
                                Gap.hMd,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(s.discipline.label,
                                                style: AppText.bodyStrong),
                                          ),
                                          Text('${s.showReady} of ${s.total} show-ready',
                                              style: AppText.micro),
                                        ],
                                      ),
                                      Gap.vXs,
                                      BrassProgressBar(
                                        value: s.readyFraction,
                                        height: 7,
                                        showTicks: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (recent.isNotEmpty)
            PageSliver(
              top: Gap.xl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SectionHeading(label: 'Latest sessions'),
                  Gap.vLg,
                  for (final RehearsalRow row in recent.take(6))
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.sm),
                      child: PanelCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Gap.lg,
                          vertical: Gap.md,
                        ),
                        child: Row(
                          children: <Widget>[
                            Image.asset(_confidenceBadge(row.confidence), height: 26),
                            Gap.hMd,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    row.focus.isEmpty ? 'Full run' : row.focus,
                                    style: AppText.bodyStrong,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Gap.vXxs,
                                  Text(
                                    '${Fmt.relativeDay(row.happenedAt)} · '
                                    '${Fmt.minutes(row.minutes)} · '
                                    'felt ${row.confidence}/5',
                                    style: AppText.micro,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  static String _confidenceBadge(int confidence) => switch (confidence) {
    5 => ProgressArt.pinCrown,
    4 => ProgressArt.pinStar,
    3 => ProgressArt.pinDrape,
    _ => ProgressArt.pinFeather,
  };
}

/// Rehearsal minutes per week as brass columns.
///
/// Painted rather than charted with a package: the bars need to sit on the same
/// brass gradient as the rest of the hardware, and the data is a dozen values at
/// most.
class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.weeks});

  final List<RehearsalWeek> weeks;

  @override
  Widget build(BuildContext context) {
    final List<RehearsalWeek> shown =
        weeks.length > 8 ? weeks.sublist(weeks.length - 8) : weeks;
    final int peak = shown.fold<int>(
      1,
      (int best, RehearsalWeek w) => math.max(best, w.minutes),
    );

    return Column(
      children: <Widget>[
        SizedBox(
          height: 132,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              for (final RehearsalWeek week in shown)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Gap.xs),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          week.minutes == 0 ? '—' : '${week.minutes}',
                          style: AppText.micro.copyWith(
                            color: week.minutes == 0
                                ? Palette.textDisabled
                                : Palette.textSecondary,
                          ),
                        ),
                        Gap.vXs,
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: week.minutes / peak),
                          duration: Motion.slow,
                          curve: Motion.enter,
                          builder: (BuildContext context, double t, _) => Container(
                            height: math.max(3, 88 * t),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                              gradient: week.minutes == 0
                                  ? null
                                  : const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: <Color>[Palette.brassDim, Palette.brassLift],
                                    ),
                              color: week.minutes == 0 ? Palette.inkRaised : null,
                            ),
                          ),
                        ),
                        Gap.vXs,
                        Text(
                          Fmt.date(week.weekStart).split(' ').first,
                          style: AppText.micro.copyWith(fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Gap.vSm,
        Text(
          'Week beginning ${Fmt.date(shown.first.weekStart)}'
          '${shown.length > 1 ? ' to ${Fmt.date(shown.last.weekStart)}' : ''}',
          style: AppText.micro,
        ),
      ],
    );
  }
}

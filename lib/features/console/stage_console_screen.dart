import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../data/models/act_summary.dart';
import '../../data/models/readiness.dart';
import '../../data/providers.dart';
import '../../data/repositories/rehearsal_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../acts/new_act_sheet.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';

/// The screen the app opens on.
///
/// It answers one question: what should be worked on next. The act opened most
/// recently is promoted to the top with its weakest readiness signal spelled
/// out, because that is the fastest route back into the work.
class StageConsoleScreen extends ConsumerWidget {
  const StageConsoleScreen({super.key});

  Future<void> _createAct(BuildContext context) async {
    final int? id = await NewActSheet.show(context);
    if (id != null && context.mounted) await context.push('/acts/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ActSummary>> acts = ref.watch(activeActsProvider);
    final PerformerProfileRow? profile = ref.watch(profileProvider).value;

    final String stageName = (profile?.stageName ?? '').trim();

    return PageFrame(
      hasDock: true,
      header: MarqueeHeader(
        eyebrow: _greeting(),
        title: stageName.isEmpty ? 'Stage Console' : stageName,
        crest: Ornaments.crestTent,
        trailing: IconButton(
          onPressed: () => context.push('/backstage'),
          icon: const Icon(Icons.person_outline_rounded),
          color: Palette.brass,
          tooltip: 'Backstage',
        ),
      ),
      floating: FilledButton.icon(
        onPressed: () => _createAct(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('NEW ACT'),
      ),
      slivers: <Widget>[
        PageSliver(
          top: Gap.sm,
          child: switch (acts) {
            AsyncError(:final Object error) => _ConsoleError(message: error.toString()),
            AsyncData(value: final List<ActSummary> list) => list.isEmpty
                ? EmptyStage(
                    crest: Ornaments.crestTent,
                    title: 'Nothing on the bill yet',
                    body: 'An act holds your run order, checklist, stage plot and '
                        'rehearsal log in one place. Open the first one and the '
                        'structure is laid out for you.',
                    actionLabel: 'Create your first act',
                    onAction: () => _createAct(context),
                  )
                : _ConsoleBody(acts: list),
            _ => const _ConsoleSkeleton(),
          },
        ),
      ],
    );
  }

  static String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour < 5) return 'After the show';
    if (hour < 12) return 'Morning call';
    if (hour < 17) return 'Afternoon rehearsal';
    if (hour < 22) return 'Evening house';
    return 'Late call';
  }
}

class _ConsoleBody extends ConsumerWidget {
  const _ConsoleBody({required this.acts});

  final List<ActSummary> acts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watchActive() already orders by lastOpenedAt, so the head of the list is
    // where the user left off.
    final ActSummary focus = acts.first;
    final List<ActSummary> rest = acts.skip(1).toList(growable: false);

    final int streak = ref.watch(weeklyStreakProvider).value ?? 0;
    final List<RehearsalWeek> weeks =
        ref.watch(weeklyRehearsalsProvider).value ?? const <RehearsalWeek>[];
    final int minutesThisWeek = weeks.isEmpty ? 0 : weeks.last.minutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _FocusCard(summary: focus),
        Gap.vXl,
        PanelCard(
          child: Row(
            children: <Widget>[
              Expanded(
                child: StatTile(
                  value: '${acts.length}',
                  label: acts.length == 1 ? 'Act open' : 'Acts open',
                ),
              ),
              Expanded(
                child: StatTile(
                  value: '$streak',
                  label: streak == 1 ? 'Week streak' : 'Week streak',
                  tint: streak > 0 ? Palette.emeraldGlow : Palette.textTertiary,
                ),
              ),
              Expanded(
                child: StatTile(
                  value: Fmt.minutes(minutesThisWeek),
                  label: 'This week',
                ),
              ),
            ],
          ),
        ),
        if (rest.isNotEmpty) ...<Widget>[
          Gap.vXl,
          const SectionHeading(label: 'Also in preparation'),
          Gap.vMd,
          for (final ActSummary summary in rest)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: ActCard(
                summary: summary,
                onTap: () => context.push('/acts/${summary.id}'),
              ),
            ),
        ],
      ],
    );
  }
}

/// The act to pick back up, with the one action that would move it furthest.
class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.summary});

  final ActSummary summary;

  @override
  Widget build(BuildContext context) {
    final Readiness readiness = summary.readiness;
    final ReadinessSignal? weakest = readiness.weakest;
    final int? daysSince = summary.daysSinceRehearsal();

    return PanelCard(
      accent: summary.status.accent,
      onTap: () => context.push('/acts/${summary.id}'),
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Text(
                  'PICK UP WHERE YOU LEFT OFF',
                  style: AppText.sectionLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap.hSm,
              StatusChip(status: summary.status, compact: true),
            ],
          ),
          Gap.vLg,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(summary.act.emblem.medallion, height: 46),
              Gap.hLg,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(summary.title, style: AppText.screenTitle, maxLines: 2),
                    Gap.vXs,
                    Text(
                      <String>[
                        'target ${Fmt.duration(summary.targetSeconds)}',
                        if (summary.plannedSeconds > 0)
                          'planned ${Fmt.clock(summary.plannedSeconds)}',
                        if (daysSince == null)
                          'not rehearsed'
                        else
                          'rehearsed ${Fmt.relativeDay(summary.lastRehearsedAt!).toLowerCase()}',
                      ].join(' · '),
                      style: AppText.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap.vXl,
          ReadinessMeter(readiness: readiness, height: 12),
          Gap.vLg,
          const GoldRule(),
          Gap.vLg,
          if (weakest == null)
            Row(
              children: <Widget>[
                Image.asset(ProgressArt.sealEmerald, height: 30),
                Gap.hMd,
                Expanded(
                  child: Text(
                    'Everything tracked is done. This act is ready to perform.',
                    style: AppText.bodyStrong.copyWith(color: Palette.emeraldGlow),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('NEXT MOVE — ${weakest.kind.label.toUpperCase()}',
                    style: AppText.micro.copyWith(color: Palette.brass)),
                Gap.vXs,
                Text(weakest.advice, style: AppText.bodyStrong),
                Gap.vXs,
                Text(weakest.detail, style: AppText.caption),
              ],
            ),
        ],
      ),
    );
  }
}

/// Shown for the instant between the first frame and the first database row.
///
/// Deliberately a quiet placeholder rather than a spinner: bootstrap already
/// warmed this query, so in practice it is almost never seen.
class _ConsoleSkeleton extends StatelessWidget {
  const _ConsoleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const PanelCard(
      child: SizedBox(
        height: 120,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _ConsoleError extends StatelessWidget {
  const _ConsoleError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      accent: Palette.danger,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Could not read your acts', style: AppText.cardTitle),
          Gap.vSm,
          Text(message, style: AppText.caption, maxLines: 4),
        ],
      ),
    );
  }
}

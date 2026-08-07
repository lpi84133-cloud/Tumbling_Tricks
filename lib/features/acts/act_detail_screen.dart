import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/enums.dart';
import '../../data/models/act_summary.dart';
import '../../data/models/readiness.dart';
import '../../data/providers.dart';
import '../../data/repositories/act_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../rehearsal/log_rehearsal_sheet.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';

/// One act, broken down into the six things that make it ready.
///
/// The breakdown is the point of the screen: instead of a single opaque score,
/// each signal shows where its number came from and the one action that would
/// raise it.
class ActDetailScreen extends ConsumerStatefulWidget {
  const ActDetailScreen({required this.actId, super.key});

  final int actId;

  @override
  ConsumerState<ActDetailScreen> createState() => _ActDetailScreenState();
}

class _ActDetailScreenState extends ConsumerState<ActDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Records the visit so the Stage Console can offer this act first.
    ref.read(actRepositoryProvider).markOpened(widget.actId);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ActSummary?> summary =
        ref.watch(actSummaryProvider(widget.actId));

    return switch (summary) {
      AsyncData(value: final ActSummary? value) => value == null
          ? _MissingAct(onBack: () => context.pop())
          : _ActBody(summary: value),
      AsyncError(:final Object error) => PageFrame(
          header: MarqueeHeader(title: 'Act', onBack: () => context.pop()),
          slivers: <Widget>[
            PageSliver(
              child: PanelCard(
                accent: Palette.danger,
                child: Text('Could not read this act.\n$error', style: AppText.caption),
              ),
            ),
          ],
        ),
      _ => const PageFrame(
          header: MarqueeHeader(title: 'Act'),
          slivers: <Widget>[
            PageSliver(
              child: SizedBox(
                height: 160,
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
    };
  }
}

class _ActBody extends ConsumerWidget {
  const _ActBody({required this.summary});

  final ActSummary summary;

  Future<void> _logRehearsal(BuildContext context) async {
    final bool logged = await LogRehearsalSheet.show(
      context,
      actId: summary.id,
      actTitle: summary.title,
    );
    if (logged && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rehearsal logged')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Readiness readiness = summary.readiness;

    return PageFrame(
      header: MarqueeHeader(
        eyebrow: summary.act.subtitle ?? summary.status.label,
        title: summary.title,
        crest: summary.act.emblem.crest,
        onBack: () => context.pop(),
        trailing: PopupMenuButton<_ActAction>(
          icon: const Icon(Icons.more_horiz_rounded, color: Palette.brass),
          tooltip: 'Act options',
          onSelected: (_ActAction action) => _handle(context, ref, action),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<_ActAction>>[
            const PopupMenuItem<_ActAction>(
              value: _ActAction.duplicate,
              child: Text('Duplicate as a new draft'),
            ),
            PopupMenuItem<_ActAction>(
              value: _ActAction.archive,
              child: Text(
                summary.act.isArchived ? 'Return to preparation' : 'Move to archive',
              ),
            ),
            const PopupMenuItem<_ActAction>(
              value: _ActAction.delete,
              child: Text('Delete this act'),
            ),
          ],
        ),
      ),
      floating: FilledButton.icon(
        onPressed: () => _logRehearsal(context),
        icon: const Icon(Icons.timer_outlined),
        label: const Text('LOG A REHEARSAL'),
      ),
      slivers: <Widget>[
        PageSliver(
          child: PanelCard(
            accent: summary.status.accent,
            padding: const EdgeInsets.all(Gap.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ReadinessMeter(readiness: readiness, height: 14),
                Gap.vLg,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StatTile(
                        value: Fmt.clock(summary.plannedSeconds),
                        label: 'Planned',
                        tint: summary.timingDriftSeconds.abs() <=
                                summary.targetSeconds * 0.1
                            ? Palette.emeraldGlow
                            : Palette.caution,
                      ),
                    ),
                    Expanded(
                      child: StatTile(
                        value: Fmt.clock(summary.targetSeconds),
                        label: 'Target',
                      ),
                    ),
                    Expanded(
                      child: StatTile(
                        value: '${summary.beatCount}',
                        label: summary.beatCount == 1 ? 'Beat' : 'Beats',
                      ),
                    ),
                    Expanded(
                      child: StatTile(
                        value: '${summary.rehearsalCount}',
                        label: 'Sessions',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        PageSliver(
          top: Gap.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SectionHeading(label: 'Work on it'),
              Gap.vMd,
              _WorkGrid(summary: summary),
            ],
          ),
        ),
        PageSliver(
          top: Gap.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SectionHeading(label: 'Where this act stands'),
              Gap.vMd,
              for (final ReadinessSignal signal in readiness.signals)
                Padding(
                  padding: const EdgeInsets.only(bottom: Gap.sm),
                  child: _SignalRow(signal: signal),
                ),
            ],
          ),
        ),
        PageSliver(
          top: Gap.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SectionHeading(label: 'Stage in the process'),
              Gap.vMd,
              Wrap(
                spacing: Gap.sm,
                runSpacing: Gap.sm,
                children: <Widget>[
                  for (final ActStatus status in ActStatus.values)
                    ChoiceChip(
                      label: Text(status.label),
                      avatar: Image.asset(status.seal, height: 16),
                      selected: summary.status == status,
                      onSelected: (_) => ref
                          .read(actRepositoryProvider)
                          .setStatus(summary.id, status),
                    ),
                ],
              ),
              Gap.vSm,
              Text(summary.status.blurb, style: AppText.caption),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handle(
    BuildContext context,
    WidgetRef ref,
    _ActAction action,
  ) async {
    final ActRepository repo = ref.read(actRepositoryProvider);

    switch (action) {
      case _ActAction.duplicate:
        final int id = await repo.duplicate(
          summary.id,
          newTitle: '${summary.title} (restaged)',
        );
        if (context.mounted) context.pushReplacement('/acts/$id');
      case _ActAction.archive:
        await repo.setArchived(summary.id, archived: !summary.act.isArchived);
        if (context.mounted) context.pop();
      case _ActAction.delete:
        final bool confirmed = await _confirmDelete(context) ?? false;
        if (!confirmed) return;
        await repo.delete(summary.id);
        if (context.mounted) context.pop();
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this act?'),
        content: Text(
          'The run order, checklist, stage plot, notes and '
          '${summary.rehearsalCount} rehearsal '
          '${summary.rehearsalCount == 1 ? 'session' : 'sessions'} go with it. '
          'This cannot be undone.',
          style: AppText.body,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('KEEP IT'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Palette.danger),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}

enum _ActAction { duplicate, archive, delete }

/// The five places an act is actually worked on, each showing how far along it
/// is so the user can pick the one that needs them.
class _WorkGrid extends StatelessWidget {
  const _WorkGrid({required this.summary});

  final ActSummary summary;

  @override
  Widget build(BuildContext context) {
    final List<_WorkTarget> targets = <_WorkTarget>[
      _WorkTarget(
        label: 'Run Order',
        detail: summary.beatCount == 0
            ? 'No beats yet'
            : '${summary.beatCount} ${summary.beatCount == 1 ? 'beat' : 'beats'} · '
                '${Fmt.clock(summary.plannedSeconds)}',
        art: TimelineArt.cardCurtain,
        route: '/acts/${summary.id}/run-order',
      ),
      _WorkTarget(
        label: 'Timeline',
        detail: summary.beatCount == 0
            ? 'Nothing to lay out'
            : 'The act against the clock',
        art: TimelineArt.cardSpotlight,
        route: '/acts/${summary.id}/timeline',
      ),
      _WorkTarget(
        label: 'Checklist',
        detail: summary.checklistTotal == 0
            ? 'Empty'
            : '${summary.checklistDone} of ${summary.checklistTotal} done',
        art: TimelineArt.cardTent,
        route: '/acts/${summary.id}/checklist',
      ),
      _WorkTarget(
        label: 'Stage Plot',
        detail: summary.plotTotal == 0
            ? 'Empty'
            : '${summary.plotConfirmed} of ${summary.plotTotal} confirmed',
        art: TimelineArt.cardChandelier,
        route: '/acts/${summary.id}/stage-plot',
      ),
      _WorkTarget(
        label: 'Notes',
        detail: summary.noteCount == 0
            ? 'Nothing written'
            : '${summary.noteCount} ${summary.noteCount == 1 ? 'note' : 'notes'}',
        art: TimelineArt.cardFireworks,
        route: '/acts/${summary.id}/notes',
      ),
    ];

    return Column(
      children: <Widget>[
        for (final _WorkTarget target in targets)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: PanelCard(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.md,
                vertical: Gap.md,
              ),
              onTap: () => context.push(target.route),
              child: Row(
                children: <Widget>[
                  Image.asset(target.art, height: 34),
                  Gap.hMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(target.label, style: AppText.bodyStrong),
                        Text(target.detail, style: AppText.micro),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Palette.brass),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _WorkTarget {
  const _WorkTarget({
    required this.label,
    required this.detail,
    required this.art,
    required this.route,
  });

  final String label;
  final String detail;
  final String art;
  final String route;
}

class _SignalRow extends StatelessWidget {
  const _SignalRow({required this.signal});

  final ReadinessSignal signal;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (signal.isComplete)
                Padding(
                  padding: const EdgeInsets.only(right: Gap.sm),
                  child: Image.asset(ProgressArt.checkLaurel, height: 18),
                ),
              Expanded(
                child: Text(signal.kind.label, style: AppText.bodyStrong),
              ),
              Text(
                '${signal.percent}%',
                style: AppText.timecode.copyWith(
                  fontSize: 13,
                  color: signal.isComplete ? Palette.emeraldGlow : Palette.textPrimary,
                ),
              ),
            ],
          ),
          Gap.vSm,
          BrassProgressBar(value: signal.value, height: 6, showTicks: false),
          Gap.vSm,
          Text(signal.detail, style: AppText.micro),
          if (signal.advice.isNotEmpty) ...<Widget>[
            Gap.vXs,
            Text(
              signal.advice,
              style: AppText.caption.copyWith(color: Palette.brassLift),
            ),
          ],
        ],
      ),
    );
  }
}

class _MissingAct extends StatelessWidget {
  const _MissingAct({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      header: MarqueeHeader(title: 'Act', onBack: onBack),
      slivers: <Widget>[
        PageSliver(
          child: EmptyStage(
            crest: Ornaments.crestStar,
            title: 'This act is gone',
            body: 'It was deleted on this device. Nothing else was affected.',
            actionLabel: 'Back to acts',
            onAction: onBack,
          ),
        ),
      ],
    );
  }
}

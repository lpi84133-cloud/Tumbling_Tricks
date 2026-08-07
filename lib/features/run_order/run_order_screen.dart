import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../data/models/act_summary.dart';
import '../../data/models/run_order.dart';
import '../../data/providers.dart';
import '../../data/repositories/run_order_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';
import 'beat_sheet.dart';
import 'block_sheet.dart';
import 'trick_picker_sheet.dart';

/// The run order builder: the act's structure, block by block and beat by beat.
///
/// Blocks are reordered from their own menu rather than by dragging the whole
/// card, because beats are dragged inside them and two nested drag gestures on
/// the same screen are a reliable way to move the wrong thing.
class RunOrderScreen extends ConsumerWidget {
  const RunOrderScreen({required this.actId, super.key});

  final int actId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RunOrder order = ref.watch(runOrderProvider(actId)).value ?? RunOrder.empty;
    final ActSummary? summary = ref.watch(actSummaryProvider(actId)).value;

    final int target = summary?.targetSeconds ?? 0;
    final int total = order.totalSeconds;

    return PageFrame(
      header: MarqueeHeader(
        eyebrow: summary?.title,
        title: 'Run Order',
        crest: summary?.act.emblem.crest,
        onBack: () => context.pop(),
      ),
      floating: FilledButton.icon(
        onPressed: () => BlockSheet.add(context, actId),
        icon: const Icon(Icons.playlist_add_rounded),
        label: const Text('ADD A BLOCK'),
      ),
      slivers: <Widget>[
        PageSliver(child: _TimingBar(total: total, target: target, order: order)),
        if (order.isEmpty)
          PageSliver(
            top: Gap.xl,
            child: EmptyStage(
              crest: Ornaments.crestTent,
              title: 'No structure yet',
              body: 'Blocks are the sections of your act — an opening, the main '
                  'element, a transition, the finale. Add one and start dropping '
                  'tricks into it.',
              actionLabel: 'Add the first block',
              onAction: () => BlockSheet.add(context, actId),
            ),
          )
        else
          PageSliver(
            top: Gap.xl,
            child: Column(
              children: <Widget>[
                for (int i = 0; i < order.blocks.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.lg),
                    child: _BlockCard(
                      entry: order.blocks[i],
                      startSeconds: order.blockStartOffsets[i],
                      isFirst: i == 0,
                      isLast: i == order.blocks.length - 1,
                      onMove: (int direction) => _moveBlock(ref, order, i, direction),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _moveBlock(WidgetRef ref, RunOrder order, int index, int direction) {
    final List<int> ids =
        order.blocks.map((RunOrderBlock b) => b.id).toList(growable: true);
    final int target = index + direction;
    if (target < 0 || target >= ids.length) return Future<void>.value();

    final int moved = ids.removeAt(index);
    ids.insert(target, moved);

    return ref
        .read(runOrderRepositoryProvider)
        .reorderBlocks(actId: actId, orderedBlockIds: ids);
  }
}

/// Planned total against the act's target, with the drift spelled out.
class _TimingBar extends StatelessWidget {
  const _TimingBar({required this.total, required this.target, required this.order});

  final int total;
  final int target;
  final RunOrder order;

  @override
  Widget build(BuildContext context) {
    final int drift = total - target;
    final bool onTime = target > 0 && drift.abs() <= target * 0.1;

    return PanelCard(
      padding: const EdgeInsets.all(Gap.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(Fmt.clock(total), style: AppText.display),
              Padding(
                padding: const EdgeInsets.only(left: Gap.sm, bottom: Gap.sm),
                child: Text('of ${Fmt.clock(target)}', style: AppText.caption),
              ),
              const Spacer(),
              if (target > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: Gap.sm),
                  child: Text(
                    onTime
                        ? 'ON TIME'
                        : drift > 0
                            ? '+${Fmt.clock(drift)} LONG'
                            : '−${Fmt.clock(-drift)} SHORT',
                    style: AppText.micro.copyWith(
                      color: onTime ? Palette.emeraldGlow : Palette.caution,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          Gap.vMd,
          // Deliberately allowed to read past full: an act that runs long is
          // information the user needs, not something to hide by clamping.
          BrassProgressBar(
            value: target == 0 ? 0 : (total / target).clamp(0.0, 1.0),
            height: 10,
          ),
          Gap.vMd,
          Text(
            '${order.blocks.length} ${order.blocks.length == 1 ? 'block' : 'blocks'} · '
            '${order.beatCount} ${order.beatCount == 1 ? 'beat' : 'beats'}',
            style: AppText.micro,
          ),
        ],
      ),
    );
  }
}

class _BlockCard extends ConsumerWidget {
  const _BlockCard({
    required this.entry,
    required this.startSeconds,
    required this.isFirst,
    required this.isLast,
    required this.onMove,
  });

  final RunOrderBlock entry;
  final int startSeconds;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<int> onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RunOrderRepository repo = ref.read(runOrderRepositoryProvider);

    return PanelCard(
      accent: entry.role.tint,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _BlockHeader(
            entry: entry,
            startSeconds: startSeconds,
            isFirst: isFirst,
            isLast: isLast,
            onMove: onMove,
          ),
          if (entry.beats.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.lg),
              child: Text(
                'Empty. A block with nothing in it holds the act\'s readiness back.',
                style: AppText.caption,
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.symmetric(horizontal: Gap.md),
              itemCount: entry.beats.length,
              // onReorderItem hands back an index already corrected for the
              // removed item, so no off-by-one adjustment is needed here.
              onReorderItem: (int from, int to) {
                final List<int> ids = entry.beats
                    .map((RunOrderItemRow b) => b.id)
                    .toList(growable: true);
                ids.insert(to, ids.removeAt(from));
                repo.reorderBeats(blockId: entry.id, orderedBeatIds: ids);
              },
              itemBuilder: (BuildContext context, int index) {
                final RunOrderItemRow beat = entry.beats[index];
                return _BeatRow(
                  key: ValueKey<int>(beat.id),
                  beat: beat,
                  index: index,
                  onToggle: () => repo.updateBeat(
                    beatId: beat.id,
                    isConfirmed: !beat.isConfirmed,
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, Gap.md),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => TrickPickerSheet.show(
                      context,
                      blockId: entry.id,
                      blockTitle: entry.title,
                    ),
                    icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                    label: const Text('FROM LIBRARY'),
                  ),
                ),
                Gap.hSm,
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => BeatSheet.add(context, entry.id),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('OWN BEAT'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockHeader extends ConsumerWidget {
  const _BlockHeader({
    required this.entry,
    required this.startSeconds,
    required this.isFirst,
    required this.isLast,
    required this.onMove,
  });

  final RunOrderBlock entry;
  final int startSeconds;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<int> onMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int drift = entry.estimateDriftSeconds;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.sm, Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(entry.role.pin, height: 30),
              Gap.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      entry.role.label.toUpperCase(),
                      style: AppText.micro.copyWith(color: entry.role.tint),
                    ),
                    Text(entry.title, style: AppText.cardTitle, maxLines: 2),
                  ],
                ),
              ),
              PopupMenuButton<_BlockAction>(
                icon: const Icon(Icons.more_vert_rounded, color: Palette.brass),
                tooltip: 'Block options',
                onSelected: (_BlockAction action) => _handle(context, ref, action),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<_BlockAction>>[
                  const PopupMenuItem<_BlockAction>(
                    value: _BlockAction.edit,
                    child: Text('Edit block'),
                  ),
                  if (entry.beats.isNotEmpty)
                    PopupMenuItem<_BlockAction>(
                      value: _BlockAction.confirmAll,
                      child: Text(
                        entry.isFullyConfirmed
                            ? 'Mark beats unconfirmed'
                            : 'Mark all beats choreographed',
                      ),
                    ),
                  if (!isFirst)
                    const PopupMenuItem<_BlockAction>(
                      value: _BlockAction.moveUp,
                      child: Text('Move earlier'),
                    ),
                  if (!isLast)
                    const PopupMenuItem<_BlockAction>(
                      value: _BlockAction.moveDown,
                      child: Text('Move later'),
                    ),
                  const PopupMenuItem<_BlockAction>(
                    value: _BlockAction.delete,
                    child: Text('Delete block'),
                  ),
                ],
              ),
            ],
          ),
          if (entry.block.intent != null) ...<Widget>[
            Gap.vXs,
            Text(entry.block.intent!, style: AppText.caption),
          ],
          Gap.vMd,
          Row(
            children: <Widget>[
              Text('starts ${Fmt.clock(startSeconds)}', style: AppText.micro),
              Gap.hMd,
              Text(
                Fmt.clock(entry.actualSeconds),
                style: AppText.timecode.copyWith(fontSize: 13),
              ),
              if (entry.beats.isNotEmpty && drift != 0) ...<Widget>[
                Gap.hXs,
                Text(
                  drift > 0 ? '(+${Fmt.clock(drift)})' : '(−${Fmt.clock(-drift)})',
                  style: AppText.micro.copyWith(color: Palette.caution),
                ),
              ],
              const Spacer(),
              if (entry.beats.isNotEmpty)
                Text(
                  '${entry.confirmedCount}/${entry.beats.length} set',
                  style: AppText.micro.copyWith(
                    color: entry.isFullyConfirmed
                        ? Palette.emeraldGlow
                        : Palette.textTertiary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handle(
    BuildContext context,
    WidgetRef ref,
    _BlockAction action,
  ) async {
    final RunOrderRepository repo = ref.read(runOrderRepositoryProvider);

    switch (action) {
      case _BlockAction.edit:
        await BlockSheet.edit(context, entry.block);
      case _BlockAction.confirmAll:
        await repo.confirmBlock(entry.id, confirmed: !entry.isFullyConfirmed);
      case _BlockAction.moveUp:
        onMove(-1);
      case _BlockAction.moveDown:
        onMove(1);
      case _BlockAction.delete:
        await repo.deleteBlock(entry.id);
    }
  }
}

enum _BlockAction { edit, confirmAll, moveUp, moveDown, delete }

class _BeatRow extends StatelessWidget {
  const _BeatRow({
    required this.beat,
    required this.index,
    required this.onToggle,
    super.key,
  });

  final RunOrderItemRow beat;
  final int index;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.xs),
      child: Material(
        color: Palette.ink.withValues(alpha: 0.35),
        borderRadius: Corners.chip,
        child: InkWell(
          borderRadius: Corners.chip,
          onTap: () => BeatSheet.edit(context, beat),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.sm),
            child: Row(
              children: <Widget>[
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: Gap.xs),
                    child: Icon(Icons.drag_indicator_rounded,
                        size: 20, color: Palette.textTertiary),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        beat.label,
                        style: AppText.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (beat.cueNote != null)
                        Text(
                          beat.cueNote!,
                          style: AppText.micro,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Gap.hSm,
                Text(
                  Fmt.clock(beat.seconds),
                  style: AppText.timecode.copyWith(fontSize: 13),
                ),
                Gap.hXs,
                IconButton(
                  onPressed: onToggle,
                  tooltip: beat.isConfirmed
                      ? 'Choreographed — tap to unset'
                      : 'Mark as choreographed',
                  icon: Icon(
                    beat.isConfirmed
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: beat.isConfirmed ? Palette.emeraldGlow : Palette.textTertiary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

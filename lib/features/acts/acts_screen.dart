import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/act_summary.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../shared/act_widgets.dart';
import '../shared/page_frame.dart';
import 'new_act_sheet.dart';

/// Every act, split between those in preparation and the Playbill Archive.
class ActsScreen extends ConsumerStatefulWidget {
  const ActsScreen({super.key});

  @override
  ConsumerState<ActsScreen> createState() => _ActsScreenState();
}

class _ActsScreenState extends ConsumerState<ActsScreen> {
  bool _showArchive = false;

  Future<void> _createAct() async {
    final int? id = await NewActSheet.show(context);
    if (id != null && mounted) await context.push('/acts/$id');
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ActSummary>> source = _showArchive
        ? ref.watch(archivedActsProvider)
        : ref.watch(activeActsProvider);

    return PageFrame(
      hasDock: true,
      header: MarqueeHeader(
        title: _showArchive ? 'Playbill Archive' : 'Acts',
        subtitle: _showArchive
            ? 'Acts you have performed or shelved. Duplicate one to restage it.'
            : 'Everything currently in preparation.',
        crest: Ornaments.crestStar,
      ),
      floating: _showArchive
          ? null
          : FilledButton.icon(
              onPressed: _createAct,
              icon: const Icon(Icons.add_rounded),
              label: const Text('NEW ACT'),
            ),
      slivers: <Widget>[
        PageSliver(
          child: SegmentedButton<bool>(
            segments: const <ButtonSegment<bool>>[
              ButtonSegment<bool>(value: false, label: Text('In preparation')),
              ButtonSegment<bool>(value: true, label: Text('Archive')),
            ],
            selected: <bool>{_showArchive},
            showSelectedIcon: false,
            onSelectionChanged: (Set<bool> value) =>
                setState(() => _showArchive = value.first),
          ),
        ),
        PageSliver(
          top: Gap.xl,
          child: switch (source) {
            AsyncData(value: final List<ActSummary> list) when list.isEmpty =>
              _showArchive
                  ? const EmptyStage(
                      crest: Ornaments.crestStar,
                      title: 'The archive is empty',
                      body: 'Acts you archive keep their run order and stage plot, '
                          'so a routine can be brought back next season without '
                          'rebuilding it.',
                    )
                  : EmptyStage(
                      crest: Ornaments.crestTent,
                      title: 'No acts in preparation',
                      body: 'Open an act to get a run order, a checklist and a '
                          'stage plot laid out for you.',
                      actionLabel: 'New act',
                      onAction: _createAct,
                    ),
            AsyncData(value: final List<ActSummary> list) => Column(
                children: <Widget>[
                  for (final ActSummary summary in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: ActCard(
                        summary: summary,
                        onTap: () => context.push('/acts/${summary.id}'),
                      ),
                    ),
                ],
              ),
            AsyncError(:final Object error) => PanelCard(
                accent: Palette.danger,
                child: Text('Could not read your acts.\n$error',
                    style: AppText.caption),
              ),
            _ => const SizedBox(
                height: 120,
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          },
        ),
      ],
    );
  }
}

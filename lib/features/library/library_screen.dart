import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../data/repositories/trick_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';
import 'trick_sheet.dart';

/// The trick library: the bundled catalogue plus anything the user adds.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _search = TextEditingController();

  Discipline? _discipline;
  Mastery? _mastery;
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TrickFilter filter =
        (discipline: _discipline, mastery: _mastery, query: _query);
    final AsyncValue<List<TrickRow>> tricks = ref.watch(trickLibraryProvider(filter));
    final List<DisciplineStats> stats =
        ref.watch(disciplineStatsProvider).value ?? const <DisciplineStats>[];

    return PageFrame(
      hasDock: true,
      header: MarqueeHeader(
        title: 'Trick Library',
        subtitle: 'Your material, rated by how reliable it is on stage.',
        crest: Ornaments.crestMask,
      ),
      floating: FilledButton.icon(
        onPressed: () => TrickSheet.create(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('ADD A TRICK'),
      ),
      slivers: <Widget>[
        if (stats.isNotEmpty)
          PageSliver(
            child: PanelCard(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.lg,
                vertical: Gap.md,
              ),
              child: Row(
                children: <Widget>[
                  for (final DisciplineStats s in stats)
                    Expanded(
                      child: _DisciplineTile(
                        stats: s,
                        selected: _discipline == s.discipline,
                        onTap: () => setState(() {
                          _discipline = _discipline == s.discipline ? null : s.discipline;
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),
        PageSliver(
          top: Gap.lg,
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search tricks',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Clear',
                      onPressed: () {
                        _search.clear();
                        setState(() => _query = '');
                      },
                    ),
            ),
            onChanged: (String value) => setState(() => _query = value),
          ),
        ),
        PageSliver(
          top: Gap.md,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final Mastery mastery in Mastery.values)
                  Padding(
                    padding: const EdgeInsets.only(right: Gap.sm),
                    child: FilterChip(
                      label: Text(mastery.label),
                      avatar: Image.asset(mastery.badge, height: 16),
                      selected: _mastery == mastery,
                      onSelected: (bool on) =>
                          setState(() => _mastery = on ? mastery : null),
                    ),
                  ),
              ],
            ),
          ),
        ),
        PageSliver(
          top: Gap.lg,
          child: switch (tricks) {
            AsyncData(value: final List<TrickRow> list) when list.isEmpty => EmptyStage(
                crest: Ornaments.crestMask,
                title: 'Nothing matches',
                body: _query.isEmpty && _discipline == null && _mastery == null
                    ? 'Add the tricks you actually perform and rate how reliable '
                        'each one is.'
                    : 'No trick matches these filters. Clear them to see the whole '
                        'library.',
                actionLabel: _query.isEmpty && _discipline == null && _mastery == null
                    ? 'Add a trick'
                    : 'Clear filters',
                onAction: () {
                  if (_query.isEmpty && _discipline == null && _mastery == null) {
                    TrickSheet.create(context);
                  } else {
                    _search.clear();
                    setState(() {
                      _query = '';
                      _discipline = null;
                      _mastery = null;
                    });
                  }
                },
              ),
            AsyncData(value: final List<TrickRow> list) => Column(
                children: <Widget>[
                  for (final TrickRow trick in list)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.sm),
                      child: _TrickRowCard(trick: trick),
                    ),
                ],
              ),
            AsyncError(:final Object error) => PanelCard(
                accent: Palette.danger,
                child: Text('Could not read the library.\n$error',
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

class _DisciplineTile extends StatelessWidget {
  const _DisciplineTile({
    required this.stats,
    required this.selected,
    required this.onTap,
  });

  final DisciplineStats stats;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.sm),
        child: Column(
          children: <Widget>[
            AnimatedOpacity(
              opacity: selected ? 1 : 0.6,
              duration: Motion.quick,
              child: Image.asset(stats.discipline.icon, height: 30),
            ),
            Gap.vXs,
            Text(
              '${stats.showReady}/${stats.total}',
              style: AppText.timecode.copyWith(
                fontSize: 13,
                color: selected ? Palette.brassGlow : Palette.textPrimary,
              ),
            ),
            Text(
              stats.discipline.label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.micro.copyWith(
                color: selected ? Palette.brass : Palette.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrickRowCard extends StatelessWidget {
  const _TrickRowCard({required this.trick});

  final TrickRow trick;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
      onTap: () => TrickSheet.open(context, trick.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(trick.discipline.icon, height: 30),
          Gap.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        trick.name,
                        style: AppText.bodyStrong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (trick.safetyNote != null)
                      const Padding(
                        padding: EdgeInsets.only(left: Gap.xs),
                        child: Icon(Icons.shield_outlined,
                            size: 15, color: Palette.caution),
                      ),
                  ],
                ),
                Gap.vXxs,
                Row(
                  children: <Widget>[
                    _DifficultyPips(level: trick.difficulty),
                    Gap.hSm,
                    Text(
                      '${Fmt.duration(trick.typicalSeconds)}'
                      '${trick.timesRehearsed > 0 ? ' · drilled ${trick.timesRehearsed}×' : ''}',
                      style: AppText.micro,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap.hSm,
          Column(
            children: <Widget>[
              Image.asset(trick.mastery.badge, height: 22),
              Gap.vXxs,
              Text(
                trick.mastery.label.toUpperCase(),
                style: AppText.micro.copyWith(color: trick.mastery.tint, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Difficulty as five etched marks, filled to the trick's level.
class _DifficultyPips extends StatelessWidget {
  const _DifficultyPips({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 1; i <= 5; i++)
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i <= level ? Palette.brass : Palette.textDisabled,
              ),
            ),
          ),
      ],
    );
  }
}

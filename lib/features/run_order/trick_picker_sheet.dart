import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/format.dart';

/// Picks a trick from the library and places it in a block as a beat.
///
/// Several tricks are usually added in a row, so the sheet stays open and shows
/// what has been placed rather than closing after each one.
class TrickPickerSheet extends ConsumerStatefulWidget {
  const TrickPickerSheet({required this.blockId, required this.blockTitle, super.key});

  final int blockId;
  final String blockTitle;

  static Future<void> show(
    BuildContext context, {
    required int blockId,
    required String blockTitle,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          TrickPickerSheet(blockId: blockId, blockTitle: blockTitle),
    );
  }

  @override
  ConsumerState<TrickPickerSheet> createState() => _TrickPickerSheetState();
}

class _TrickPickerSheetState extends ConsumerState<TrickPickerSheet> {
  final TextEditingController _search = TextEditingController();

  Discipline? _discipline;
  String _query = '';
  final List<int> _placed = <int>[];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _place(TrickRow trick) async {
    await ref.read(runOrderRepositoryProvider).addBeatFromTrick(
      blockId: widget.blockId,
      trick: trick,
    );
    if (mounted) setState(() => _placed.add(trick.id));
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<TrickRow>> tricks = ref.watch(
      trickLibraryProvider((discipline: _discipline, mastery: null, query: _query)),
    );

    final double keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final double safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Material(
        type: MaterialType.transparency,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: Palette.stageWash,
            borderRadius: Corners.sheet,
            border: Border(top: BorderSide(color: Palette.hairlineStrong)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.92,
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Layout.pageInset,
                  Layout.pageInset,
                  Layout.pageInset,
                  0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ── Fixed header ──────────────────────────────────────
                    Text('Add from the library', style: AppText.screenTitle),
                    Gap.vXs,
                    Text(
                      _placed.isEmpty
                          ? 'Into ${widget.blockTitle}. Each trick brings its usual length.'
                          : '${_placed.length} '
                              '${_placed.length == 1 ? 'trick' : 'tricks'} added to '
                              '${widget.blockTitle}.',
                      style: AppText.caption,
                    ),
                    Gap.vLg,
                    TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: 'Search',
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
                    Gap.vMd,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          for (final Discipline discipline in Discipline.values)
                            Padding(
                              padding: const EdgeInsets.only(right: Gap.sm),
                              child: FilterChip(
                                label: Text(discipline.label),
                                avatar: Image.asset(discipline.icon, height: 16),
                                selected: _discipline == discipline,
                                onSelected: (bool on) => setState(
                                    () => _discipline = on ? discipline : null),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Gap.vMd,
                    const Divider(height: 1),
                    Gap.vSm,
                    // ── Scrollable trick list ─────────────────────────────
                    Flexible(
                      child: switch (tricks) {
                        AsyncData(value: final List<TrickRow> list)
                            when list.isEmpty =>
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: Gap.xl),
                            child: Text(
                              'No trick matches. Clear the filters, or add the '
                              'trick to your library first.',
                              style: AppText.caption,
                            ),
                          ),
                        AsyncData(value: final List<TrickRow> list) =>
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) =>
                                _PickerRow(
                              trick: list[index],
                              placedCount: _placed
                                  .where((int id) => id == list[index].id)
                                  .length,
                              onTap: () => _place(list[index]),
                            ),
                          ),
                        _ => const Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: Gap.xl),
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ),
                      },
                    ),
                    Gap.vSm,
                    // ── Fixed DONE button ─────────────────────────────────
                    Padding(
                      padding: EdgeInsets.only(
                        top: Gap.sm,
                        bottom: safeBottom > 0 ? safeBottom : Gap.md,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(_placed.isEmpty ? 'CLOSE' : 'DONE'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerRow extends StatelessWidget {
  const _PickerRow({
    required this.trick,
    required this.placedCount,
    required this.onTap,
  });

  final TrickRow trick;
  final int placedCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.sm),
      child: PanelCard(
        padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Image.asset(trick.discipline.icon, height: 26),
            Gap.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    trick.name,
                    style: AppText.bodyStrong,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${Fmt.duration(trick.typicalSeconds)} · ${trick.mastery.label}',
                    style: AppText.micro,
                  ),
                ],
              ),
            ),
            if (placedCount > 0)
              Padding(
                padding: const EdgeInsets.only(right: Gap.sm),
                child: Text(
                  '×$placedCount',
                  style: AppText.micro.copyWith(color: Palette.emeraldGlow),
                ),
              ),
            Icon(
              placedCount > 0 ? Icons.add_circle : Icons.add_circle_outline_rounded,
              color: Palette.brass,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../data/models/act_summary.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';
import 'note_editor_screen.dart';

/// Notes attached to one act.
///
/// Rendered as pages of paper: written material is the one thing in the app that
/// is the user's own words, and the ink-on-paper treatment keeps it distinct from
/// the app's own structure.
class NotesScreen extends ConsumerWidget {
  const NotesScreen({required this.actId, super.key});

  final int actId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NoteRow> notes =
        ref.watch(actNotesProvider(actId)).value ?? const <NoteRow>[];
    final ActSummary? summary = ref.watch(actSummaryProvider(actId)).value;

    return PageFrame(
      artworkOpacity: 0.16,
      header: MarqueeHeader(
        eyebrow: summary?.title,
        title: 'Notes',
        crest: Ornaments.crestShell,
        onBack: () => context.pop(),
      ),
      floating: FilledButton.icon(
        onPressed: () => NoteEditorScreen.create(context, actId: actId),
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('NEW NOTE'),
      ),
      slivers: <Widget>[
        if (notes.isEmpty)
          PageSliver(
            child: EmptyStage(
              crest: Ornaments.crestShell,
              title: 'No notes on this act',
              body: 'Keep the things that do not fit anywhere else: what the '
                  'director asked for, why a trick was cut, the timing that '
                  'finally worked.',
              actionLabel: 'Write the first note',
              onAction: () => NoteEditorScreen.create(context, actId: actId),
            ),
          )
        else
          PageSliver(
            child: Column(
              children: <Widget>[
                for (final NoteRow note in notes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.lg),
                    child: _NoteCard(note: note),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NoteCard extends ConsumerWidget {
  const _NoteCard({required this.note});

  final NoteRow note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaperCard(
      texture: note.stock.texture,
      onTap: () => NoteEditorScreen.open(context, note.id),
      child: PaperInk(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    note.title,
                    style: AppText.cardTitle.copyWith(color: Palette.textOnPaper),
                  ),
                ),
                IconButton(
                  onPressed: () => ref
                      .read(noteRepositoryProvider)
                      .setPinned(note.id, pinned: !note.isPinned),
                  tooltip: note.isPinned ? 'Unpin' : 'Pin to the top',
                  icon: Icon(
                    note.isPinned
                        ? Icons.push_pin_rounded
                        : Icons.push_pin_outlined,
                    size: 20,
                    color: note.isPinned
                        ? Palette.bordeauxGlow
                        : Palette.textOnPaperSoft,
                  ),
                ),
              ],
            ),
            if (note.body.trim().isNotEmpty) ...<Widget>[
              Gap.vXs,
              Text(
                note.body.trim(),
                style: AppText.body.copyWith(color: Palette.textOnPaper),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            Gap.vMd,
            Text(
              Fmt.relativeDay(note.updatedAt),
              style: AppText.micro.copyWith(color: Palette.textOnPaperSoft),
            ),
          ],
        ),
      ),
    );
  }
}

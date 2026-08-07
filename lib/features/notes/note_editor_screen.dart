import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../data/repositories/note_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';

/// Writes a note on a sheet of paper.
///
/// A full screen rather than a sheet, because a note is the one place in the app
/// where the user may type several paragraphs and needs the room.
class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({this.noteId, this.actId, super.key});

  /// Null when composing a new note.
  final int? noteId;

  /// The act the new note belongs to, or null for a loose note.
  final int? actId;

  static Future<void> create(BuildContext context, {int? actId}) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NoteEditorScreen(actId: actId),
        fullscreenDialog: true,
      ),
    );
  }

  static Future<void> open(BuildContext context, int noteId) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NoteEditorScreen(noteId: noteId),
      ),
    );
  }

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();

  PageRuling _ruling = PageRuling.lined;
  PaperStock _stock = PaperStock.aged;

  int? _noteId;
  bool _seeded = false;

  bool get _isNew => widget.noteId == null;

  @override
  void initState() {
    super.initState();
    _noteId = widget.noteId;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _seed(NoteRow note) {
    if (_seeded) return;
    _seeded = true;
    _title.text = note.title;
    _body.text = note.body;
    _ruling = note.ruling;
    _stock = note.stock;
  }

  /// Writes what is on screen. Called when leaving, and when the paper style
  /// changes so a style choice is never lost by backing out.
  Future<void> _save() async {
    final String title = _title.text.trim();
    if (title.isEmpty && _body.text.trim().isEmpty) return;

    final String safeTitle = title.isEmpty ? 'Untitled note' : title;
    final NoteRepository repo = ref.read(noteRepositoryProvider);

    if (_noteId == null) {
      _noteId = await repo.create(
        title: safeTitle,
        actId: widget.actId,
        body: _body.text,
        ruling: _ruling,
        stock: _stock,
      );
    } else {
      await repo.update(
        noteId: _noteId!,
        title: safeTitle,
        body: _body.text,
        ruling: _ruling,
        stock: _stock,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isNew) {
      final NoteRow? existing = ref.watch(noteProvider(widget.noteId!)).value;
      if (existing != null) _seed(existing);
    }

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (didPop) _save();
      },
      child: Scaffold(
        backgroundColor: Palette.ink,
        body: StageBackdrop(
          scene: StageScene.curtains,
          artworkOpacity: 0.12,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                MarqueeHeader(
                  title: _isNew ? 'New note' : 'Note',
                  onBack: () => Navigator.of(context).maybePop(),
                  trailing: PopupMenuButton<Object>(
                    icon: const Icon(Icons.style_outlined, color: Palette.brass),
                    tooltip: 'Paper',
                    onSelected: (Object value) async {
                      setState(() {
                        if (value is PaperStock) _stock = value;
                        if (value is PageRuling) _ruling = value;
                      });
                      await _save();
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<Object>>[
                      const PopupMenuItem<Object>(
                        enabled: false,
                        child: Text('PAPER'),
                      ),
                      for (final PaperStock stock in PaperStock.values)
                        CheckedPopupMenuItem<Object>(
                          value: stock,
                          checked: _stock == stock,
                          child: Text(stock.label),
                        ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<Object>(
                        enabled: false,
                        child: Text('RULING'),
                      ),
                      for (final PageRuling ruling in PageRuling.values)
                        CheckedPopupMenuItem<Object>(
                          value: ruling,
                          checked: _ruling == ruling,
                          child: Text(ruling.label),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Layout.pageInset,
                      0,
                      Layout.pageInset,
                      Layout.pageInset,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: Corners.card,
                        border: Border.all(color: Palette.brassDim),
                      ),
                      child: ClipRRect(
                        borderRadius: Corners.card,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(
                              _stock.texture,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                            ),
                            // The ruling is the page's lines, tiled behind the
                            // text so writing sits on it rather than over it.
                            Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                _ruling.sheet,
                                fit: BoxFit.cover,
                                repeat: ImageRepeat.repeatY,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            const Positioned.fill(
                              child: ColoredBox(color: Color(0x33F3E7C6)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(Gap.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextField(
                                    controller: _title,
                                    autofocus: _isNew,
                                    textCapitalization: TextCapitalization.sentences,
                                    maxLength: 120,
                                    style: AppText.cardTitle
                                        .copyWith(color: Palette.textOnPaper),
                                    cursorColor: Palette.bordeaux,
                                    decoration: InputDecoration(
                                      hintText: 'Title',
                                      counterText: '',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      filled: false,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: AppText.cardTitle
                                          .copyWith(color: Palette.textOnPaperSoft),
                                    ),
                                  ),
                                  const Divider(color: Palette.textOnPaperSoft),
                                  Expanded(
                                    child: TextField(
                                      controller: _body,
                                      maxLines: null,
                                      expands: true,
                                      textAlignVertical: TextAlignVertical.top,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      style: AppText.body
                                          .copyWith(color: Palette.textOnPaper),
                                      cursorColor: Palette.bordeaux,
                                      decoration: InputDecoration(
                                        hintText: 'Write it down…',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        filled: false,
                                        contentPadding: EdgeInsets.zero,
                                        hintStyle: AppText.body
                                            .copyWith(color: Palette.textOnPaperSoft),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';

/// Reads and writes technical notes.
///
/// A note either belongs to an act or stands on its own, which covers both
/// "lighting for the Winter Gala" and general craft notes kept between shows.
class NoteRepository {
  NoteRepository(this._db);

  final AppDatabase _db;

  Stream<List<NoteRow>> watchForAct(int actId) {
    return (_db.select(_db.notes)
          ..where((Notes t) => t.actId.equals(actId))
          ..orderBy(<OrderClauseGenerator<Notes>>[
            (Notes t) => OrderingTerm.desc(t.isPinned),
            (Notes t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .watch();
  }

  /// Notes not attached to any act.
  Stream<List<NoteRow>> watchLoose() {
    return (_db.select(_db.notes)
          ..where((Notes t) => t.actId.isNull())
          ..orderBy(<OrderClauseGenerator<Notes>>[
            (Notes t) => OrderingTerm.desc(t.isPinned),
            (Notes t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .watch();
  }

  Stream<List<NoteRow>> watchAll({String query = ''}) {
    final String needle = query.trim();
    final SimpleSelectStatement<Notes, NoteRow> select = _db.select(_db.notes)
      ..orderBy(<OrderClauseGenerator<Notes>>[
        (Notes t) => OrderingTerm.desc(t.isPinned),
        (Notes t) => OrderingTerm.desc(t.updatedAt),
      ]);
    if (needle.isNotEmpty) {
      select.where((Notes t) => t.title.contains(needle) | t.body.contains(needle));
    }
    return select.watch();
  }

  Stream<NoteRow?> watchOne(int noteId) {
    return (_db.select(_db.notes)..where((Notes t) => t.id.equals(noteId)))
        .watchSingleOrNull();
  }

  Future<int> create({
    required String title,
    int? actId,
    String body = '',
    PageRuling ruling = PageRuling.lined,
    PaperStock stock = PaperStock.aged,
  }) {
    final DateTime now = DateTime.now();
    return _db.into(_db.notes).insert(
      NotesCompanion.insert(
        actId: Value<int?>(actId),
        title: title.trim(),
        body: Value<String>(body),
        ruling: Value<PageRuling>(ruling),
        stock: Value<PaperStock>(stock),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> update({
    required int noteId,
    String? title,
    String? body,
    PageRuling? ruling,
    PaperStock? stock,
  }) {
    return (_db.update(_db.notes)..where((Notes t) => t.id.equals(noteId))).write(
      NotesCompanion(
        title: title == null ? const Value<String>.absent() : Value<String>(title.trim()),
        body: body == null ? const Value<String>.absent() : Value<String>(body),
        ruling: ruling == null
            ? const Value<PageRuling>.absent()
            : Value<PageRuling>(ruling),
        stock: stock == null ? const Value<PaperStock>.absent() : Value<PaperStock>(stock),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  Future<void> setPinned(int noteId, {required bool pinned}) {
    return (_db.update(_db.notes)..where((Notes t) => t.id.equals(noteId))).write(
      NotesCompanion(
        isPinned: Value<bool>(pinned),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Moves a note between acts, or detaches it when [actId] is null.
  Future<void> reassign({required int noteId, required int? actId}) {
    return (_db.update(_db.notes)..where((Notes t) => t.id.equals(noteId))).write(
      NotesCompanion(
        actId: Value<int?>(actId),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  Future<void> delete(int noteId) =>
      (_db.delete(_db.notes)..where((Notes t) => t.id.equals(noteId))).go();
}

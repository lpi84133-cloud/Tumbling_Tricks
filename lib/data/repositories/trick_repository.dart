import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';

/// How much material a discipline holds and how far along it is.
class DisciplineStats {
  const DisciplineStats({
    required this.discipline,
    required this.total,
    required this.showReady,
    required this.inUse,
  });

  final Discipline discipline;
  final int total;

  /// Tricks rated show-ready.
  final int showReady;

  /// Tricks currently placed in at least one act's run order.
  final int inUse;

  double get readyFraction => total == 0 ? 0 : showReady / total;
}

/// Reads and writes the trick library.
class TrickRepository {
  TrickRepository(this._db);

  final AppDatabase _db;

  /// The library, filtered and searched. Archived tricks stay hidden unless
  /// asked for.
  Stream<List<TrickRow>> watchLibrary({
    Discipline? discipline,
    Mastery? mastery,
    String query = '',
    bool includeArchived = false,
  }) {
    final String needle = query.trim();

    final SimpleSelectStatement<Tricks, TrickRow> select = _db.select(_db.tricks)
      ..orderBy(<OrderClauseGenerator<Tricks>>[
        (Tricks t) => OrderingTerm.asc(t.difficulty),
        (Tricks t) => OrderingTerm.asc(t.name),
      ]);

    if (!includeArchived) {
      select.where((Tricks t) => t.isArchived.equals(false));
    }
    // Enum columns carry a type converter, which only the generated table class
    // exposes; referencing the column through the database keeps the comparison
    // typed as the enum rather than its stored string.
    if (discipline != null) {
      final Expression<bool> matches = _db.tricks.discipline.equalsValue(discipline);
      select.where((Tricks t) => matches);
    }
    if (mastery != null) {
      final Expression<bool> matches = _db.tricks.mastery.equalsValue(mastery);
      select.where((Tricks t) => matches);
    }
    if (needle.isNotEmpty) {
      select.where(
        (Tricks t) => t.name.contains(needle) | t.summary.contains(needle),
      );
    }

    return select.watch();
  }

  Stream<TrickRow?> watchOne(int trickId) {
    return (_db.select(_db.tricks)..where((Tricks t) => t.id.equals(trickId)))
        .watchSingleOrNull();
  }

  /// One row per discipline, whether or not it currently holds any tricks, so
  /// the library always shows all four sections.
  Stream<List<DisciplineStats>> watchDisciplineStats() {
    return _db
        .customSelect(
          '''
          SELECT
            t.discipline AS discipline,
            COUNT(*) AS total,
            SUM(CASE WHEN t.mastery = ? THEN 1 ELSE 0 END) AS show_ready,
            SUM(
              CASE WHEN EXISTS (
                SELECT 1 FROM run_order_items r WHERE r.trick_id = t.id
              ) THEN 1 ELSE 0 END
            ) AS in_use
          FROM tricks t
          WHERE t.is_archived = 0
          GROUP BY t.discipline
          ''',
          variables: <Variable<Object>>[Variable<String>(Mastery.showReady.name)],
          readsFrom: <ResultSetImplementation<Object, Object>>{
            _db.tricks,
            _db.runOrderItems,
          },
        )
        .watch()
        .map((List<QueryRow> rows) {
          final Map<Discipline, DisciplineStats> byDiscipline =
              <Discipline, DisciplineStats>{};

          for (final QueryRow row in rows) {
            final Discipline? discipline = Discipline.values
                .where((Discipline d) => d.name == row.read<String>('discipline'))
                .firstOrNull;
            if (discipline == null) continue;
            byDiscipline[discipline] = DisciplineStats(
              discipline: discipline,
              total: row.read<int>('total'),
              showReady: row.read<int>('show_ready'),
              inUse: row.read<int>('in_use'),
            );
          }

          return Discipline.values
              .map(
                (Discipline d) =>
                    byDiscipline[d] ??
                    DisciplineStats(discipline: d, total: 0, showReady: 0, inUse: 0),
              )
              .toList(growable: false);
        });
  }

  Future<int> create({
    required String name,
    required Discipline discipline,
    int difficulty = 1,
    String summary = '',
    String? setupNote,
    String? safetyNote,
    int typicalSeconds = 12,
  }) {
    final DateTime now = DateTime.now();
    return _db.into(_db.tricks).insert(
      TricksCompanion.insert(
        name: name.trim(),
        discipline: discipline,
        difficulty: Value<int>(difficulty.clamp(1, 5)),
        summary: Value<String>(summary.trim()),
        setupNote: Value<String?>(_blankToNull(setupNote)),
        safetyNote: Value<String?>(_blankToNull(safetyNote)),
        typicalSeconds: Value<int>(typicalSeconds),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> update({
    required int trickId,
    String? name,
    Discipline? discipline,
    int? difficulty,
    String? summary,
    String? setupNote,
    String? safetyNote,
    int? typicalSeconds,
  }) {
    return (_db.update(_db.tricks)..where((Tricks t) => t.id.equals(trickId))).write(
      TricksCompanion(
        name: name == null ? const Value<String>.absent() : Value<String>(name.trim()),
        discipline: discipline == null
            ? const Value<Discipline>.absent()
            : Value<Discipline>(discipline),
        difficulty:
            difficulty == null ? const Value<int>.absent() : Value<int>(difficulty.clamp(1, 5)),
        summary:
            summary == null ? const Value<String>.absent() : Value<String>(summary.trim()),
        setupNote: setupNote == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(setupNote)),
        safetyNote: safetyNote == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(safetyNote)),
        typicalSeconds:
            typicalSeconds == null ? const Value<int>.absent() : Value<int>(typicalSeconds),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  Future<void> setMastery(int trickId, Mastery mastery) {
    return (_db.update(_db.tricks)..where((Tricks t) => t.id.equals(trickId))).write(
      TricksCompanion(
        mastery: Value<Mastery>(mastery),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Archiving is offered instead of deletion for catalogue entries, so the
  /// library can be trimmed without losing the reference material.
  Future<void> setArchived(int trickId, {required bool archived}) {
    return (_db.update(_db.tricks)..where((Tricks t) => t.id.equals(trickId))).write(
      TricksCompanion(
        isArchived: Value<bool>(archived),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Only the user's own tricks can be deleted outright; the run-order beats
  /// that referenced them keep their label and lose the link.
  Future<bool> delete(int trickId) async {
    final TrickRow? row = await (_db.select(_db.tricks)
          ..where((Tricks t) => t.id.equals(trickId)))
        .getSingleOrNull();
    if (row == null || row.isCatalog) return false;

    await (_db.delete(_db.tricks)..where((Tricks t) => t.id.equals(trickId))).go();
    return true;
  }

  static String? _blankToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';

/// Reads and writes the two preparation lists an act carries: the rehearsal
/// checklist and the stage plot.
///
/// They behave identically — an ordered list of lines with a done flag — so they
/// share one repository rather than two near-copies.
class PreparationRepository {
  PreparationRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------- checklist

  Stream<List<ChecklistItemRow>> watchChecklist(int actId) {
    return (_db.select(_db.checklistItems)
          ..where((ChecklistItems t) => t.actId.equals(actId))
          ..orderBy(<OrderClauseGenerator<ChecklistItems>>[
            (ChecklistItems t) => OrderingTerm.asc(t.position),
            (ChecklistItems t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  Future<int> addCheck({
    required int actId,
    required ChecklistCategory category,
    required String label,
    String? detail,
  }) async {
    return _db.transaction<int>(() async {
      final int position = await _nextPosition(
        _db.checklistItems,
        _db.checklistItems.position,
        _db.checklistItems.actId.equals(actId),
      );
      final int id = await _db.into(_db.checklistItems).insert(
        ChecklistItemsCompanion.insert(
          actId: actId,
          category: category,
          label: label.trim(),
          detail: Value<String?>(_blankToNull(detail)),
          position: position,
        ),
      );
      await _touchAct(actId);
      return id;
    });
  }

  /// Ticking a check stamps the time, which is what the Progress screen uses to
  /// show what was cleared this week.
  Future<void> setCheckDone(int itemId, {required bool done}) async {
    await (_db.update(_db.checklistItems)
          ..where((ChecklistItems t) => t.id.equals(itemId)))
        .write(
      ChecklistItemsCompanion(
        isDone: Value<bool>(done),
        doneAt: Value<DateTime?>(done ? DateTime.now() : null),
      ),
    );
    await _touchActOfCheck(itemId);
  }

  Future<void> updateCheck({
    required int itemId,
    String? label,
    String? detail,
    ChecklistCategory? category,
  }) async {
    await (_db.update(_db.checklistItems)
          ..where((ChecklistItems t) => t.id.equals(itemId)))
        .write(
      ChecklistItemsCompanion(
        label: label == null ? const Value<String>.absent() : Value<String>(label.trim()),
        detail: detail == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(detail)),
        category: category == null
            ? const Value<ChecklistCategory>.absent()
            : Value<ChecklistCategory>(category),
      ),
    );
    await _touchActOfCheck(itemId);
  }

  Future<void> deleteCheck(int itemId) async {
    await (_db.delete(_db.checklistItems)
          ..where((ChecklistItems t) => t.id.equals(itemId)))
        .go();
  }

  Future<void> reorderChecklist({
    required int actId,
    required List<int> orderedIds,
  }) async {
    await _db.batch((Batch batch) {
      for (int i = 0; i < orderedIds.length; i++) {
        batch.update(
          _db.checklistItems,
          ChecklistItemsCompanion(position: Value<int>(i)),
          where: (ChecklistItems t) => t.id.equals(orderedIds[i]),
        );
      }
    });
    await _touchAct(actId);
  }

  /// Clears every tick, for when the act is being prepared for another date.
  Future<void> resetChecklist(int actId) async {
    await (_db.update(_db.checklistItems)
          ..where((ChecklistItems t) => t.actId.equals(actId)))
        .write(
      const ChecklistItemsCompanion(
        isDone: Value<bool>(false),
        doneAt: Value<DateTime?>(null),
      ),
    );
    await _touchAct(actId);
  }

  // --------------------------------------------------------------- stage plot

  Stream<List<StagePlotItemRow>> watchStagePlot(int actId) {
    return (_db.select(_db.stagePlotItems)
          ..where((StagePlotItems t) => t.actId.equals(actId))
          ..orderBy(<OrderClauseGenerator<StagePlotItems>>[
            (StagePlotItems t) => OrderingTerm.asc(t.position),
            (StagePlotItems t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  Future<int> addPlotLine({
    required int actId,
    required StageEquipment equipment,
    required String label,
    String? spec,
  }) async {
    return _db.transaction<int>(() async {
      final int position = await _nextPosition(
        _db.stagePlotItems,
        _db.stagePlotItems.position,
        _db.stagePlotItems.actId.equals(actId),
      );
      final int id = await _db.into(_db.stagePlotItems).insert(
        StagePlotItemsCompanion.insert(
          actId: actId,
          equipment: equipment,
          label: label.trim(),
          spec: Value<String?>(_blankToNull(spec)),
          position: position,
        ),
      );
      await _touchAct(actId);
      return id;
    });
  }

  Future<void> setPlotConfirmed(int itemId, {required bool confirmed}) async {
    await (_db.update(_db.stagePlotItems)
          ..where((StagePlotItems t) => t.id.equals(itemId)))
        .write(StagePlotItemsCompanion(isConfirmed: Value<bool>(confirmed)));
    await _touchActOfPlotLine(itemId);
  }

  Future<void> updatePlotLine({
    required int itemId,
    String? label,
    String? spec,
    StageEquipment? equipment,
  }) async {
    await (_db.update(_db.stagePlotItems)
          ..where((StagePlotItems t) => t.id.equals(itemId)))
        .write(
      StagePlotItemsCompanion(
        label: label == null ? const Value<String>.absent() : Value<String>(label.trim()),
        spec:
            spec == null ? const Value<String?>.absent() : Value<String?>(_blankToNull(spec)),
        equipment: equipment == null
            ? const Value<StageEquipment>.absent()
            : Value<StageEquipment>(equipment),
      ),
    );
    await _touchActOfPlotLine(itemId);
  }

  Future<void> deletePlotLine(int itemId) async {
    await (_db.delete(_db.stagePlotItems)
          ..where((StagePlotItems t) => t.id.equals(itemId)))
        .go();
  }

  Future<void> reorderStagePlot({
    required int actId,
    required List<int> orderedIds,
  }) async {
    await _db.batch((Batch batch) {
      for (int i = 0; i < orderedIds.length; i++) {
        batch.update(
          _db.stagePlotItems,
          StagePlotItemsCompanion(position: Value<int>(i)),
          where: (StagePlotItems t) => t.id.equals(orderedIds[i]),
        );
      }
    });
    await _touchAct(actId);
  }

  // ------------------------------------------------------------------ helpers

  Future<int> _nextPosition<T extends HasResultSet, R>(
    ResultSetImplementation<T, R> table,
    GeneratedColumn<int> positionColumn,
    Expression<bool> filter,
  ) async {
    final Expression<int> highest = positionColumn.max();
    final TypedResult row = await (_db.selectOnly(table)
          ..addColumns(<Expression<Object>>[highest])
          ..where(filter))
        .getSingle();
    return (row.read<int>(highest) ?? -1) + 1;
  }

  Future<void> _touchAct(int actId) {
    return (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId))).write(
      ActsCompanion(updatedAt: Value<DateTime>(DateTime.now())),
    );
  }

  Future<void> _touchActOfCheck(int itemId) async {
    final ChecklistItemRow? row = await (_db.select(_db.checklistItems)
          ..where((ChecklistItems t) => t.id.equals(itemId)))
        .getSingleOrNull();
    if (row != null) await _touchAct(row.actId);
  }

  Future<void> _touchActOfPlotLine(int itemId) async {
    final StagePlotItemRow? row = await (_db.select(_db.stagePlotItems)
          ..where((StagePlotItems t) => t.id.equals(itemId)))
        .getSingleOrNull();
    if (row != null) await _touchAct(row.actId);
  }

  static String? _blankToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

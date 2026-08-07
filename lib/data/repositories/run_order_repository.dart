import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';
import '../models/run_order.dart';

/// Reads and writes the run order: the blocks of an act and the beats inside
/// them.
///
/// Positions are always kept as a dense, zero-based sequence. Every operation
/// that could leave a gap renumbers the affected list inside the same
/// transaction, so a reorder never has to reason about stale indices.
class RunOrderRepository {
  RunOrderRepository(this._db);

  final AppDatabase _db;

  /// The whole run order of an act, blocks and beats in performance order.
  Stream<RunOrder> watch(int actId) {
    final query = _db.select(_db.actBlocks).join(<Join<HasResultSet, dynamic>>[
      leftOuterJoin(
        _db.runOrderItems,
        _db.runOrderItems.blockId.equalsExp(_db.actBlocks.id),
      ),
    ])
      ..where(_db.actBlocks.actId.equals(actId))
      ..orderBy(<OrderingTerm>[
        OrderingTerm.asc(_db.actBlocks.position),
        OrderingTerm.asc(_db.runOrderItems.position),
      ]);

    return query.watch().map((List<TypedResult> rows) {
      final List<RunOrderBlock> blocks = <RunOrderBlock>[];
      final Map<int, List<RunOrderItemRow>> beatsByBlock = <int, List<RunOrderItemRow>>{};
      final Map<int, ActBlockRow> blockById = <int, ActBlockRow>{};
      final List<int> order = <int>[];

      for (final TypedResult row in rows) {
        final ActBlockRow block = row.readTable(_db.actBlocks);
        if (!blockById.containsKey(block.id)) {
          blockById[block.id] = block;
          beatsByBlock[block.id] = <RunOrderItemRow>[];
          order.add(block.id);
        }
        // Left join: a block with no beats still produces one row, with nulls.
        final RunOrderItemRow? beat = row.readTableOrNull(_db.runOrderItems);
        if (beat != null) beatsByBlock[block.id]!.add(beat);
      }

      for (final int id in order) {
        blocks.add(RunOrderBlock(block: blockById[id]!, beats: beatsByBlock[id]!));
      }

      return RunOrder(actId: actId, blocks: blocks);
    });
  }

  // ------------------------------------------------------------------- blocks

  Future<int> addBlock({
    required int actId,
    required BlockRole role,
    required String title,
    String? intent,
    int plannedSeconds = 30,
  }) async {
    final DateTime now = DateTime.now();

    return _db.transaction<int>(() async {
      final int position = await _nextPosition(
        _db.actBlocks,
        _db.actBlocks.position,
        _db.actBlocks.actId.equals(actId),
      );

      final int id = await _db.into(_db.actBlocks).insert(
        ActBlocksCompanion.insert(
          actId: actId,
          role: role,
          title: title.trim(),
          intent: Value<String?>(_blankToNull(intent)),
          plannedSeconds: Value<int>(plannedSeconds),
          position: position,
          createdAt: now,
          updatedAt: now,
        ),
      );

      await _touchAct(actId);
      return id;
    });
  }

  Future<void> updateBlock({
    required int blockId,
    String? title,
    String? intent,
    int? plannedSeconds,
    BlockRole? role,
  }) async {
    await (_db.update(_db.actBlocks)..where((ActBlocks t) => t.id.equals(blockId)))
        .write(
      ActBlocksCompanion(
        title: title == null ? const Value<String>.absent() : Value<String>(title.trim()),
        intent: intent == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(intent)),
        plannedSeconds:
            plannedSeconds == null ? const Value<int>.absent() : Value<int>(plannedSeconds),
        role: role == null ? const Value<BlockRole>.absent() : Value<BlockRole>(role),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
    await _touchActOfBlock(blockId);
  }

  Future<void> deleteBlock(int blockId) async {
    await _db.transaction(() async {
      final int? actId = await _actIdOfBlock(blockId);
      await (_db.delete(_db.actBlocks)..where((ActBlocks t) => t.id.equals(blockId)))
          .go();
      if (actId != null) {
        await _renumberBlocks(actId);
        await _touchAct(actId);
      }
    });
  }

  /// Applies a drag-and-drop reorder. [orderedBlockIds] is the complete new
  /// order of the act's blocks.
  Future<void> reorderBlocks({
    required int actId,
    required List<int> orderedBlockIds,
  }) async {
    final DateTime now = DateTime.now();

    await _db.transaction(() async {
      await _db.batch((Batch batch) {
        for (int i = 0; i < orderedBlockIds.length; i++) {
          batch.update(
            _db.actBlocks,
            ActBlocksCompanion(position: Value<int>(i), updatedAt: Value<DateTime>(now)),
            where: (ActBlocks t) => t.id.equals(orderedBlockIds[i]),
          );
        }
      });
      await _touchAct(actId);
    });
  }

  // -------------------------------------------------------------------- beats

  /// Adds a free-form beat, one that is not a catalogued trick.
  Future<int> addBeat({
    required int blockId,
    required String label,
    int seconds = 15,
    String? cueNote,
    int? trickId,
  }) async {
    return _db.transaction<int>(() async {
      final int position = await _nextPosition(
        _db.runOrderItems,
        _db.runOrderItems.position,
        _db.runOrderItems.blockId.equals(blockId),
      );

      final int id = await _db.into(_db.runOrderItems).insert(
        RunOrderItemsCompanion.insert(
          blockId: blockId,
          trickId: Value<int?>(trickId),
          label: label.trim(),
          cueNote: Value<String?>(_blankToNull(cueNote)),
          seconds: Value<int>(seconds),
          position: position,
        ),
      );

      await _touchActOfBlock(blockId);
      return id;
    });
  }

  /// Places a trick from the library into a block, carrying its name and
  /// typical duration across as the starting values.
  Future<int> addBeatFromTrick({
    required int blockId,
    required TrickRow trick,
    String? cueNote,
  }) {
    return addBeat(
      blockId: blockId,
      label: trick.name,
      seconds: trick.typicalSeconds,
      cueNote: cueNote,
      trickId: trick.id,
    );
  }

  Future<void> updateBeat({
    required int beatId,
    String? label,
    String? cueNote,
    int? seconds,
    bool? isConfirmed,
  }) async {
    await (_db.update(_db.runOrderItems)
          ..where((RunOrderItems t) => t.id.equals(beatId)))
        .write(
      RunOrderItemsCompanion(
        label: label == null ? const Value<String>.absent() : Value<String>(label.trim()),
        cueNote: cueNote == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(cueNote)),
        seconds: seconds == null ? const Value<int>.absent() : Value<int>(seconds),
        isConfirmed:
            isConfirmed == null ? const Value<bool>.absent() : Value<bool>(isConfirmed),
      ),
    );
    await _touchActOfBeat(beatId);
  }

  Future<void> deleteBeat(int beatId) async {
    await _db.transaction(() async {
      final int? blockId = await _blockIdOfBeat(beatId);
      await (_db.delete(_db.runOrderItems)
            ..where((RunOrderItems t) => t.id.equals(beatId)))
          .go();
      if (blockId != null) {
        await _renumberBeats(blockId);
        await _touchActOfBlock(blockId);
      }
    });
  }

  /// Applies a reorder inside one block.
  Future<void> reorderBeats({
    required int blockId,
    required List<int> orderedBeatIds,
  }) async {
    await _db.transaction(() async {
      await _db.batch((Batch batch) {
        for (int i = 0; i < orderedBeatIds.length; i++) {
          batch.update(
            _db.runOrderItems,
            RunOrderItemsCompanion(position: Value<int>(i)),
            where: (RunOrderItems t) => t.id.equals(orderedBeatIds[i]),
          );
        }
      });
      await _touchActOfBlock(blockId);
    });
  }

  /// Moves a beat into another block at [targetIndex], renumbering both lists.
  Future<void> moveBeat({
    required int beatId,
    required int targetBlockId,
    required int targetIndex,
  }) async {
    await _db.transaction(() async {
      final int? sourceBlockId = await _blockIdOfBeat(beatId);
      if (sourceBlockId == null) return;

      // Park it at the end of the target list first, then renumber, so the
      // dense-position invariant holds even mid-transaction.
      await (_db.update(_db.runOrderItems)
            ..where((RunOrderItems t) => t.id.equals(beatId)))
          .write(
        RunOrderItemsCompanion(
          blockId: Value<int>(targetBlockId),
          position: Value<int>(1 << 20),
        ),
      );

      if (sourceBlockId != targetBlockId) {
        await _renumberBeats(sourceBlockId);
      }

      final List<int> ids = await _beatIdsInOrder(targetBlockId);
      ids.remove(beatId);
      final int index = targetIndex.clamp(0, ids.length);
      ids.insert(index, beatId);

      await _db.batch((Batch batch) {
        for (int i = 0; i < ids.length; i++) {
          batch.update(
            _db.runOrderItems,
            RunOrderItemsCompanion(position: Value<int>(i)),
            where: (RunOrderItems t) => t.id.equals(ids[i]),
          );
        }
      });

      await _touchActOfBlock(targetBlockId);
    });
  }

  /// Marks every beat in a block as choreographed, for when a whole section has
  /// been worked through in one rehearsal.
  Future<void> confirmBlock(int blockId, {required bool confirmed}) async {
    await (_db.update(_db.runOrderItems)
          ..where((RunOrderItems t) => t.blockId.equals(blockId)))
        .write(RunOrderItemsCompanion(isConfirmed: Value<bool>(confirmed)));
    await _touchActOfBlock(blockId);
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

  Future<List<int>> _beatIdsInOrder(int blockId) async {
    final List<RunOrderItemRow> rows = await (_db.select(_db.runOrderItems)
          ..where((RunOrderItems t) => t.blockId.equals(blockId))
          ..orderBy(<OrderClauseGenerator<RunOrderItems>>[
            (RunOrderItems t) => OrderingTerm.asc(t.position),
            (RunOrderItems t) => OrderingTerm.asc(t.id),
          ]))
        .get();
    return rows.map((RunOrderItemRow r) => r.id).toList();
  }

  Future<void> _renumberBeats(int blockId) async {
    final List<int> ids = await _beatIdsInOrder(blockId);
    await _db.batch((Batch batch) {
      for (int i = 0; i < ids.length; i++) {
        batch.update(
          _db.runOrderItems,
          RunOrderItemsCompanion(position: Value<int>(i)),
          where: (RunOrderItems t) => t.id.equals(ids[i]),
        );
      }
    });
  }

  Future<void> _renumberBlocks(int actId) async {
    final List<ActBlockRow> rows = await (_db.select(_db.actBlocks)
          ..where((ActBlocks t) => t.actId.equals(actId))
          ..orderBy(<OrderClauseGenerator<ActBlocks>>[
            (ActBlocks t) => OrderingTerm.asc(t.position),
            (ActBlocks t) => OrderingTerm.asc(t.id),
          ]))
        .get();

    await _db.batch((Batch batch) {
      for (int i = 0; i < rows.length; i++) {
        batch.update(
          _db.actBlocks,
          ActBlocksCompanion(position: Value<int>(i)),
          where: (ActBlocks t) => t.id.equals(rows[i].id),
        );
      }
    });
  }

  Future<int?> _actIdOfBlock(int blockId) async {
    final ActBlockRow? row = await (_db.select(_db.actBlocks)
          ..where((ActBlocks t) => t.id.equals(blockId)))
        .getSingleOrNull();
    return row?.actId;
  }

  Future<int?> _blockIdOfBeat(int beatId) async {
    final RunOrderItemRow? row = await (_db.select(_db.runOrderItems)
          ..where((RunOrderItems t) => t.id.equals(beatId)))
        .getSingleOrNull();
    return row?.blockId;
  }

  Future<void> _touchAct(int actId) {
    return (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId))).write(
      ActsCompanion(updatedAt: Value<DateTime>(DateTime.now())),
    );
  }

  Future<void> _touchActOfBlock(int blockId) async {
    final int? actId = await _actIdOfBlock(blockId);
    if (actId != null) await _touchAct(actId);
  }

  Future<void> _touchActOfBeat(int beatId) async {
    final int? blockId = await _blockIdOfBeat(beatId);
    if (blockId != null) await _touchActOfBlock(blockId);
  }

  static String? _blankToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';
import '../models/act_summary.dart';
import '../seed/act_template.dart';

/// Reads and writes acts.
///
/// The summary query below is the app's busiest read: the Stage Console, the act
/// list and the Progress screen all draw from it. It is deliberately one
/// statement with correlated aggregates rather than a per-card follow-up read,
/// so a list of twenty acts still costs a single query and a single rebuild.
class ActRepository {
  ActRepository(this._db);

  final AppDatabase _db;

  static const String _summaryColumns = '''
    a.*,
    (SELECT COUNT(*) FROM act_blocks b WHERE b.act_id = a.id) AS block_count,
    (SELECT COUNT(*) FROM act_blocks b WHERE b.act_id = a.id
       AND EXISTS (SELECT 1 FROM run_order_items r WHERE r.block_id = b.id)
    ) AS filled_block_count,
    (SELECT COUNT(*) FROM run_order_items r
       JOIN act_blocks b ON b.id = r.block_id WHERE b.act_id = a.id
    ) AS beat_count,
    (SELECT COUNT(*) FROM run_order_items r
       JOIN act_blocks b ON b.id = r.block_id
       WHERE b.act_id = a.id AND r.is_confirmed = 1
    ) AS confirmed_beat_count,
    (SELECT COALESCE(SUM(r.seconds), 0) FROM run_order_items r
       JOIN act_blocks b ON b.id = r.block_id WHERE b.act_id = a.id
    ) AS planned_seconds,
    (SELECT COUNT(*) FROM checklist_items c WHERE c.act_id = a.id) AS checklist_total,
    (SELECT COUNT(*) FROM checklist_items c WHERE c.act_id = a.id AND c.is_done = 1
    ) AS checklist_done,
    (SELECT COUNT(*) FROM stage_plot_items s WHERE s.act_id = a.id) AS plot_total,
    (SELECT COUNT(*) FROM stage_plot_items s WHERE s.act_id = a.id AND s.is_confirmed = 1
    ) AS plot_confirmed,
    (SELECT COUNT(*) FROM rehearsals h WHERE h.act_id = a.id) AS rehearsal_count,
    (SELECT COUNT(*) FROM notes n WHERE n.act_id = a.id) AS note_count,
    (SELECT MAX(h.happened_at) FROM rehearsals h WHERE h.act_id = a.id
    ) AS last_rehearsed_at,
    -- Mean confidence of the three most recent sessions. The inner query finds
    -- the cut-off timestamp and yields NULL with fewer than three rows, in
    -- which case the overall average stands in.
    COALESCE(
      (SELECT AVG(h.confidence) FROM rehearsals h
         WHERE h.act_id = a.id
           AND h.happened_at >= (
             SELECT h2.happened_at FROM rehearsals h2
               WHERE h2.act_id = a.id
               ORDER BY h2.happened_at DESC LIMIT 1 OFFSET 2
           )),
      (SELECT AVG(h.confidence) FROM rehearsals h WHERE h.act_id = a.id),
      0
    ) AS recent_confidence
  ''';

  Set<ResultSetImplementation<Object, Object>> get _summarySources =>
      <ResultSetImplementation<Object, Object>>{
        _db.acts,
        _db.actBlocks,
        _db.runOrderItems,
        _db.checklistItems,
        _db.stagePlotItems,
        _db.rehearsals,
        _db.notes,
      };

  /// Acts still being worked on, most recently touched first.
  Stream<List<ActSummary>> watchActive() {
    return _db
        .customSelect(
          '''
          SELECT $_summaryColumns
          FROM acts a
          WHERE a.is_archived = 0
          ORDER BY COALESCE(a.last_opened_at, a.updated_at) DESC, a.id DESC
          ''',
          readsFrom: _summarySources,
        )
        .watch()
        .map((List<QueryRow> rows) => rows.map(_toSummary).toList(growable: false));
  }

  /// The Playbill Archive: acts the user has put away.
  Stream<List<ActSummary>> watchArchived() {
    return _db
        .customSelect(
          '''
          SELECT $_summaryColumns
          FROM acts a
          WHERE a.is_archived = 1
          ORDER BY COALESCE(a.performance_date, a.updated_at) DESC, a.id DESC
          ''',
          readsFrom: _summarySources,
        )
        .watch()
        .map((List<QueryRow> rows) => rows.map(_toSummary).toList(growable: false));
  }

  Stream<ActSummary?> watchOne(int actId) {
    return _db
        .customSelect(
          'SELECT $_summaryColumns FROM acts a WHERE a.id = ?',
          variables: <Variable<Object>>[Variable<int>(actId)],
          readsFrom: _summarySources,
        )
        .watch()
        .map((List<QueryRow> rows) => rows.isEmpty ? null : _toSummary(rows.first));
  }

  Future<ActSummary?> findOne(int actId) async {
    final List<QueryRow> rows = await _db
        .customSelect(
          'SELECT $_summaryColumns FROM acts a WHERE a.id = ?',
          variables: <Variable<Object>>[Variable<int>(actId)],
          readsFrom: _summarySources,
        )
        .get();
    return rows.isEmpty ? null : _toSummary(rows.first);
  }

  ActSummary _toSummary(QueryRow row) {
    final int? lastRehearsedRaw = row.readNullable<int>('last_rehearsed_at');

    return ActSummary(
      act: _db.acts.map(row.data),
      blockCount: row.read<int>('block_count'),
      filledBlockCount: row.read<int>('filled_block_count'),
      beatCount: row.read<int>('beat_count'),
      confirmedBeatCount: row.read<int>('confirmed_beat_count'),
      plannedSeconds: row.read<int>('planned_seconds'),
      checklistTotal: row.read<int>('checklist_total'),
      checklistDone: row.read<int>('checklist_done'),
      plotTotal: row.read<int>('plot_total'),
      plotConfirmed: row.read<int>('plot_confirmed'),
      rehearsalCount: row.read<int>('rehearsal_count'),
      noteCount: row.read<int>('note_count'),
      lastRehearsedAt: lastRehearsedRaw == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastRehearsedRaw * 1000),
      recentConfidence: row.read<double>('recent_confidence'),
    );
  }

  /// Creates an act and, unless asked not to, its starter structure.
  ///
  /// Everything happens in one transaction so a half-built act can never be
  /// left behind if the insert fails part way.
  Future<int> create({
    required String title,
    required int targetSeconds,
    String? subtitle,
    String? venue,
    String? summary,
    DateTime? performanceDate,
    ActEmblem emblem = ActEmblem.tent,
    CueFrameStyle cueFrame = CueFrameStyle.curtain,
    bool applyTemplate = true,
  }) async {
    final DateTime now = DateTime.now();

    return _db.transaction<int>(() async {
      final int actId = await _db.into(_db.acts).insert(
        ActsCompanion.insert(
          title: title.trim(),
          subtitle: Value<String?>(_blankToNull(subtitle)),
          venue: Value<String?>(_blankToNull(venue)),
          summary: Value<String?>(_blankToNull(summary)),
          performanceDate: Value<DateTime?>(performanceDate),
          emblem: Value<ActEmblem>(emblem),
          cueFrame: Value<CueFrameStyle>(cueFrame),
          targetSeconds: Value<int>(targetSeconds),
          createdAt: now,
          updatedAt: now,
          lastOpenedAt: Value<DateTime>(now),
        ),
      );

      if (applyTemplate) {
        await _db.batch((Batch batch) {
          batch.insertAll(
            _db.actBlocks,
            <ActBlocksCompanion>[
              for (int i = 0; i < kBlockTemplate.length; i++)
                ActBlocksCompanion.insert(
                  actId: actId,
                  role: kBlockTemplate[i].role,
                  title: kBlockTemplate[i].title,
                  intent: Value<String?>(kBlockTemplate[i].intent),
                  plannedSeconds: Value<int>(
                    (targetSeconds * kBlockTemplate[i].share).round(),
                  ),
                  position: i,
                  createdAt: now,
                  updatedAt: now,
                ),
            ],
          );
          batch.insertAll(
            _db.checklistItems,
            <ChecklistItemsCompanion>[
              for (int i = 0; i < kChecklistTemplate.length; i++)
                ChecklistItemsCompanion.insert(
                  actId: actId,
                  category: kChecklistTemplate[i].category,
                  label: kChecklistTemplate[i].label,
                  detail: Value<String?>(kChecklistTemplate[i].detail),
                  position: i,
                ),
            ],
          );
          batch.insertAll(
            _db.stagePlotItems,
            <StagePlotItemsCompanion>[
              for (int i = 0; i < kStagePlotTemplate.length; i++)
                StagePlotItemsCompanion.insert(
                  actId: actId,
                  equipment: kStagePlotTemplate[i].equipment,
                  label: kStagePlotTemplate[i].label,
                  spec: Value<String?>(kStagePlotTemplate[i].spec),
                  position: i,
                ),
            ],
          );
        });
      }

      return actId;
    });
  }

  Future<void> updateDetails({
    required int actId,
    String? title,
    String? subtitle,
    String? venue,
    String? summary,
    int? targetSeconds,
    DateTime? performanceDate,
    bool clearPerformanceDate = false,
    ActEmblem? emblem,
    CueFrameStyle? cueFrame,
  }) {
    return (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId))).write(
      ActsCompanion(
        title: title == null ? const Value<String>.absent() : Value<String>(title.trim()),
        subtitle: subtitle == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(subtitle)),
        venue: venue == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(venue)),
        summary: summary == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(summary)),
        targetSeconds:
            targetSeconds == null ? const Value<int>.absent() : Value<int>(targetSeconds),
        performanceDate: clearPerformanceDate
            ? const Value<DateTime?>(null)
            : performanceDate == null
                ? const Value<DateTime?>.absent()
                : Value<DateTime?>(performanceDate),
        emblem: emblem == null ? const Value<ActEmblem>.absent() : Value<ActEmblem>(emblem),
        cueFrame: cueFrame == null
            ? const Value<CueFrameStyle>.absent()
            : Value<CueFrameStyle>(cueFrame),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  Future<void> setStatus(int actId, ActStatus status) {
    return (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId))).write(
      ActsCompanion(
        status: Value<ActStatus>(status),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Moves an act into or out of the Playbill Archive.
  Future<void> setArchived(int actId, {required bool archived}) {
    return (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId))).write(
      ActsCompanion(
        isArchived: Value<bool>(archived),
        status: archived
            ? Value<ActStatus>(ActStatus.completed)
            : const Value<ActStatus>.absent(),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Records that the act was opened, which is what orders the console.
  Future<void> markOpened(int actId) {
    return (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId))).write(
      ActsCompanion(lastOpenedAt: Value<DateTime>(DateTime.now())),
    );
  }

  /// Deletes the act. Blocks, beats, checklist, stage plot, notes and
  /// rehearsals go with it through the foreign keys.
  Future<void> delete(int actId) =>
      (_db.delete(_db.acts)..where((Acts t) => t.id.equals(actId))).go();

  /// Copies an act's structure into a new draft, without its rehearsal history.
  ///
  /// Restaging last year's routine is the common case, and it should not mean
  /// retyping the whole stage plot.
  Future<int> duplicate(int actId, {required String newTitle}) async {
    final DateTime now = DateTime.now();

    return _db.transaction<int>(() async {
      final ActRow? source = await (_db.select(_db.acts)
            ..where((Acts t) => t.id.equals(actId)))
          .getSingleOrNull();
      if (source == null) {
        throw StateError('Act $actId no longer exists');
      }

      final int copyId = await _db.into(_db.acts).insert(
        ActsCompanion.insert(
          title: newTitle.trim(),
          subtitle: Value<String?>(source.subtitle),
          venue: Value<String?>(source.venue),
          summary: Value<String?>(source.summary),
          emblem: Value<ActEmblem>(source.emblem),
          cueFrame: Value<CueFrameStyle>(source.cueFrame),
          targetSeconds: Value<int>(source.targetSeconds),
          createdAt: now,
          updatedAt: now,
          lastOpenedAt: Value<DateTime>(now),
        ),
      );

      final List<ActBlockRow> blocks = await (_db.select(_db.actBlocks)
            ..where((ActBlocks t) => t.actId.equals(actId))
            ..orderBy(<OrderClauseGenerator<ActBlocks>>[
              (ActBlocks t) => OrderingTerm.asc(t.position),
            ]))
          .get();

      for (final ActBlockRow block in blocks) {
        final int newBlockId = await _db.into(_db.actBlocks).insert(
          ActBlocksCompanion.insert(
            actId: copyId,
            role: block.role,
            title: block.title,
            intent: Value<String?>(block.intent),
            plannedSeconds: Value<int>(block.plannedSeconds),
            position: block.position,
            createdAt: now,
            updatedAt: now,
          ),
        );

        final List<RunOrderItemRow> beats = await (_db.select(_db.runOrderItems)
              ..where((RunOrderItems t) => t.blockId.equals(block.id))
              ..orderBy(<OrderClauseGenerator<RunOrderItems>>[
                (RunOrderItems t) => OrderingTerm.asc(t.position),
              ]))
            .get();

        if (beats.isEmpty) continue;

        await _db.batch((Batch batch) {
          batch.insertAll(
            _db.runOrderItems,
            beats.map(
              (RunOrderItemRow beat) => RunOrderItemsCompanion.insert(
                blockId: newBlockId,
                trickId: Value<int?>(beat.trickId),
                label: beat.label,
                cueNote: Value<String?>(beat.cueNote),
                seconds: Value<int>(beat.seconds),
                position: beat.position,
                // Choreography has to be re-confirmed for the new staging.
                isConfirmed: const Value<bool>(false),
              ),
            ),
          );
        });
      }

      final List<ChecklistItemRow> checks = await (_db.select(_db.checklistItems)
            ..where((ChecklistItems t) => t.actId.equals(actId))
            ..orderBy(<OrderClauseGenerator<ChecklistItems>>[
              (ChecklistItems t) => OrderingTerm.asc(t.position),
            ]))
          .get();

      final List<StagePlotItemRow> plot = await (_db.select(_db.stagePlotItems)
            ..where((StagePlotItems t) => t.actId.equals(actId))
            ..orderBy(<OrderClauseGenerator<StagePlotItems>>[
              (StagePlotItems t) => OrderingTerm.asc(t.position),
            ]))
          .get();

      await _db.batch((Batch batch) {
        batch.insertAll(
          _db.checklistItems,
          checks.map(
            (ChecklistItemRow c) => ChecklistItemsCompanion.insert(
              actId: copyId,
              category: c.category,
              label: c.label,
              detail: Value<String?>(c.detail),
              position: c.position,
            ),
          ),
        );
        batch.insertAll(
          _db.stagePlotItems,
          plot.map(
            (StagePlotItemRow s) => StagePlotItemsCompanion.insert(
              actId: copyId,
              equipment: s.equipment,
              label: s.label,
              spec: Value<String?>(s.spec),
              position: s.position,
            ),
          ),
        );
      });

      return copyId;
    });
  }

  static String? _blankToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

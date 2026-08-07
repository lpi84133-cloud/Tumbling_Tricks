import 'package:drift/drift.dart';

import '../app_database.dart';

/// A week of rehearsal activity, used by the Progress screen.
class RehearsalWeek {
  const RehearsalWeek({
    required this.weekStart,
    required this.sessions,
    required this.minutes,
    required this.averageConfidence,
  });

  /// Monday of the week, at midnight local time.
  final DateTime weekStart;
  final int sessions;
  final int minutes;
  final double averageConfidence;
}

/// Reads and writes the rehearsal log.
class RehearsalRepository {
  RehearsalRepository(this._db);

  final AppDatabase _db;

  Stream<List<RehearsalRow>> watchForAct(int actId, {int? limit}) {
    final SimpleSelectStatement<Rehearsals, RehearsalRow> select =
        _db.select(_db.rehearsals)
          ..where((Rehearsals t) => t.actId.equals(actId))
          ..orderBy(<OrderClauseGenerator<Rehearsals>>[
            (Rehearsals t) => OrderingTerm.desc(t.happenedAt),
            (Rehearsals t) => OrderingTerm.desc(t.id),
          ]);
    if (limit != null) select.limit(limit);
    return select.watch();
  }

  /// Every session across all acts, newest first. Drives the Progress timeline.
  Stream<List<RehearsalRow>> watchRecent({int limit = 60}) {
    return (_db.select(_db.rehearsals)
          ..orderBy(<OrderClauseGenerator<Rehearsals>>[
            (Rehearsals t) => OrderingTerm.desc(t.happenedAt),
            (Rehearsals t) => OrderingTerm.desc(t.id),
          ])
          ..limit(limit))
        .watch();
  }

  /// Logs a session.
  ///
  /// Alongside the log entry this credits every catalogued trick that is in the
  /// act's run order, which is what keeps the library's rehearsal counts honest
  /// without asking the user to tick tricks off twice.
  Future<int> log({
    required int actId,
    required DateTime happenedAt,
    required int minutes,
    required int confidence,
    String focus = '',
    String? notes,
  }) async {
    final DateTime now = DateTime.now();

    return _db.transaction<int>(() async {
      final int id = await _db.into(_db.rehearsals).insert(
        RehearsalsCompanion.insert(
          actId: actId,
          happenedAt: happenedAt,
          minutes: Value<int>(minutes.clamp(1, 24 * 60)),
          confidence: Value<int>(confidence.clamp(1, 5)),
          focus: Value<String>(focus.trim()),
          notes: Value<String?>(_blankToNull(notes)),
          createdAt: now,
        ),
      );

      await _creditTricksInAct(actId, happenedAt: happenedAt, now: now);

      await (_db.update(_db.acts)..where((Acts t) => t.id.equals(actId)))
          .write(ActsCompanion(updatedAt: Value<DateTime>(now)));

      return id;
    });
  }

  Future<void> update({
    required int rehearsalId,
    DateTime? happenedAt,
    int? minutes,
    int? confidence,
    String? focus,
    String? notes,
  }) {
    return (_db.update(_db.rehearsals)
          ..where((Rehearsals t) => t.id.equals(rehearsalId)))
        .write(
      RehearsalsCompanion(
        happenedAt: happenedAt == null
            ? const Value<DateTime>.absent()
            : Value<DateTime>(happenedAt),
        minutes:
            minutes == null ? const Value<int>.absent() : Value<int>(minutes.clamp(1, 24 * 60)),
        confidence: confidence == null
            ? const Value<int>.absent()
            : Value<int>(confidence.clamp(1, 5)),
        focus: focus == null ? const Value<String>.absent() : Value<String>(focus.trim()),
        notes: notes == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(notes)),
      ),
    );
  }

  Future<void> delete(int rehearsalId) =>
      (_db.delete(_db.rehearsals)..where((Rehearsals t) => t.id.equals(rehearsalId)))
          .go();

  /// Total minutes rehearsed since [since], across every act.
  Stream<int> watchMinutesSince(DateTime since) {
    final Expression<int> total = _db.rehearsals.minutes.sum();
    return (_db.selectOnly(_db.rehearsals)
          ..addColumns(<Expression<Object>>[total])
          ..where(_db.rehearsals.happenedAt.isBiggerOrEqualValue(since)))
        .watchSingle()
        .map((TypedResult row) => row.read<int>(total) ?? 0);
  }

  /// Weekly totals for the last [weeks] weeks, oldest first, with empty weeks
  /// included so a chart has no gaps.
  Stream<List<RehearsalWeek>> watchWeekly({int weeks = 8}) {
    final DateTime start = _startOfWeek(DateTime.now())
        .subtract(Duration(days: 7 * (weeks - 1)));

    return (_db.select(_db.rehearsals)
          ..where((Rehearsals t) => t.happenedAt.isBiggerOrEqualValue(start))
          ..orderBy(<OrderClauseGenerator<Rehearsals>>[
            (Rehearsals t) => OrderingTerm.asc(t.happenedAt),
          ]))
        .watch()
        .map((List<RehearsalRow> rows) {
          final Map<DateTime, List<RehearsalRow>> buckets =
              <DateTime, List<RehearsalRow>>{};
          for (final RehearsalRow row in rows) {
            buckets.putIfAbsent(_startOfWeek(row.happenedAt), () => <RehearsalRow>[])
                .add(row);
          }

          return <RehearsalWeek>[
            for (int i = 0; i < weeks; i++)
              () {
                final DateTime weekStart = start.add(Duration(days: 7 * i));
                final List<RehearsalRow> inWeek =
                    buckets[weekStart] ?? const <RehearsalRow>[];
                final int minutes = inWeek.fold<int>(
                  0,
                  (int sum, RehearsalRow r) => sum + r.minutes,
                );
                final double confidence = inWeek.isEmpty
                    ? 0
                    : inWeek.fold<int>(
                          0,
                          (int sum, RehearsalRow r) => sum + r.confidence,
                        ) /
                        inWeek.length;
                return RehearsalWeek(
                  weekStart: weekStart,
                  sessions: inWeek.length,
                  minutes: minutes,
                  averageConfidence: confidence,
                );
              }(),
          ];
        });
  }

  /// Consecutive weeks, counting back from this one, that contain at least one
  /// session. A weekly streak rather than a daily one: nobody rehearses daily,
  /// and a daily streak would only punish people for resting.
  Stream<int> watchWeeklyStreak() {
    return watchWeekly(weeks: 26).map((List<RehearsalWeek> weeks) {
      int streak = 0;
      for (final RehearsalWeek week in weeks.reversed) {
        if (week.sessions == 0) break;
        streak++;
      }
      return streak;
    });
  }

  Future<void> _creditTricksInAct(
    int actId, {
    required DateTime happenedAt,
    required DateTime now,
  }) {
    return _db.customUpdate(
      '''
      UPDATE tricks
         SET times_rehearsed = times_rehearsed + 1,
             last_rehearsed_at = MAX(COALESCE(last_rehearsed_at, 0), ?),
             updated_at = ?
       WHERE id IN (
         SELECT r.trick_id FROM run_order_items r
           JOIN act_blocks b ON b.id = r.block_id
          WHERE b.act_id = ? AND r.trick_id IS NOT NULL
       )
      ''',
      variables: <Variable<Object>>[
        Variable<DateTime>(happenedAt),
        Variable<DateTime>(now),
        Variable<int>(actId),
      ],
      updates: <TableInfo<Table, Object>>{_db.tricks},
      updateKind: UpdateKind.update,
    );
  }

  static DateTime _startOfWeek(DateTime date) {
    final DateTime midnight = DateTime(date.year, date.month, date.day);
    return midnight.subtract(Duration(days: midnight.weekday - DateTime.monday));
  }

  static String? _blankToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

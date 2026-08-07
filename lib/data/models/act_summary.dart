import '../app_database.dart';
import '../enums.dart';
import 'readiness.dart';

/// An act together with everything the list and console screens need to draw it,
/// gathered in one reactive query so a card never has to fire follow-up reads.
class ActSummary {
  const ActSummary({
    required this.act,
    required this.blockCount,
    required this.filledBlockCount,
    required this.beatCount,
    required this.confirmedBeatCount,
    required this.plannedSeconds,
    required this.checklistTotal,
    required this.checklistDone,
    required this.plotTotal,
    required this.plotConfirmed,
    required this.rehearsalCount,
    required this.noteCount,
    required this.lastRehearsedAt,
    required this.recentConfidence,
  });

  final ActRow act;

  /// Blocks in the run order, and how many contain at least one beat.
  final int blockCount;
  final int filledBlockCount;

  /// Beats in the run order, and how many are timed and choreographed.
  final int beatCount;
  final int confirmedBeatCount;

  /// Sum of every beat's duration, in seconds.
  final int plannedSeconds;

  final int checklistTotal;
  final int checklistDone;

  final int plotTotal;
  final int plotConfirmed;

  final int rehearsalCount;
  final int noteCount;

  final DateTime? lastRehearsedAt;

  /// Mean confidence of the three most recent rehearsals, 0 when never rehearsed.
  final double recentConfidence;

  int get id => act.id;
  String get title => act.title;
  ActStatus get status => act.status;
  int get targetSeconds => act.targetSeconds;

  /// Difference between planned and target running time. Positive runs long.
  int get timingDriftSeconds => plannedSeconds - targetSeconds;

  bool get isEmpty => blockCount == 0 && checklistTotal == 0 && plotTotal == 0;

  Readiness get readiness => Readiness.from(
    blockCount: blockCount,
    filledBlockCount: filledBlockCount,
    beatCount: beatCount,
    confirmedBeatCount: confirmedBeatCount,
    plannedSeconds: plannedSeconds,
    targetSeconds: targetSeconds,
    checklistTotal: checklistTotal,
    checklistDone: checklistDone,
    plotTotal: plotTotal,
    plotConfirmed: plotConfirmed,
    rehearsalCount: rehearsalCount,
    recentConfidence: recentConfidence,
  );

  /// Days since the last logged rehearsal, `null` when there is none.
  int? daysSinceRehearsal({DateTime? now}) {
    final DateTime? last = lastRehearsedAt;
    if (last == null) return null;
    return (now ?? DateTime.now()).difference(last).inDays;
  }
}

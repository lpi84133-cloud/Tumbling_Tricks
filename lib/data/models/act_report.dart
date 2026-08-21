import '../app_database.dart';
import '../enums.dart';
import 'run_order.dart';

/// Weight of an issue found by the structural linter.
///
/// The three levels map directly onto how loud the run-order screen makes the
/// finding: a quiet dot, an amber warning, or a red flag the user will have to
/// resolve before the act reads well on stage.
enum IssueSeverity {
  info,
  warning,
  critical;

  bool operator >(IssueSeverity other) => index > other.index;
  bool operator >=(IssueSeverity other) => index >= other.index;
}

/// One structural finding: what is wrong and the single change that would fix
/// it. Deliberately shaped like a [ReadinessSignal] — one problem, one advice —
/// because a linter that just enumerates rules is worse than useless.
class ActIssue {
  const ActIssue({
    required this.severity,
    required this.title,
    required this.detail,
    required this.advice,
  });

  final IssueSeverity severity;

  /// Short label, e.g. "Two transitions in a row".
  final String title;

  /// Where the number came from, e.g. "Positions 3 and 4 are both transitions".
  final String detail;

  /// The one change that resolves the issue.
  final String advice;
}

/// A point on the act's energy curve: how much load the audience is under at
/// a given moment.
class EnergyPoint {
  const EnergyPoint({
    required this.startSeconds,
    required this.endSeconds,
    required this.difficulty,
    required this.role,
    required this.beatLabel,
  });

  /// Where this beat sits in the running act, in seconds from the top.
  final int startSeconds;
  final int endSeconds;

  /// 0 to 5. `0` for unknown (a free-form beat with no linked trick).
  final double difficulty;

  final BlockRole role;
  final String beatLabel;
}

/// Structural analysis of an act's run order.
///
/// The report is derived, not stored: every rebuild of the run order recomputes
/// it, so an issue can only be resolved by fixing the underlying data. There
/// is no dismiss button, on purpose.
class ActReport {
  const ActReport({
    required this.issues,
    required this.curve,
    required this.plannedSeconds,
    required this.targetSeconds,
  });

  static const ActReport empty = ActReport(
    issues: <ActIssue>[],
    curve: <EnergyPoint>[],
    plannedSeconds: 0,
    targetSeconds: 0,
  );

  final List<ActIssue> issues;

  /// One entry per beat, in performance order.
  final List<EnergyPoint> curve;

  final int plannedSeconds;
  final int targetSeconds;

  bool get isClean => issues.isEmpty;

  int countOf(IssueSeverity level) =>
      issues.where((ActIssue i) => i.severity == level).length;

  /// Loudest issue: the run-order header colours the indicator by this.
  IssueSeverity get overallSeverity {
    IssueSeverity worst = IssueSeverity.info;
    for (final ActIssue i in issues) {
      if (i.severity > worst) worst = i.severity;
    }
    return worst;
  }

  // ---------------------------------------------------------------- algorithm

  /// Builds the report from raw inputs. Pure function, easy to test.
  ///
  /// [tricks] maps a `trickId` to its row for every beat that came out of the
  /// library. Beats without a linked trick contribute to the curve at a
  /// neutral height and never fail difficulty-based rules — no phantom
  /// findings from missing data.
  factory ActReport.from({
    required RunOrder runOrder,
    required ActRow act,
    required Map<int, TrickRow> tricks,
  }) {
    // ------------------------------------------------- energy curve
    final List<EnergyPoint> curve = <EnergyPoint>[];
    int running = 0;
    for (final RunOrderBlock block in runOrder.blocks) {
      for (final RunOrderItemRow beat in block.beats) {
        final TrickRow? trick =
            beat.trickId == null ? null : tricks[beat.trickId!];
        final double difficulty = trick == null ? 0 : trick.difficulty.toDouble();
        curve.add(EnergyPoint(
          startSeconds: running,
          endSeconds: running + beat.seconds,
          difficulty: difficulty,
          role: block.role,
          beatLabel: beat.label,
        ));
        running += beat.seconds;
      }
    }

    // ------------------------------------------------- issues
    final List<ActIssue> issues = <ActIssue>[];

    // Not enough data to lint. An empty act is already handled by the empty
    // state of the run-order screen; running the rules on it just produces
    // noise.
    if (runOrder.isEmpty) {
      return ActReport(
        issues: const <ActIssue>[],
        curve: curve,
        plannedSeconds: 0,
        targetSeconds: act.targetSeconds,
      );
    }

    _checkTiming(issues, runOrder, act);
    _checkTransitions(issues, runOrder);
    _checkOpening(issues, runOrder, tricks);
    _checkHighlight(issues, runOrder, tricks);
    _checkFinale(issues, runOrder, act);
    _checkUnconfirmedPeaks(issues, runOrder);
    _checkSafety(issues, runOrder, tricks);

    return ActReport(
      issues: issues,
      curve: curve,
      plannedSeconds: runOrder.totalSeconds,
      targetSeconds: act.targetSeconds,
    );
  }

  // ---------------------------------------------------------------- rules

  static void _checkTiming(
    List<ActIssue> issues,
    RunOrder order,
    ActRow act,
  ) {
    final int target = act.targetSeconds;
    final int total = order.totalSeconds;
    if (target <= 0 || total <= 0) return;

    final int drift = total - target;
    final double share = drift.abs() / target;
    if (share <= 0.15) return;

    final IssueSeverity level =
        share > 0.30 ? IssueSeverity.critical : IssueSeverity.warning;
    issues.add(ActIssue(
      severity: level,
      title: drift > 0 ? 'Runs long' : 'Runs short',
      detail:
          '${_mmss(total)} planned against ${_mmss(target)} target — '
          '${(share * 100).round()}% off.',
      advice: drift > 0
          ? 'Cut a beat or tighten the two longest ones.'
          : 'Extend a highlight or add material to the main block.',
    ));
  }

  static void _checkTransitions(List<ActIssue> issues, RunOrder order) {
    for (int i = 1; i < order.blocks.length; i++) {
      final RunOrderBlock prev = order.blocks[i - 1];
      final RunOrderBlock curr = order.blocks[i];
      if (prev.role == BlockRole.transition &&
          curr.role == BlockRole.transition) {
        issues.add(ActIssue(
          severity: IssueSeverity.warning,
          title: 'Two transitions in a row',
          detail:
              '"${prev.title}" and "${curr.title}" are both transitions — '
              'the audience is asked to wait twice.',
          advice: 'Merge them, or move a main beat between the two.',
        ));
        // Only surface once per act: further chains are the same finding.
        return;
      }
    }
  }

  static void _checkOpening(
    List<ActIssue> issues,
    RunOrder order,
    Map<int, TrickRow> tricks,
  ) {
    final RunOrderBlock? opening =
        order.blocks.where((RunOrderBlock b) => b.role == BlockRole.opening).firstOrNull;
    if (opening == null || opening.beats.isEmpty) return;

    final RunOrderItemRow first = opening.beats.first;
    final TrickRow? trick = first.trickId == null ? null : tricks[first.trickId!];
    if (trick == null) return;

    if (trick.difficulty >= 4) {
      issues.add(ActIssue(
        severity: IssueSeverity.warning,
        title: 'Opener is heavy',
        detail:
            '"${trick.name}" is difficulty ${trick.difficulty}/5 and it lands '
            'before the audience is warmed up.',
        advice: 'Move it later — an opener of 2–3 reads more confident.',
      ));
    }

    if (trick.mastery == Mastery.learning) {
      issues.add(ActIssue(
        severity: IssueSeverity.critical,
        title: 'Opening on a trick you are still learning',
        detail: '"${trick.name}" is rated Learning.',
        advice: 'Only open with material rated Reliable or Show ready.',
      ));
    }
  }

  static void _checkHighlight(
    List<ActIssue> issues,
    RunOrder order,
    Map<int, TrickRow> tricks,
  ) {
    final RunOrderBlock? highlight =
        order.blocks.where((RunOrderBlock b) => b.role == BlockRole.highlight).firstOrNull;
    if (highlight == null) return;

    if (highlight.beats.isEmpty) {
      issues.add(ActIssue(
        severity: IssueSeverity.warning,
        title: 'Highlight is empty',
        detail: '"${highlight.title}" has no beats.',
        advice: 'Put your strongest trick in the highlight, or drop the block.',
      ));
      return;
    }

    // The highlight ought to hold the highest average difficulty of any block
    // that contains catalogued material. If any non-highlight block outranks
    // it, the shape of the act is inverted.
    final double highlightAvg = _avgDifficulty(highlight, tricks);
    if (highlightAvg <= 0) return;

    for (final RunOrderBlock other in order.blocks) {
      if (other.id == highlight.id) continue;
      if (other.role == BlockRole.transition) continue;
      final double avg = _avgDifficulty(other, tricks);
      if (avg > highlightAvg + 0.5) {
        issues.add(ActIssue(
          severity: IssueSeverity.warning,
          title: 'Highlight is not the peak',
          detail:
              '"${other.title}" (${other.role.label}, avg ${avg.toStringAsFixed(1)}) '
              'is harder than the highlight (avg ${highlightAvg.toStringAsFixed(1)}).',
          advice:
              'Swap the strongest trick into the highlight, or reassign the block roles.',
        ));
        return;
      }
    }
  }

  static void _checkFinale(
    List<ActIssue> issues,
    RunOrder order,
    ActRow act,
  ) {
    final RunOrderBlock? finale =
        order.blocks.where((RunOrderBlock b) => b.role == BlockRole.finale).firstOrNull;
    if (finale == null) {
      issues.add(const ActIssue(
        severity: IssueSeverity.info,
        title: 'No finale block',
        detail: 'The act has nothing marked as its ending.',
        advice: 'Add a finale, even one beat long — it changes how the act reads.',
      ));
      return;
    }

    if (finale.beats.isEmpty) return;

    if (act.targetSeconds > 0) {
      final double share = finale.actualSeconds / act.targetSeconds;
      if (share < 0.10) {
        issues.add(ActIssue(
          severity: IssueSeverity.warning,
          title: 'Finale is abrupt',
          detail:
              '"${finale.title}" is ${_mmss(finale.actualSeconds)} out of a '
              '${_mmss(act.targetSeconds)} act (${(share * 100).round()}%).',
          advice: 'Give the ending at least 15% of the act to land.',
        ));
      }
    }
  }

  static void _checkUnconfirmedPeaks(List<ActIssue> issues, RunOrder order) {
    for (final RunOrderBlock block in order.blocks) {
      if (block.role != BlockRole.highlight && block.role != BlockRole.finale) {
        continue;
      }
      if (block.beats.isEmpty) continue;
      final int unconfirmed = block.beats.length - block.confirmedCount;
      if (unconfirmed == 0) continue;

      issues.add(ActIssue(
        severity: IssueSeverity.critical,
        title: '${block.role.label} not choreographed',
        detail:
            '$unconfirmed of ${block.beats.length} beats in "${block.title}" '
            'are still unconfirmed.',
        advice:
            'Confirm every beat in the ${block.role.label.toLowerCase()} — this is what the audience remembers.',
      ));
    }
  }

  static void _checkSafety(
    List<ActIssue> issues,
    RunOrder order,
    Map<int, TrickRow> tricks,
  ) {
    final List<String> flagged = <String>[];
    for (final RunOrderBlock block in order.blocks) {
      for (final RunOrderItemRow beat in block.beats) {
        final TrickRow? trick = beat.trickId == null ? null : tricks[beat.trickId!];
        if (trick == null) continue;
        if (trick.safetyNote == null) continue;
        if (beat.isConfirmed) continue;
        flagged.add(trick.name);
      }
    }
    if (flagged.isEmpty) return;

    final String preview = flagged.take(2).join(', ');
    final String tail = flagged.length > 2 ? ' and ${flagged.length - 2} more' : '';
    issues.add(ActIssue(
      severity: IssueSeverity.critical,
      title: 'Safety-noted trick not confirmed',
      detail: '$preview$tail carry a safety note and are unconfirmed in this act.',
      advice: 'Walk each one with the spotter before marking the beat set.',
    ));
  }

  // ---------------------------------------------------------------- helpers

  static double _avgDifficulty(RunOrderBlock block, Map<int, TrickRow> tricks) {
    int sum = 0;
    int count = 0;
    for (final RunOrderItemRow beat in block.beats) {
      final TrickRow? trick = beat.trickId == null ? null : tricks[beat.trickId!];
      if (trick == null) continue;
      sum += trick.difficulty;
      count++;
    }
    return count == 0 ? 0 : sum / count;
  }

  static String _mmss(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

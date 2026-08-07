import 'dart:math' as math;

/// One measurable contribution to an act's readiness.
class ReadinessSignal {
  const ReadinessSignal({
    required this.kind,
    required this.value,
    required this.weight,
    required this.detail,
    required this.advice,
  });

  final ReadinessKind kind;

  /// 0 to 1.
  final double value;

  /// Share of the overall score this signal accounts for.
  final double weight;

  /// Where the number comes from, e.g. "8 of 11 checks done".
  final String detail;

  /// The single next action that would move this signal. Empty when the signal
  /// is already complete.
  final String advice;

  bool get isComplete => value >= 0.999;

  int get percent => (value * 100).round();
}

/// The aspects of preparation the app tracks.
enum ReadinessKind {
  structure('Structure'),
  timing('Timing'),
  choreography('Choreography'),
  checklist('Checklist'),
  stagePlot('Stage plot'),
  rehearsal('Rehearsal');

  const ReadinessKind(this.label);

  final String label;
}

/// How ready an act is to be performed.
///
/// This is the app's central number, so it is built only from things the user
/// has actually recorded: blocks that contain beats, timing against the target,
/// beats marked as choreographed, checklist and stage plot progress, and logged
/// rehearsals. Nothing here rewards merely opening the app.
class Readiness {
  const Readiness(this.signals);

  final List<ReadinessSignal> signals;

  /// Weighted total, 0 to 1.
  double get value {
    double total = 0;
    double weight = 0;
    for (final ReadinessSignal s in signals) {
      total += s.value.clamp(0.0, 1.0) * s.weight;
      weight += s.weight;
    }
    return weight == 0 ? 0 : total / weight;
  }

  int get percent => (value * 100).round();

  /// The signal that would gain the most from attention: the largest amount of
  /// score currently being left on the table.
  ReadinessSignal? get weakest {
    ReadinessSignal? worst;
    double worstLoss = 0;
    for (final ReadinessSignal s in signals) {
      if (s.isComplete) continue;
      final double loss = (1 - s.value) * s.weight;
      if (loss > worstLoss) {
        worstLoss = loss;
        worst = s;
      }
    }
    return worst;
  }

  ReadinessSignal signal(ReadinessKind kind) =>
      signals.firstWhere((ReadinessSignal s) => s.kind == kind);

  /// Builds the score from raw counts.
  ///
  /// Weights are fixed rather than configurable: a comparable number across all
  /// acts is more useful than one the user can inflate.
  factory Readiness.from({
    required int blockCount,
    required int filledBlockCount,
    required int beatCount,
    required int confirmedBeatCount,
    required int plannedSeconds,
    required int targetSeconds,
    required int checklistTotal,
    required int checklistDone,
    required int plotTotal,
    required int plotConfirmed,
    required int rehearsalCount,
    required double recentConfidence,
  }) {
    final int emptyBlocks = blockCount - filledBlockCount;
    final int unconfirmedBeats = beatCount - confirmedBeatCount;
    final int checksLeft = checklistTotal - checklistDone;
    final int plotLeft = plotTotal - plotConfirmed;

    return Readiness(<ReadinessSignal>[
      ReadinessSignal(
        kind: ReadinessKind.structure,
        weight: 0.15,
        value: blockCount == 0 ? 0 : filledBlockCount / blockCount,
        detail: blockCount == 0
            ? 'No blocks yet'
            : '$filledBlockCount of $blockCount blocks filled',
        advice: blockCount == 0
            ? 'Add the first block to the run order'
            : emptyBlocks > 0
                ? 'Put at least one beat in the remaining '
                    '$emptyBlocks ${emptyBlocks == 1 ? 'block' : 'blocks'}'
                : '',
      ),
      ReadinessSignal(
        kind: ReadinessKind.timing,
        weight: 0.10,
        value: _timingScore(plannedSeconds, targetSeconds),
        detail: plannedSeconds == 0
            ? 'Nothing timed yet'
            : '${_mmss(plannedSeconds)} planned against ${_mmss(targetSeconds)}',
        advice: _timingAdvice(plannedSeconds, targetSeconds),
      ),
      ReadinessSignal(
        kind: ReadinessKind.choreography,
        weight: 0.20,
        value: beatCount == 0 ? 0 : confirmedBeatCount / beatCount,
        detail: beatCount == 0
            ? 'No beats yet'
            : '$confirmedBeatCount of $beatCount beats choreographed',
        advice: beatCount == 0
            ? 'Add tricks to the run order'
            : unconfirmedBeats > 0
                ? 'Time and confirm $unconfirmedBeats more '
                    '${unconfirmedBeats == 1 ? 'beat' : 'beats'}'
                : '',
      ),
      ReadinessSignal(
        kind: ReadinessKind.checklist,
        weight: 0.25,
        value: checklistTotal == 0 ? 0 : checklistDone / checklistTotal,
        detail: checklistTotal == 0
            ? 'Checklist empty'
            : '$checklistDone of $checklistTotal checks done',
        advice: checklistTotal == 0
            ? 'Add the checks this act needs'
            : checksLeft > 0
                ? 'Clear $checksLeft remaining '
                    '${checksLeft == 1 ? 'check' : 'checks'}'
                : '',
      ),
      ReadinessSignal(
        kind: ReadinessKind.stagePlot,
        weight: 0.15,
        value: plotTotal == 0 ? 0 : plotConfirmed / plotTotal,
        detail: plotTotal == 0
            ? 'Stage plot empty'
            : '$plotConfirmed of $plotTotal lines confirmed',
        advice: plotTotal == 0
            ? 'List the lighting, sound and props this act needs'
            : plotLeft > 0
                ? 'Confirm $plotLeft more '
                    '${plotLeft == 1 ? 'line' : 'lines'} with the venue'
                : '',
      ),
      ReadinessSignal(
        kind: ReadinessKind.rehearsal,
        weight: 0.15,
        value: _rehearsalScore(rehearsalCount, recentConfidence),
        detail: rehearsalCount == 0
            ? 'Never rehearsed'
            : '$rehearsalCount ${rehearsalCount == 1 ? 'session' : 'sessions'} logged'
                '${recentConfidence > 0 ? ', ${recentConfidence.toStringAsFixed(1)}/5 lately' : ''}',
        advice: _rehearsalAdvice(rehearsalCount, recentConfidence),
      ),
    ]);
  }

  /// Full marks within 10% of the target, tapering to zero at double or nothing.
  static double _timingScore(int planned, int target) {
    if (planned <= 0 || target <= 0) return 0;
    final double drift = (planned - target).abs() / target;
    if (drift <= 0.1) return 1;
    return math.max(0, 1 - (drift - 0.1) / 0.9);
  }

  static String _timingAdvice(int planned, int target) {
    if (target <= 0) return 'Set a target running time for this act';
    if (planned <= 0) return 'Give the beats a duration so the act can be timed';
    final int diff = planned - target;
    if (diff.abs() <= target * 0.1) return '';
    return diff > 0
        ? 'Running ${_mmss(diff)} long — cut or tighten beats'
        : 'Running ${_mmss(-diff)} short — add material or hold longer';
  }

  /// Half the score comes from having rehearsed at all, half from how the runs
  /// have been feeling. Four sessions is treated as a full run-in.
  static double _rehearsalScore(int count, double confidence) {
    if (count == 0) return 0;
    final double volume = math.min(1, count / 4);
    final double feel = confidence <= 0 ? 0 : ((confidence - 1) / 4).clamp(0.0, 1.0);
    return volume * 0.5 + feel * 0.5;
  }

  static String _rehearsalAdvice(int count, double confidence) {
    if (count == 0) return 'Log the first rehearsal';
    if (count < 4) {
      final int left = 4 - count;
      return 'Log $left more ${left == 1 ? 'session' : 'sessions'} to run it in';
    }
    if (confidence < 4) return 'Runs are scoring below 4 — work the weak beat';
    return '';
  }

  static String _mmss(int seconds) {
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

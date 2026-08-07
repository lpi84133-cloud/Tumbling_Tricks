import 'package:flutter_test/flutter_test.dart';
import 'package:tumbling_tricks/data/models/readiness.dart';

/// A fully prepared act, used as the baseline the other cases deviate from.
Readiness _complete() => Readiness.from(
  blockCount: 5,
  filledBlockCount: 5,
  beatCount: 10,
  confirmedBeatCount: 10,
  plannedSeconds: 240,
  targetSeconds: 240,
  checklistTotal: 11,
  checklistDone: 11,
  plotTotal: 5,
  plotConfirmed: 5,
  rehearsalCount: 4,
  recentConfidence: 5,
);

void main() {
  group('Readiness', () {
    test('a brand new act with nothing recorded scores zero', () {
      final Readiness readiness = Readiness.from(
        blockCount: 0,
        filledBlockCount: 0,
        beatCount: 0,
        confirmedBeatCount: 0,
        plannedSeconds: 0,
        targetSeconds: 240,
        checklistTotal: 0,
        checklistDone: 0,
        plotTotal: 0,
        plotConfirmed: 0,
        rehearsalCount: 0,
        recentConfidence: 0,
      );

      expect(readiness.percent, 0);
      expect(readiness.signals, hasLength(ReadinessKind.values.length));
      // Every signal must tell the user what to do next.
      for (final ReadinessSignal signal in readiness.signals) {
        expect(signal.advice, isNotEmpty, reason: signal.kind.label);
      }
    });

    test('a fully prepared act scores 100 and offers no advice', () {
      final Readiness readiness = _complete();

      expect(readiness.percent, 100);
      expect(readiness.weakest, isNull);
      for (final ReadinessSignal signal in readiness.signals) {
        expect(signal.isComplete, isTrue, reason: signal.kind.label);
        expect(signal.advice, isEmpty, reason: signal.kind.label);
      }
    });

    test('weights sum to one, so each signal contributes as documented', () {
      final double total = _complete().signals.fold<double>(
        0,
        (double sum, ReadinessSignal s) => sum + s.weight,
      );
      expect(total, closeTo(1.0, 1e-9));
    });

    test('a template act with nothing done still scores zero', () {
      // This is what `ActRepository.create` produces: structure and lists exist,
      // but nothing has been filled in or ticked.
      final Readiness readiness = Readiness.from(
        blockCount: 5,
        filledBlockCount: 0,
        beatCount: 0,
        confirmedBeatCount: 0,
        plannedSeconds: 0,
        targetSeconds: 240,
        checklistTotal: 11,
        checklistDone: 0,
        plotTotal: 5,
        plotConfirmed: 0,
        rehearsalCount: 0,
        recentConfidence: 0,
      );

      expect(readiness.percent, 0);
    });

    group('timing', () {
      double score(int planned, int target) => Readiness.from(
        blockCount: 1,
        filledBlockCount: 1,
        beatCount: 1,
        confirmedBeatCount: 1,
        plannedSeconds: planned,
        targetSeconds: target,
        checklistTotal: 1,
        checklistDone: 1,
        plotTotal: 1,
        plotConfirmed: 1,
        rehearsalCount: 4,
        recentConfidence: 5,
      ).signal(ReadinessKind.timing).value;

      test('is full within ten per cent of the target either way', () {
        expect(score(240, 240), 1.0);
        expect(score(250, 240), 1.0);
        expect(score(220, 240), 1.0);
      });

      test('falls off as the act drifts from the target', () {
        expect(score(300, 240), lessThan(1.0));
        expect(score(300, 240), greaterThan(score(400, 240)));
        expect(score(480, 240), 0.0);
      });

      test('advice says which way the act is running', () {
        final ReadinessSignal long = Readiness.from(
          blockCount: 1,
          filledBlockCount: 1,
          beatCount: 1,
          confirmedBeatCount: 1,
          plannedSeconds: 330,
          targetSeconds: 240,
          checklistTotal: 1,
          checklistDone: 1,
          plotTotal: 1,
          plotConfirmed: 1,
          rehearsalCount: 4,
          recentConfidence: 5,
        ).signal(ReadinessKind.timing);

        expect(long.advice, contains('long'));
        expect(long.detail, contains('5:30'));
      });
    });

    test('rehearsal needs both sessions and confidence', () {
      double score(int count, double confidence) => Readiness.from(
        blockCount: 1,
        filledBlockCount: 1,
        beatCount: 1,
        confirmedBeatCount: 1,
        plannedSeconds: 240,
        targetSeconds: 240,
        checklistTotal: 1,
        checklistDone: 1,
        plotTotal: 1,
        plotConfirmed: 1,
        rehearsalCount: count,
        recentConfidence: confidence,
      ).signal(ReadinessKind.rehearsal).value;

      expect(score(0, 0), 0.0);
      // Plenty of sessions that keep going badly must not read as ready.
      expect(score(8, 1), lessThan(0.6));
      // Nor should one great session.
      expect(score(1, 5), lessThan(0.8));
      expect(score(4, 5), 1.0);
    });

    test('weakest points at the biggest available gain, not the lowest score',
        () {
      // Choreography is at 0.5 with weight 0.20 (0.10 to gain); the stage plot
      // is lower at 0.0 but weighs 0.15, so the plot is the better use of time.
      final Readiness readiness = Readiness.from(
        blockCount: 5,
        filledBlockCount: 5,
        beatCount: 10,
        confirmedBeatCount: 5,
        plannedSeconds: 240,
        targetSeconds: 240,
        checklistTotal: 11,
        checklistDone: 11,
        plotTotal: 5,
        plotConfirmed: 0,
        rehearsalCount: 4,
        recentConfidence: 5,
      );

      expect(readiness.weakest?.kind, ReadinessKind.stagePlot);
    });
  });
}

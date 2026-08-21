import 'package:flutter_test/flutter_test.dart';
import 'package:tumbling_tricks/data/app_database.dart';
import 'package:tumbling_tricks/data/enums.dart';
import 'package:tumbling_tricks/data/models/act_report.dart';
import 'package:tumbling_tricks/data/models/run_order.dart';

/// Convenience factories keep the assertion side of each test short. Every
/// field the algorithm reads is set here explicitly; anything left implicit is
/// harmless padding the model requires.

DateTime _t = DateTime.utc(2024, 1, 1);
DateTime _now() {
  _t = _t.add(const Duration(seconds: 1));
  return _t;
}

ActRow _act({int targetSeconds = 240}) {
  return ActRow(
    id: 1,
    title: 'Act',
    subtitle: null,
    venue: null,
    status: ActStatus.planning,
    emblem: ActEmblem.tent,
    cueFrame: CueFrameStyle.curtain,
    targetSeconds: targetSeconds,
    performanceDate: null,
    summary: null,
    isArchived: false,
    createdAt: _now(),
    updatedAt: _now(),
    lastOpenedAt: null,
  );
}

int _blockId = 0;
int _beatId = 0;

RunOrderBlock _block(BlockRole role, {List<RunOrderItemRow> beats = const <RunOrderItemRow>[]}) {
  final int id = ++_blockId;
  return RunOrderBlock(
    block: ActBlockRow(
      id: id,
      actId: 1,
      role: role,
      title: '${role.label} block',
      intent: null,
      plannedSeconds: 30,
      position: id,
      createdAt: _now(),
      updatedAt: _now(),
    ),
    beats: beats,
  );
}

RunOrderItemRow _beat({
  int? trickId,
  int seconds = 15,
  bool isConfirmed = false,
  String label = 'Beat',
}) {
  return RunOrderItemRow(
    id: ++_beatId,
    blockId: 1,
    trickId: trickId,
    label: label,
    cueNote: null,
    seconds: seconds,
    position: _beatId,
    isConfirmed: isConfirmed,
  );
}

TrickRow _trick({
  required int id,
  int difficulty = 3,
  Mastery mastery = Mastery.reliable,
  String? safetyNote,
  String name = 'Trick',
}) {
  return TrickRow(
    id: id,
    slug: null,
    name: name,
    discipline: Discipline.acrobatics,
    difficulty: difficulty,
    mastery: mastery,
    summary: '',
    setupNote: null,
    safetyNote: safetyNote,
    typicalSeconds: 12,
    isCatalog: false,
    isArchived: false,
    timesRehearsed: 0,
    lastRehearsedAt: null,
    createdAt: _now(),
    updatedAt: _now(),
  );
}

void main() {
  group('ActReport', () {
    test('an empty run order produces no findings and an empty curve', () {
      final ActReport report = ActReport.from(
        runOrder: const RunOrder(actId: 1, blocks: <RunOrderBlock>[]),
        act: _act(),
        tricks: const <int, TrickRow>{},
      );

      expect(report.issues, isEmpty);
      expect(report.curve, isEmpty);
      expect(report.isClean, isTrue);
    });

    test('a well-shaped act reads clean', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(trickId: 1, seconds: 20, isConfirmed: true),
        ]),
        _block(BlockRole.main, beats: <RunOrderItemRow>[
          _beat(trickId: 2, seconds: 60, isConfirmed: true),
        ]),
        _block(BlockRole.highlight, beats: <RunOrderItemRow>[
          _beat(trickId: 3, seconds: 60, isConfirmed: true),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(trickId: 4, seconds: 60, isConfirmed: true),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 200),
        tricks: <int, TrickRow>{
          1: _trick(id: 1, difficulty: 2),
          2: _trick(id: 2, difficulty: 3),
          3: _trick(id: 3, difficulty: 5),
          4: _trick(id: 4, difficulty: 4),
        },
      );

      expect(report.issues.where((ActIssue i) => i.severity == IssueSeverity.critical), isEmpty);
      expect(report.overallSeverity, IssueSeverity.info);
    });

    test('two transitions in a row raise a warning, only once', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(seconds: 60, isConfirmed: true),
        ]),
        _block(BlockRole.transition, beats: <RunOrderItemRow>[
          _beat(seconds: 20, isConfirmed: true),
        ]),
        _block(BlockRole.transition, beats: <RunOrderItemRow>[
          _beat(seconds: 20, isConfirmed: true),
        ]),
        _block(BlockRole.transition, beats: <RunOrderItemRow>[
          _beat(seconds: 20, isConfirmed: true),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(seconds: 60, isConfirmed: true),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 180),
        tricks: const <int, TrickRow>{},
      );

      final Iterable<ActIssue> transitionIssues =
          report.issues.where((ActIssue i) => i.title == 'Two transitions in a row');
      expect(transitionIssues, hasLength(1));
      expect(transitionIssues.first.severity, IssueSeverity.warning);
    });

    test('a heavy opener is flagged and an unmastered opener is critical', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(trickId: 1, seconds: 30, isConfirmed: true),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(trickId: 2, seconds: 30, isConfirmed: true),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 60),
        tricks: <int, TrickRow>{
          1: _trick(id: 1, difficulty: 5, mastery: Mastery.learning),
          2: _trick(id: 2, difficulty: 3),
        },
      );

      expect(report.issues.any((ActIssue i) => i.title == 'Opener is heavy'), isTrue);
      expect(report.issues
          .any((ActIssue i) => i.title.startsWith('Opening on a trick')), isTrue);
      expect(report.overallSeverity, IssueSeverity.critical);
    });

    test('unconfirmed beats in the highlight or finale are critical', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(seconds: 30, isConfirmed: true),
        ]),
        _block(BlockRole.highlight, beats: <RunOrderItemRow>[
          _beat(seconds: 60, isConfirmed: false),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(seconds: 30, isConfirmed: true),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 120),
        tricks: const <int, TrickRow>{},
      );

      final ActIssue? unconfirmed = report.issues
          .where((ActIssue i) => i.title == 'Highlight not choreographed')
          .firstOrNull;
      expect(unconfirmed, isNotNull);
      expect(unconfirmed!.severity, IssueSeverity.critical);
    });

    test('the highlight being weaker than another block trips the peak rule', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(trickId: 1, seconds: 30, isConfirmed: true),
        ]),
        _block(BlockRole.main, beats: <RunOrderItemRow>[
          _beat(trickId: 2, seconds: 60, isConfirmed: true),
        ]),
        _block(BlockRole.highlight, beats: <RunOrderItemRow>[
          _beat(trickId: 3, seconds: 40, isConfirmed: true),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(trickId: 4, seconds: 30, isConfirmed: true),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 160),
        tricks: <int, TrickRow>{
          1: _trick(id: 1, difficulty: 2),
          2: _trick(id: 2, difficulty: 5),
          3: _trick(id: 3, difficulty: 2),
          4: _trick(id: 4, difficulty: 3),
        },
      );

      expect(report.issues.any((ActIssue i) => i.title == 'Highlight is not the peak'), isTrue);
    });

    test('the timing rule scales with drift and needs a target to run', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(seconds: 400, isConfirmed: true),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(seconds: 100, isConfirmed: true),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 200),
        tricks: const <int, TrickRow>{},
      );

      final ActIssue timing = report.issues
          .firstWhere((ActIssue i) => i.title == 'Runs long');
      expect(timing.severity, IssueSeverity.critical);
    });

    test('the curve carries one point per beat, in performance order', () {
      final RunOrder order = RunOrder(actId: 1, blocks: <RunOrderBlock>[
        _block(BlockRole.opening, beats: <RunOrderItemRow>[
          _beat(trickId: 1, seconds: 10, isConfirmed: true, label: 'a'),
          _beat(trickId: 2, seconds: 20, isConfirmed: true, label: 'b'),
        ]),
        _block(BlockRole.finale, beats: <RunOrderItemRow>[
          _beat(seconds: 15, isConfirmed: true, label: 'c'),
        ]),
      ]);

      final ActReport report = ActReport.from(
        runOrder: order,
        act: _act(targetSeconds: 45),
        tricks: <int, TrickRow>{
          1: _trick(id: 1, difficulty: 2),
          2: _trick(id: 2, difficulty: 4),
        },
      );

      expect(report.curve.map((EnergyPoint p) => p.beatLabel), <String>['a', 'b', 'c']);
      expect(report.curve.map((EnergyPoint p) => p.difficulty), <double>[2, 4, 0]);
      expect(report.curve.last.endSeconds, 45);
    });
  });
}

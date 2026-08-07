// drift exports `isNull` / `isNotNull` as SQL helpers, which collide with the
// matchers of the same name.
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbling_tricks/data/app_database.dart';
import 'package:tumbling_tricks/data/enums.dart';
import 'package:tumbling_tricks/data/models/act_summary.dart';
import 'package:tumbling_tricks/data/models/run_order.dart';
import 'package:tumbling_tricks/data/repositories/act_repository.dart';
import 'package:tumbling_tricks/data/repositories/preparation_repository.dart';
import 'package:tumbling_tricks/data/repositories/rehearsal_repository.dart';
import 'package:tumbling_tricks/data/repositories/run_order_repository.dart';
import 'package:tumbling_tricks/data/repositories/trick_repository.dart';
import 'package:tumbling_tricks/data/seed/act_template.dart';
import 'package:tumbling_tricks/data/seed/trick_catalog.dart';

void main() {
  late AppDatabase db;
  late ActRepository acts;
  late RunOrderRepository runOrder;
  late PreparationRepository preparation;
  late TrickRepository tricks;
  late RehearsalRepository rehearsals;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    acts = ActRepository(db);
    runOrder = RunOrderRepository(db);
    preparation = PreparationRepository(db);
    tricks = TrickRepository(db);
    rehearsals = RehearsalRepository(db);

    await db.ensureSingletonRows();
  });

  tearDown(() => db.close());

  group('Bootstrap', () {
    test('creates exactly one profile row and one preferences row', () async {
      // Called twice on purpose: relaunching must not add a second row.
      await db.ensureSingletonRows();

      expect(await db.select(db.performerProfiles).get(), hasLength(1));
      expect(await db.select(db.appPreferences).get(), hasLength(1));
    });

    test('seeds the trick catalogue once, then becomes a no-op', () async {
      final int firstRun = await db.mergeTrickCatalog();
      expect(firstRun, kTrickCatalog.length);

      final int secondRun = await db.mergeTrickCatalog();
      expect(secondRun, 0);
      expect(await db.select(db.tricks).get(), hasLength(kTrickCatalog.length));
    });

    test('seeded catalogue covers every discipline', () async {
      await db.mergeTrickCatalog();
      final List<TrickRow> rows = await db.select(db.tricks).get();

      for (final Discipline discipline in Discipline.values) {
        expect(
          rows.where((TrickRow t) => t.discipline == discipline),
          isNotEmpty,
          reason: discipline.label,
        );
      }
      expect(rows.every((TrickRow t) => t.isCatalog), isTrue);
      expect(rows.every((TrickRow t) => t.mastery == Mastery.learning), isTrue);
    });

    test('re-seeding restores a catalogue entry the user archived away',
        () async {
      await db.mergeTrickCatalog();

      // Simulate a later catalogue revision arriving after the user edited one
      // of the seeded tricks: their edit has to survive.
      final TrickRow edited = await db.select(db.tricks).get().then(
            (List<TrickRow> rows) => rows.first,
          );
      await tricks.setMastery(edited.id, Mastery.showReady);
      await (db.update(db.appPreferences)
            ..where((AppPreferences t) => t.id.equals(1)))
          .write(const AppPreferencesCompanion(catalogRevision: Value<int>(0)));

      await db.mergeTrickCatalog();

      final TrickRow after = await (db.select(db.tricks)
            ..where((Tricks t) => t.id.equals(edited.id)))
          .getSingle();
      expect(after.mastery, Mastery.showReady);
      expect(await db.select(db.tricks).get(), hasLength(kTrickCatalog.length));
    });
  });

  group('Creating an act', () {
    test('arrives with the starter structure, checklist and stage plot',
        () async {
      final int actId = await acts.create(title: 'Winter Gala', targetSeconds: 240);

      final ActSummary? summary = await acts.findOne(actId);
      expect(summary, isNotNull);
      expect(summary!.blockCount, kBlockTemplate.length);
      expect(summary.checklistTotal, kChecklistTemplate.length);
      expect(summary.plotTotal, kStagePlotTemplate.length);
      expect(summary.status, ActStatus.draft);

      // Nothing is pre-ticked: the score has to be earned.
      expect(summary.checklistDone, 0);
      expect(summary.plotConfirmed, 0);
      expect(summary.readiness.percent, 0);
    });

    test('splits the target running time across the blocks', () async {
      final int actId = await acts.create(title: 'Timed', targetSeconds: 300);

      final RunOrder order = await runOrder.watch(actId).first;
      expect(order.blocks, hasLength(kBlockTemplate.length));

      final int estimated = order.blocks.fold<int>(
        0,
        (int sum, RunOrderBlock b) => sum + b.estimateSeconds,
      );
      expect(estimated, 300);
      expect(
        order.blocks.map((RunOrderBlock b) => b.role),
        kBlockTemplate.map((BlockTemplate t) => t.role),
      );
    });

    test('can be created bare when the user wants to build it themselves',
        () async {
      final int actId = await acts.create(
        title: 'From scratch',
        targetSeconds: 240,
        applyTemplate: false,
      );

      final ActSummary summary = (await acts.findOne(actId))!;
      expect(summary.blockCount, 0);
      expect(summary.isEmpty, isTrue);
    });

    test('trims whitespace and drops blank optional fields', () async {
      final int actId = await acts.create(
        title: '  Spaced Out  ',
        subtitle: '   ',
        venue: '',
        targetSeconds: 240,
      );

      final ActSummary summary = (await acts.findOne(actId))!;
      expect(summary.title, 'Spaced Out');
      expect(summary.act.subtitle, isNull);
      expect(summary.act.venue, isNull);
    });
  });

  group('Deleting an act', () {
    test('takes its blocks, beats, checks, plot, notes and rehearsals with it',
        () async {
      final int actId = await acts.create(title: 'Doomed', targetSeconds: 240);
      final RunOrder order = await runOrder.watch(actId).first;
      await runOrder.addBeat(blockId: order.blocks.first.id, label: 'A beat');
      await rehearsals.log(
        actId: actId,
        happenedAt: DateTime.now(),
        minutes: 45,
        confidence: 3,
      );
      await db.into(db.notes).insert(
        NotesCompanion.insert(
          actId: Value<int>(actId),
          title: 'Lighting',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      await acts.delete(actId);

      expect(await db.select(db.acts).get(), isEmpty);
      expect(await db.select(db.actBlocks).get(), isEmpty);
      expect(await db.select(db.runOrderItems).get(), isEmpty);
      expect(await db.select(db.checklistItems).get(), isEmpty);
      expect(await db.select(db.stagePlotItems).get(), isEmpty);
      expect(await db.select(db.notes).get(), isEmpty);
      expect(await db.select(db.rehearsals).get(), isEmpty);
    });
  });

  group('Run order', () {
    late int actId;
    late int blockA;
    late int blockB;

    setUp(() async {
      actId = await acts.create(
        title: 'Ordering',
        targetSeconds: 240,
        applyTemplate: false,
      );
      blockA = await runOrder.addBlock(
        actId: actId,
        role: BlockRole.opening,
        title: 'Opening',
      );
      blockB = await runOrder.addBlock(
        actId: actId,
        role: BlockRole.finale,
        title: 'Finale',
      );
    });

    test('appends beats in order and totals their durations', () async {
      await runOrder.addBeat(blockId: blockA, label: 'One', seconds: 10);
      await runOrder.addBeat(blockId: blockA, label: 'Two', seconds: 20);

      final RunOrder order = await runOrder.watch(actId).first;
      final RunOrderBlock opening = order.blocks.first;

      expect(opening.beats.map((RunOrderItemRow b) => b.label), <String>['One', 'Two']);
      expect(opening.beats.map((RunOrderItemRow b) => b.position), <int>[0, 1]);
      expect(opening.actualSeconds, 30);
      expect(order.totalSeconds, 30);
    });

    test('keeps positions dense after a delete', () async {
      final int first = await runOrder.addBeat(blockId: blockA, label: 'One');
      await runOrder.addBeat(blockId: blockA, label: 'Two');
      await runOrder.addBeat(blockId: blockA, label: 'Three');

      await runOrder.deleteBeat(first);

      final RunOrder order = await runOrder.watch(actId).first;
      expect(
        order.blocks.first.beats.map((RunOrderItemRow b) => b.position),
        <int>[0, 1],
      );
      expect(
        order.blocks.first.beats.map((RunOrderItemRow b) => b.label),
        <String>['Two', 'Three'],
      );
    });

    test('reorders beats within a block', () async {
      final int one = await runOrder.addBeat(blockId: blockA, label: 'One');
      final int two = await runOrder.addBeat(blockId: blockA, label: 'Two');
      final int three = await runOrder.addBeat(blockId: blockA, label: 'Three');

      await runOrder.reorderBeats(
        blockId: blockA,
        orderedBeatIds: <int>[three, one, two],
      );

      final RunOrder order = await runOrder.watch(actId).first;
      expect(
        order.blocks.first.beats.map((RunOrderItemRow b) => b.label),
        <String>['Three', 'One', 'Two'],
      );
    });

    test('moves a beat into another block at the requested index', () async {
      final int moved = await runOrder.addBeat(blockId: blockA, label: 'Moved');
      await runOrder.addBeat(blockId: blockA, label: 'Stays');
      await runOrder.addBeat(blockId: blockB, label: 'First');
      await runOrder.addBeat(blockId: blockB, label: 'Last');

      await runOrder.moveBeat(beatId: moved, targetBlockId: blockB, targetIndex: 1);

      final RunOrder order = await runOrder.watch(actId).first;
      expect(
        order.blocks[0].beats.map((RunOrderItemRow b) => b.label),
        <String>['Stays'],
      );
      expect(order.blocks[0].beats.single.position, 0);
      expect(
        order.blocks[1].beats.map((RunOrderItemRow b) => b.label),
        <String>['First', 'Moved', 'Last'],
      );
      expect(
        order.blocks[1].beats.map((RunOrderItemRow b) => b.position),
        <int>[0, 1, 2],
      );
    });

    test('reorders blocks and renumbers after one is removed', () async {
      await runOrder.reorderBlocks(actId: actId, orderedBlockIds: <int>[blockB, blockA]);

      RunOrder order = await runOrder.watch(actId).first;
      expect(order.blocks.map((RunOrderBlock b) => b.id), <int>[blockB, blockA]);

      await runOrder.deleteBlock(blockB);

      order = await runOrder.watch(actId).first;
      expect(order.blocks.map((RunOrderBlock b) => b.block.position), <int>[0]);
    });

    test('an empty block still appears, so it can be filled', () async {
      final RunOrder order = await runOrder.watch(actId).first;
      expect(order.blocks, hasLength(2));
      expect(order.blocks.every((RunOrderBlock b) => b.isEmpty), isTrue);
    });

    test('the timeline gives every beat its start time', () async {
      await runOrder.addBeat(blockId: blockA, label: 'One', seconds: 10);
      await runOrder.addBeat(blockId: blockA, label: 'Two', seconds: 5);
      await runOrder.addBeat(blockId: blockB, label: 'Three', seconds: 20);

      final RunOrder order = await runOrder.watch(actId).first;
      expect(
        order.timeline.map((({RunOrderBlock block, RunOrderItemRow beat, int startSeconds}) e) => e.startSeconds),
        <int>[0, 10, 15],
      );
      expect(order.blockStartOffsets, <int>[0, 15]);
    });

    test('placing a trick carries its name and duration across', () async {
      await db.mergeTrickCatalog();
      final TrickRow trick = await (db.select(db.tricks)
            ..where((Tricks t) => t.slug.equals('acro-back-handspring')))
          .getSingle();

      final int beatId = await runOrder.addBeatFromTrick(
        blockId: blockA,
        trick: trick,
      );

      final RunOrderItemRow beat = await (db.select(db.runOrderItems)
            ..where((RunOrderItems t) => t.id.equals(beatId)))
          .getSingle();
      expect(beat.label, trick.name);
      expect(beat.seconds, trick.typicalSeconds);
      expect(beat.trickId, trick.id);
    });

    test('deleting a user trick leaves the beat readable without the link',
        () async {
      final int trickId = await tricks.create(
        name: 'My own move',
        discipline: Discipline.acrobatics,
      );
      final TrickRow trick = await (db.select(db.tricks)
            ..where((Tricks t) => t.id.equals(trickId)))
          .getSingle();
      final int beatId = await runOrder.addBeatFromTrick(
        blockId: blockA,
        trick: trick,
      );

      expect(await tricks.delete(trickId), isTrue);

      final RunOrderItemRow beat = await (db.select(db.runOrderItems)
            ..where((RunOrderItems t) => t.id.equals(beatId)))
          .getSingle();
      expect(beat.label, 'My own move');
      expect(beat.trickId, isNull);
    });
  });

  group('Trick library', () {
    setUp(() => db.mergeTrickCatalog());

    test('catalogue entries cannot be deleted, only archived', () async {
      final TrickRow catalogTrick = await (db.select(db.tricks)
            ..where((Tricks t) => t.isCatalog.equals(true))
            ..limit(1))
          .getSingle();

      expect(await tricks.delete(catalogTrick.id), isFalse);
      expect(await db.select(db.tricks).get(), hasLength(kTrickCatalog.length));

      await tricks.setArchived(catalogTrick.id, archived: true);
      final List<TrickRow> visible = await tricks.watchLibrary().first;
      expect(visible.any((TrickRow t) => t.id == catalogTrick.id), isFalse);
    });

    test('filters by discipline and searches name and summary', () async {
      final List<TrickRow> acro = await tricks
          .watchLibrary(discipline: Discipline.acrobatics)
          .first;
      expect(acro, isNotEmpty);
      expect(
        acro.every((TrickRow t) => t.discipline == Discipline.acrobatics),
        isTrue,
      );

      final List<TrickRow> handsprings =
          await tricks.watchLibrary(query: 'handspring').first;
      expect(handsprings, isNotEmpty);
      expect(
        handsprings.every(
          (TrickRow t) =>
              t.name.toLowerCase().contains('handspring') ||
              t.summary.toLowerCase().contains('handspring'),
        ),
        isTrue,
      );
    });

    test('discipline stats always list all four disciplines', () async {
      final List<DisciplineStats> stats = await tricks.watchDisciplineStats().first;

      expect(stats.map((DisciplineStats s) => s.discipline), Discipline.values);
      expect(stats.every((DisciplineStats s) => s.total > 0), isTrue);
      expect(stats.every((DisciplineStats s) => s.showReady == 0), isTrue);
      expect(stats.every((DisciplineStats s) => s.inUse == 0), isTrue);
    });
  });

  group('Rehearsals', () {
    test('logging a session credits the catalogued tricks in the run order',
        () async {
      await db.mergeTrickCatalog();
      final int actId = await acts.create(title: 'Credited', targetSeconds: 240);
      final RunOrder order = await runOrder.watch(actId).first;
      final TrickRow trick = await (db.select(db.tricks)..limit(1)).getSingle();

      await runOrder.addBeatFromTrick(
        blockId: order.blocks.first.id,
        trick: trick,
      );
      // A free-form beat must not be credited to anything.
      await runOrder.addBeat(blockId: order.blocks.first.id, label: 'Ad lib');

      final DateTime when = DateTime(2026, 3, 4, 19);
      await rehearsals.log(
        actId: actId,
        happenedAt: when,
        minutes: 90,
        confidence: 4,
        focus: 'Worked the opening',
      );

      final TrickRow credited = await (db.select(db.tricks)
            ..where((Tricks t) => t.id.equals(trick.id)))
          .getSingle();
      expect(credited.timesRehearsed, 1);
      expect(credited.lastRehearsedAt, when);

      final TrickRow untouched = await (db.select(db.tricks)
            ..where((Tricks t) => t.id.isNotValue(trick.id))
            ..limit(1))
          .getSingle();
      expect(untouched.timesRehearsed, 0);
    });

    test('summary reports session count and the recent confidence average',
        () async {
      final int actId = await acts.create(title: 'Logged', targetSeconds: 240);

      // Five sessions; only the last three should shape the average.
      const List<int> scores = <int>[1, 1, 5, 5, 5];
      for (int i = 0; i < scores.length; i++) {
        await rehearsals.log(
          actId: actId,
          happenedAt: DateTime(2026, 1, 1 + i),
          minutes: 60,
          confidence: scores[i],
        );
      }

      final ActSummary summary = (await acts.findOne(actId))!;
      expect(summary.rehearsalCount, 5);
      expect(summary.recentConfidence, closeTo(5.0, 1e-9));
      expect(summary.lastRehearsedAt, DateTime(2026, 1, 5));
    });

    test('recent confidence falls back to the overall average under three runs',
        () async {
      final int actId = await acts.create(title: 'Two runs', targetSeconds: 240);
      await rehearsals.log(
        actId: actId,
        happenedAt: DateTime(2026, 1, 1),
        minutes: 30,
        confidence: 2,
      );
      await rehearsals.log(
        actId: actId,
        happenedAt: DateTime(2026, 1, 2),
        minutes: 30,
        confidence: 4,
      );

      final ActSummary summary = (await acts.findOne(actId))!;
      expect(summary.recentConfidence, closeTo(3.0, 1e-9));
    });

    test('an act never rehearsed reports zero rather than null', () async {
      final int actId = await acts.create(title: 'Fresh', targetSeconds: 240);
      final ActSummary summary = (await acts.findOne(actId))!;

      expect(summary.rehearsalCount, 0);
      expect(summary.recentConfidence, 0);
      expect(summary.lastRehearsedAt, isNull);
      expect(summary.daysSinceRehearsal(), isNull);
    });
  });

  group('Readiness through the summary query', () {
    test('reaches 100 once every signal is satisfied', () async {
      await db.mergeTrickCatalog();
      final int actId = await acts.create(title: 'Complete', targetSeconds: 120);

      final RunOrder order = await runOrder.watch(actId).first;
      // One beat per block, sharing the target time evenly.
      final int perBeat = 120 ~/ order.blocks.length;
      for (final RunOrderBlock block in order.blocks) {
        final int beatId = await runOrder.addBeat(
          blockId: block.id,
          label: 'Beat in ${block.title}',
          seconds: perBeat,
        );
        await runOrder.updateBeat(beatId: beatId, isConfirmed: true);
      }

      for (final ChecklistItemRow check
          in await preparation.watchChecklist(actId).first) {
        await preparation.setCheckDone(check.id, done: true);
      }
      for (final StagePlotItemRow line
          in await preparation.watchStagePlot(actId).first) {
        await preparation.setPlotConfirmed(line.id, confirmed: true);
      }
      for (int i = 0; i < 4; i++) {
        await rehearsals.log(
          actId: actId,
          happenedAt: DateTime(2026, 2, 1 + i),
          minutes: 60,
          confidence: 5,
        );
      }

      final ActSummary summary = (await acts.findOne(actId))!;
      expect(summary.plannedSeconds, 120);
      expect(summary.timingDriftSeconds, 0);
      expect(summary.readiness.percent, 100);
      expect(summary.readiness.weakest, isNull);
    });

    test('rises as work is done and never exceeds 100', () async {
      final int actId = await acts.create(title: 'Progressing', targetSeconds: 240);
      int previous = (await acts.findOne(actId))!.readiness.percent;

      for (final ChecklistItemRow check
          in await preparation.watchChecklist(actId).first) {
        await preparation.setCheckDone(check.id, done: true);
        final int now = (await acts.findOne(actId))!.readiness.percent;
        expect(now, greaterThanOrEqualTo(previous));
        expect(now, lessThanOrEqualTo(100));
        previous = now;
      }

      expect(previous, greaterThan(0));
    });

    test('resetting the checklist takes the score back down', () async {
      final int actId = await acts.create(title: 'Restaged', targetSeconds: 240);
      for (final ChecklistItemRow check
          in await preparation.watchChecklist(actId).first) {
        await preparation.setCheckDone(check.id, done: true);
      }
      final int afterTicking = (await acts.findOne(actId))!.readiness.percent;

      await preparation.resetChecklist(actId);

      final ActSummary summary = (await acts.findOne(actId))!;
      expect(summary.checklistDone, 0);
      expect(summary.readiness.percent, lessThan(afterTicking));
      expect(
        (await preparation.watchChecklist(actId).first)
            .every((ChecklistItemRow c) => c.doneAt == null),
        isTrue,
      );
    });

    test('ticking a check records when it was cleared', () async {
      final int actId = await acts.create(title: 'Stamped', targetSeconds: 240);
      final ChecklistItemRow check =
          (await preparation.watchChecklist(actId).first).first;

      await preparation.setCheckDone(check.id, done: true);
      final ChecklistItemRow done = (await preparation.watchChecklist(actId).first)
          .firstWhere((ChecklistItemRow c) => c.id == check.id);
      expect(done.doneAt, isNotNull);

      await preparation.setCheckDone(check.id, done: false);
      final ChecklistItemRow undone = (await preparation.watchChecklist(actId).first)
          .firstWhere((ChecklistItemRow c) => c.id == check.id);
      expect(undone.doneAt, isNull);
    });
  });

  group('Archiving and duplicating', () {
    test('archiving moves the act out of the active list and marks it completed',
        () async {
      final int actId = await acts.create(title: 'Last year', targetSeconds: 240);

      await acts.setArchived(actId, archived: true);

      expect(await acts.watchActive().first, isEmpty);
      final List<ActSummary> archived = await acts.watchArchived().first;
      expect(archived, hasLength(1));
      expect(archived.single.status, ActStatus.completed);
    });

    test('duplicating copies the structure but not the rehearsal history',
        () async {
      final int actId = await acts.create(title: 'Original', targetSeconds: 240);
      final RunOrder order = await runOrder.watch(actId).first;
      final int beatId = await runOrder.addBeat(
        blockId: order.blocks.first.id,
        label: 'Signature move',
        seconds: 20,
      );
      await runOrder.updateBeat(beatId: beatId, isConfirmed: true);
      await preparation.setCheckDone(
        (await preparation.watchChecklist(actId).first).first.id,
        done: true,
      );
      await rehearsals.log(
        actId: actId,
        happenedAt: DateTime(2026, 1, 1),
        minutes: 60,
        confidence: 5,
      );

      final int copyId = await acts.duplicate(actId, newTitle: 'Restaged');
      final ActSummary copy = (await acts.findOne(copyId))!;

      expect(copy.title, 'Restaged');
      expect(copy.status, ActStatus.draft);
      expect(copy.blockCount, order.blocks.length);
      expect(copy.beatCount, 1);
      expect(copy.plotTotal, kStagePlotTemplate.length);
      expect(copy.checklistTotal, kChecklistTemplate.length);

      // A new staging starts with nothing signed off and no history.
      expect(copy.confirmedBeatCount, 0);
      expect(copy.checklistDone, 0);
      expect(copy.rehearsalCount, 0);

      final RunOrder copiedOrder = await runOrder.watch(copyId).first;
      expect(
        copiedOrder.blocks.first.beats.single.label,
        'Signature move',
      );
    });

    test('duplicating an act that no longer exists fails loudly', () async {
      expect(
        () => acts.duplicate(999, newTitle: 'Ghost'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('Erasing everything', () {
    test('clears the user data and leaves a usable fresh install', () async {
      await db.mergeTrickCatalog();
      final int actId = await acts.create(title: 'Gone soon', targetSeconds: 240);
      await rehearsals.log(
        actId: actId,
        happenedAt: DateTime.now(),
        minutes: 30,
        confidence: 3,
      );
      await tricks.create(name: 'Mine', discipline: Discipline.illusion);

      await db.eraseAllData();

      expect(await db.select(db.acts).get(), isEmpty);
      expect(await db.select(db.rehearsals).get(), isEmpty);
      // The bundled catalogue comes back; the user's own trick does not.
      expect(await db.select(db.tricks).get(), hasLength(kTrickCatalog.length));
      expect(await db.select(db.performerProfiles).get(), hasLength(1));
      expect(await db.select(db.appPreferences).get(), hasLength(1));

      final AppPreferenceRow prefs = await db.preferencesRow().getSingle();
      expect(prefs.onboardingCompleted, isFalse);
      expect(prefs.catalogRevision, kTrickCatalogRevision);
    });
  });
}

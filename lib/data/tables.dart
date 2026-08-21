// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import 'enums.dart';

/// Every enum column is stored by `name` via `textEnum`, which keeps the
/// database readable in a backup file and survives reordering the enum.
///
/// A few columns carry a `CHECK` constraint written in drift's documented form,
/// where the getter names itself inside `.check(...)`. These bodies are only
/// ever read by the code generator — the generated table resolves the reference
/// to its own column — so the apparent recursion never runs. That is why
/// `recursive_getters` is suppressed for the whole file.

/// The trick catalogue: seeded reference material plus anything the user adds.
///
/// Tricks are owned by the library, not by an act, so the same trick can appear
/// in several acts and its mastery is tracked in one place.
@DataClassName('TrickRow')
class Tricks extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable identifier for seeded entries, `null` for user-created tricks.
  /// Lets a later catalogue revision add material without duplicating rows.
  TextColumn get slug => text().unique().nullable()();

  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get discipline => textEnum<Discipline>()();

  /// 1 (foundational) to 5 (advanced).
  IntColumn get difficulty =>
      integer().check(difficulty.isBetweenValues(1, 5)).withDefault(const Constant(1))();

  TextColumn get mastery =>
      textEnum<Mastery>().withDefault(Constant(Mastery.learning.name))();

  TextColumn get summary => text().withDefault(const Constant(''))();

  /// What has to be in place before this can be attempted.
  TextColumn get setupNote => text().nullable()();

  /// Spotting, matting or rigging requirements. Surfaced prominently in the UI.
  TextColumn get safetyNote => text().nullable()();

  /// How long the trick usually takes on stage, in seconds.
  IntColumn get typicalSeconds => integer().withDefault(const Constant(12))();

  /// True for rows that came from the bundled catalogue.
  BoolColumn get isCatalog => boolean().withDefault(const Constant(false))();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  IntColumn get timesRehearsed => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastRehearsedAt => dateTime().nullable()();

  /// Set when the mastery decay pass most recently downgraded this trick.
  /// Distinct from an explicit user rating so the "recently atrophied" list
  /// on the Stage Console can single out decay events without also flagging
  /// deliberate reclassifications.
  DateTimeColumn get masteryDecayedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// A performance project: one routine being prepared.
@DataClassName('ActRow')
class Acts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 90)();

  /// Optional second line, e.g. "Act II" or "Closing set".
  TextColumn get subtitle => text().nullable()();

  TextColumn get venue => text().nullable()();

  TextColumn get status =>
      textEnum<ActStatus>().withDefault(Constant(ActStatus.draft.name))();

  TextColumn get emblem =>
      textEnum<ActEmblem>().withDefault(Constant(ActEmblem.tent.name))();

  TextColumn get cueFrame =>
      textEnum<CueFrameStyle>().withDefault(Constant(CueFrameStyle.curtain.name))();

  /// Target running time in seconds, set when the act is created.
  IntColumn get targetSeconds => integer().withDefault(const Constant(240))();

  DateTimeColumn get performanceDate => dateTime().nullable()();

  /// One or two lines on what the act is going for.
  TextColumn get summary => text().nullable()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Drives "continue where you left off" on the Stage Console.
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
}

/// A structural section of an act: opening, main element, transition and so on.
@DataClassName('ActBlockRow')
class ActBlocks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get actId =>
      integer().references(Acts, #id, onDelete: KeyAction.cascade)();

  TextColumn get role => textEnum<BlockRole>()();

  TextColumn get title => text().withLength(min: 1, max: 90)();

  /// What this section has to achieve. Kept separate from notes because it is
  /// the thing the user rereads while ordering tricks.
  TextColumn get intent => text().nullable()();

  IntColumn get plannedSeconds => integer().withDefault(const Constant(30))();

  /// Zero-based order within the act.
  IntColumn get position => integer()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// One entry in the run order: a trick placed inside a block, in sequence.
@DataClassName('RunOrderItemRow')
class RunOrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get blockId =>
      integer().references(ActBlocks, #id, onDelete: KeyAction.cascade)();

  /// Null when the entry is a one-off beat rather than a catalogued trick, and
  /// also when a referenced trick is later deleted.
  IntColumn get trickId =>
      integer().references(Tricks, #id, onDelete: KeyAction.setNull).nullable()();

  /// Copied from the trick when linked. Keeping it here means the run order
  /// still reads correctly if the trick is renamed or removed.
  TextColumn get label => text().withLength(min: 1, max: 90)();

  /// What the operator or partner needs to know at this beat.
  TextColumn get cueNote => text().nullable()();

  IntColumn get seconds => integer().withDefault(const Constant(15))();

  IntColumn get position => integer()();

  /// Set once the beat is choreographed and timed, not just planned.
  BoolColumn get isConfirmed => boolean().withDefault(const Constant(false))();
}

/// A rehearsal checklist line for an act.
@DataClassName('ChecklistItemRow')
class ChecklistItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get actId =>
      integer().references(Acts, #id, onDelete: KeyAction.cascade)();

  TextColumn get category => textEnum<ChecklistCategory>()();

  TextColumn get label => text().withLength(min: 1, max: 120)();
  TextColumn get detail => text().nullable()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get doneAt => dateTime().nullable()();

  IntColumn get position => integer()();
}

/// A line on the act's stage plot, i.e. its technical rider.
@DataClassName('StagePlotItemRow')
class StagePlotItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get actId =>
      integer().references(Acts, #id, onDelete: KeyAction.cascade)();

  TextColumn get equipment => textEnum<StageEquipment>()();

  TextColumn get label => text().withLength(min: 1, max: 120)();

  /// Free-form specification: channel numbers, colour, position, model.
  TextColumn get spec => text().nullable()();

  /// Confirmed with the venue or the operator.
  BoolColumn get isConfirmed => boolean().withDefault(const Constant(false))();

  IntColumn get position => integer()();
}

/// A written note. Belongs to an act, or to nobody when it is a general one.
@DataClassName('NoteRow')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get actId =>
      integer().references(Acts, #id, onDelete: KeyAction.cascade).nullable()();

  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get body => text().withDefault(const Constant(''))();

  TextColumn get ruling =>
      textEnum<PageRuling>().withDefault(Constant(PageRuling.lined.name))();

  TextColumn get stock =>
      textEnum<PaperStock>().withDefault(Constant(PaperStock.aged.name))();

  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// One logged rehearsal session.
@DataClassName('RehearsalRow')
class Rehearsals extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get actId =>
      integer().references(Acts, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get happenedAt => dateTime()();

  IntColumn get minutes =>
      integer().check(minutes.isBiggerOrEqualValue(1)).withDefault(const Constant(30))();

  /// What was actually worked in the session.
  TextColumn get focus => text().withDefault(const Constant(''))();

  /// How the run felt, 1 to 5. Plotted over time in Progress.
  IntColumn get confidence =>
      integer().check(confidence.isBetweenValues(1, 5)).withDefault(const Constant(3))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}

/// Single-row table holding the performer's own details.
@DataClassName('PerformerProfileRow')
class PerformerProfiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  TextColumn get stageName => text().withDefault(const Constant(''))();

  TextColumn get discipline => textEnum<Discipline>().nullable()();

  TextColumn get homeVenue => text().nullable()();

  /// File name of the performer photo inside the app's documents directory.
  /// Only a name is stored, never an absolute path, because the container path
  /// changes between installs and OS upgrades.
  TextColumn get photoFileName => text().nullable()();

  TextColumn get bio => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// Single-row table holding app preferences.
@DataClassName('AppPreferenceRow')
class AppPreferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get hapticsEnabled => boolean().withDefault(const Constant(true))();

  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get reminderHour =>
      integer().check(reminderHour.isBetweenValues(0, 23)).withDefault(const Constant(18))();
  IntColumn get reminderMinute =>
      integer().check(reminderMinute.isBetweenValues(0, 59)).withDefault(const Constant(0))();

  /// Bit per ISO weekday, bit 0 = Monday. Defaults to every day.
  IntColumn get reminderWeekdayMask => integer().withDefault(const Constant(0x7F))();

  /// Daily nudge, independent of the weekly rehearsal reminder above.
  ///
  /// Kept as its own set of columns rather than reused because the two
  /// reminders answer different questions: the weekly one is a rehearsal
  /// schedule, the daily one is a simple showtime nudge with a rotating
  /// message. They can be on or off independently.
  BoolColumn get dailyReminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get dailyReminderHour => integer()
      .check(dailyReminderHour.isBetweenValues(0, 23))
      .withDefault(const Constant(9))();
  IntColumn get dailyReminderMinute => integer()
      .check(dailyReminderMinute.isBetweenValues(0, 59))
      .withDefault(const Constant(0))();

  BoolColumn get onboardingCompleted => boolean().withDefault(const Constant(false))();

  /// Revision of the bundled trick catalogue already merged into `tricks`.
  IntColumn get catalogRevision => integer().withDefault(const Constant(0))();

  /// Pre-filled target running time when creating a new act, in seconds.
  IntColumn get defaultTargetSeconds => integer().withDefault(const Constant(240))();

  /// When on, the mastery-decay pass runs at launch: tricks not rehearsed for
  /// long enough drop one notch, so an act that has been left alone loses
  /// readiness without needing the user to relabel anything.
  BoolColumn get decayEnabled => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

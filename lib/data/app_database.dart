import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// The generated part file names the domain enums directly in its companion and
// row classes, so they have to be in scope here rather than only in tables.dart.
import 'enums.dart';
import 'seed/trick_catalog.dart';
import 'tables.dart';

// Repositories write queries against the table classes as well as the generated
// row and companion classes, so both travel together from this one import.
export 'tables.dart';

part 'app_database.g.dart';

/// The one and only store in the app.
///
/// Everything the user creates lives here, on the device. There is no sync, no
/// remote copy and no account, so the database is also the unit of backup:
/// Settings exports it as JSON and can restore from the same file.
@DriftDatabase(
  tables: <Type>[
    Tricks,
    Acts,
    ActBlocks,
    RunOrderItems,
    ChecklistItems,
    StagePlotItems,
    Notes,
    Rehearsals,
    PerformerProfiles,
    AppPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: _fileName));

  /// Used by tests, which pass an in-memory executor.
  AppDatabase.forTesting(super.executor);

  static const String _fileName = 'tumbling_tricks';

  /// Primary key of the profile and preferences rows, both single-row tables.
  static const int _singletonId = 1;

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // v1 → v2 adds the mastery-decay columns. Additive migrations, so any
        // trick or preference row already in place carries its existing
        // values across untouched.
        if (from < 2) {
          await m.addColumn(tricks, tricks.masteryDecayedAt);
          await m.addColumn(appPreferences, appPreferences.decayEnabled);
        }
        // v2 → v3 adds the daily-reminder columns. Existing rows land on the
        // defaults (off, 09:00), so the switch reads correctly on first open.
        if (from < 3) {
          await m.addColumn(appPreferences, appPreferences.dailyReminderEnabled);
          await m.addColumn(appPreferences, appPreferences.dailyReminderHour);
          await m.addColumn(appPreferences, appPreferences.dailyReminderMinute);
        }
      },
      beforeOpen: (OpeningDetails details) async {
        // Cascading deletes are what keep an act's blocks, run order, checklist,
        // stage plot, notes and rehearsals from outliving it. SQLite leaves them
        // off unless asked, per connection.
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  /// Creates the profile and preferences rows if they are missing.
  ///
  /// Both tables are single-row by design; having the row always present means
  /// the rest of the app can read settings without handling an empty state.
  Future<void> ensureSingletonRows() async {
    final DateTime now = DateTime.now();

    // The id has to be written explicitly. SQLite treats an INTEGER PRIMARY KEY
    // as an alias for the rowid and ignores its DEFAULT, so omitting it would
    // auto-assign the next rowid and quietly add a second "singleton" row on
    // every launch instead of conflicting with the first.
    await batch((Batch batch) {
      batch.insert(
        performerProfiles,
        PerformerProfilesCompanion.insert(
          id: const Value<int>(_singletonId),
          createdAt: now,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
      batch.insert(
        appPreferences,
        const AppPreferencesCompanion(id: Value<int>(_singletonId)),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  /// Merges the bundled trick catalogue into the library.
  ///
  /// Only slugs that are not already present are inserted, so a user's mastery
  /// ratings, edits and their own tricks are never touched. Returns how many
  /// rows were added, which is zero on every launch after the first.
  Future<int> mergeTrickCatalog() async {
    final AppPreferenceRow prefs = await preferencesRow().getSingle();
    if (prefs.catalogRevision >= kTrickCatalogRevision) return 0;

    final Set<String> existing = (await (selectOnly(tricks)
              ..addColumns(<Expression<Object>>[tricks.slug])
              ..where(tricks.slug.isNotNull()))
            .map((TypedResult row) => row.read<String>(tricks.slug))
            .get())
        .whereType<String>()
        .toSet();

    final List<SeedTrick> missing = kTrickCatalog
        .where((SeedTrick t) => !existing.contains(t.slug))
        .toList(growable: false);

    final DateTime now = DateTime.now();

    await transaction(() async {
      if (missing.isNotEmpty) {
        await batch((Batch batch) {
          batch.insertAll(
            tricks,
            missing.map(
              (SeedTrick t) => TricksCompanion.insert(
                slug: Value<String>(t.slug),
                name: t.name,
                discipline: t.discipline,
                difficulty: Value<int>(t.difficulty),
                summary: Value<String>(t.summary),
                setupNote: Value<String?>(t.setupNote),
                safetyNote: Value<String?>(t.safetyNote),
                typicalSeconds: Value<int>(t.typicalSeconds),
                isCatalog: const Value<bool>(true),
                createdAt: now,
                updatedAt: now,
              ),
            ),
          );
        });
      }

      await (update(appPreferences)..where((AppPreferences t) => t.id.equals(1)))
          .write(
        const AppPreferencesCompanion(
          catalogRevision: Value<int>(kTrickCatalogRevision),
        ),
      );
    });

    return missing.length;
  }

  /// The single preferences row.
  SimpleSelectStatement<AppPreferences, AppPreferenceRow> preferencesRow() =>
      select(appPreferences)..where((AppPreferences t) => t.id.equals(1));

  /// The single profile row.
  SimpleSelectStatement<PerformerProfiles, PerformerProfileRow> profileRow() =>
      select(performerProfiles)..where((PerformerProfiles t) => t.id.equals(1));

  /// Wipes everything the user has created and reinstates a fresh install.
  ///
  /// Backs the destructive Settings action; deliberately keeps nothing, then
  /// re-seeds so the app is immediately usable again rather than empty.
  Future<void> eraseAllData() async {
    await transaction(() async {
      // Acts cascade into blocks, run order, checklist, stage plot, notes and
      // rehearsals, so only the roots need deleting explicitly.
      await delete(acts).go();
      await delete(notes).go();
      await delete(tricks).go();
      await delete(performerProfiles).go();
      await delete(appPreferences).go();
    });

    await ensureSingletonRows();
    await mergeTrickCatalog();
  }
}

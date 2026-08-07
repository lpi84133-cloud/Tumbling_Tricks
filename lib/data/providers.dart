import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'enums.dart';
import 'models/act_summary.dart';
import 'models/run_order.dart';
import 'repositories/act_repository.dart';
import 'repositories/note_repository.dart';
import 'repositories/preferences_repository.dart';
import 'repositories/preparation_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/rehearsal_repository.dart';
import 'repositories/run_order_repository.dart';
import 'repositories/trick_repository.dart';

/// The database. Tests and the bootstrap sequence override this.
final Provider<AppDatabase> databaseProvider = Provider<AppDatabase>((Ref ref) {
  final AppDatabase db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ------------------------------------------------------------------ repositories

final Provider<ActRepository> actRepositoryProvider =
    Provider<ActRepository>((Ref ref) => ActRepository(ref.watch(databaseProvider)));

final Provider<RunOrderRepository> runOrderRepositoryProvider =
    Provider<RunOrderRepository>(
  (Ref ref) => RunOrderRepository(ref.watch(databaseProvider)),
);

final Provider<PreparationRepository> preparationRepositoryProvider =
    Provider<PreparationRepository>(
  (Ref ref) => PreparationRepository(ref.watch(databaseProvider)),
);

final Provider<TrickRepository> trickRepositoryProvider =
    Provider<TrickRepository>((Ref ref) => TrickRepository(ref.watch(databaseProvider)));

final Provider<RehearsalRepository> rehearsalRepositoryProvider =
    Provider<RehearsalRepository>(
  (Ref ref) => RehearsalRepository(ref.watch(databaseProvider)),
);

final Provider<NoteRepository> noteRepositoryProvider =
    Provider<NoteRepository>((Ref ref) => NoteRepository(ref.watch(databaseProvider)));

final Provider<ProfileRepository> profileRepositoryProvider =
    Provider<ProfileRepository>(
  (Ref ref) => ProfileRepository(ref.watch(databaseProvider)),
);

final Provider<PreferencesRepository> preferencesRepositoryProvider =
    Provider<PreferencesRepository>(
  (Ref ref) => PreferencesRepository(ref.watch(databaseProvider)),
);

// ------------------------------------------------------------------------- acts

/// Acts still in preparation, most recently opened first.
final StreamProvider<List<ActSummary>> activeActsProvider =
    StreamProvider<List<ActSummary>>(
  (Ref ref) => ref.watch(actRepositoryProvider).watchActive(),
);

/// The Playbill Archive.
final StreamProvider<List<ActSummary>> archivedActsProvider =
    StreamProvider<List<ActSummary>>(
  (Ref ref) => ref.watch(actRepositoryProvider).watchArchived(),
);

final actSummaryProvider = StreamProvider.family<ActSummary?, int>(
  (Ref ref, int actId) => ref.watch(actRepositoryProvider).watchOne(actId),
);

final runOrderProvider = StreamProvider.family<RunOrder, int>(
  (Ref ref, int actId) => ref.watch(runOrderRepositoryProvider).watch(actId),
);

final checklistProvider = StreamProvider.family<List<ChecklistItemRow>, int>(
  (Ref ref, int actId) => ref.watch(preparationRepositoryProvider).watchChecklist(actId),
);

final stagePlotProvider = StreamProvider.family<List<StagePlotItemRow>, int>(
  (Ref ref, int actId) => ref.watch(preparationRepositoryProvider).watchStagePlot(actId),
);

final actNotesProvider = StreamProvider.family<List<NoteRow>, int>(
  (Ref ref, int actId) => ref.watch(noteRepositoryProvider).watchForAct(actId),
);

final actRehearsalsProvider = StreamProvider.family<List<RehearsalRow>, int>(
  (Ref ref, int actId) => ref.watch(rehearsalRepositoryProvider).watchForAct(actId),
);

// ---------------------------------------------------------------- trick library

/// Filter for the trick library. A record, so two identical filters are the
/// same family key and reuse one subscription.
typedef TrickFilter = ({Discipline? discipline, Mastery? mastery, String query});

const TrickFilter kAllTricks =
    (discipline: null, mastery: null, query: '');

final trickLibraryProvider = StreamProvider.family<List<TrickRow>, TrickFilter>(
  (Ref ref, TrickFilter filter) => ref.watch(trickRepositoryProvider).watchLibrary(
    discipline: filter.discipline,
    mastery: filter.mastery,
    query: filter.query,
  ),
);

final trickProvider = StreamProvider.family<TrickRow?, int>(
  (Ref ref, int trickId) => ref.watch(trickRepositoryProvider).watchOne(trickId),
);

final StreamProvider<List<DisciplineStats>> disciplineStatsProvider =
    StreamProvider<List<DisciplineStats>>(
  (Ref ref) => ref.watch(trickRepositoryProvider).watchDisciplineStats(),
);

// -------------------------------------------------------------------- progress

final StreamProvider<List<RehearsalWeek>> weeklyRehearsalsProvider =
    StreamProvider<List<RehearsalWeek>>(
  (Ref ref) => ref.watch(rehearsalRepositoryProvider).watchWeekly(),
);

final StreamProvider<int> weeklyStreakProvider = StreamProvider<int>(
  (Ref ref) => ref.watch(rehearsalRepositoryProvider).watchWeeklyStreak(),
);

final StreamProvider<List<RehearsalRow>> recentRehearsalsProvider =
    StreamProvider<List<RehearsalRow>>(
  (Ref ref) => ref.watch(rehearsalRepositoryProvider).watchRecent(),
);

// ------------------------------------------------------- profile & preferences

final StreamProvider<PerformerProfileRow> profileProvider =
    StreamProvider<PerformerProfileRow>(
  (Ref ref) => ref.watch(profileRepositoryProvider).watch(),
);

final StreamProvider<AppPreferenceRow> preferencesProvider =
    StreamProvider<AppPreferenceRow>(
  (Ref ref) => ref.watch(preferencesRepositoryProvider).watch(),
);

// ----------------------------------------------------------------------- notes

final StreamProvider<List<NoteRow>> looseNotesProvider =
    StreamProvider<List<NoteRow>>(
  (Ref ref) => ref.watch(noteRepositoryProvider).watchLoose(),
);

final noteProvider = StreamProvider.family<NoteRow?, int>(
  (Ref ref, int noteId) => ref.watch(noteRepositoryProvider).watchOne(noteId),
);

final noteSearchProvider = StreamProvider.family<List<NoteRow>, String>(
  (Ref ref, String query) => ref.watch(noteRepositoryProvider).watchAll(query: query),
);

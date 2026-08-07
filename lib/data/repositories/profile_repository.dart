import 'package:drift/drift.dart';

import '../app_database.dart';
import '../enums.dart';

/// Reads and writes the performer profile.
///
/// The photo is referenced by file name only. The app's container path changes
/// between installs and OS upgrades, so storing an absolute path would leave a
/// broken image behind; the file lives in the documents directory and is
/// resolved at display time.
class ProfileRepository {
  ProfileRepository(this._db);

  final AppDatabase _db;

  Stream<PerformerProfileRow> watch() => _db.profileRow().watchSingle();

  Future<PerformerProfileRow> read() => _db.profileRow().getSingle();

  Future<void> update({
    String? stageName,
    Discipline? discipline,
    bool clearDiscipline = false,
    String? homeVenue,
    String? bio,
  }) {
    return (_db.update(_db.performerProfiles)
          ..where((PerformerProfiles t) => t.id.equals(1)))
        .write(
      PerformerProfilesCompanion(
        stageName: stageName == null
            ? const Value<String>.absent()
            : Value<String>(stageName.trim()),
        discipline: clearDiscipline
            ? const Value<Discipline?>(null)
            : discipline == null
                ? const Value<Discipline?>.absent()
                : Value<Discipline?>(discipline),
        homeVenue: homeVenue == null
            ? const Value<String?>.absent()
            : Value<String?>(_blankToNull(homeVenue)),
        bio: bio == null ? const Value<String?>.absent() : Value<String?>(_blankToNull(bio)),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  /// Points the profile at a newly saved photo, or clears it when null.
  Future<void> setPhotoFileName(String? fileName) {
    return (_db.update(_db.performerProfiles)
          ..where((PerformerProfiles t) => t.id.equals(1)))
        .write(
      PerformerProfilesCompanion(
        photoFileName: Value<String?>(fileName),
        updatedAt: Value<DateTime>(DateTime.now()),
      ),
    );
  }

  static String? _blankToNull(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}

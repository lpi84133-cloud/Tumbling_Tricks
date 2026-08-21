import 'package:drift/drift.dart';

import '../app_database.dart';

/// Reads and writes app preferences.
class PreferencesRepository {
  PreferencesRepository(this._db);

  final AppDatabase _db;

  Stream<AppPreferenceRow> watch() => _db.preferencesRow().watchSingle();

  Future<AppPreferenceRow> read() => _db.preferencesRow().getSingle();

  Future<void> setSoundEnabled({required bool enabled}) =>
      _write(AppPreferencesCompanion(soundEnabled: Value<bool>(enabled)));

  Future<void> setHapticsEnabled({required bool enabled}) =>
      _write(AppPreferencesCompanion(hapticsEnabled: Value<bool>(enabled)));

  Future<void> setOnboardingCompleted({required bool completed}) =>
      _write(AppPreferencesCompanion(onboardingCompleted: Value<bool>(completed)));

  Future<void> setDefaultTargetSeconds(int seconds) => _write(
    AppPreferencesCompanion(
      defaultTargetSeconds: Value<int>(seconds.clamp(30, 60 * 60)),
    ),
  );

  Future<void> setDecayEnabled({required bool enabled}) =>
      _write(AppPreferencesCompanion(decayEnabled: Value<bool>(enabled)));

  /// Updates the rehearsal reminder.
  ///
  /// [weekdayMask] carries one bit per ISO weekday with bit 0 for Monday. An
  /// enabled reminder with no days selected makes no sense, so it is stored as
  /// disabled instead.
  Future<void> setReminder({
    required bool enabled,
    required int hour,
    required int minute,
    required int weekdayMask,
  }) {
    final int mask = weekdayMask & 0x7F;
    return _write(
      AppPreferencesCompanion(
        reminderEnabled: Value<bool>(enabled && mask != 0),
        reminderHour: Value<int>(hour.clamp(0, 23)),
        reminderMinute: Value<int>(minute.clamp(0, 59)),
        reminderWeekdayMask: Value<int>(mask),
      ),
    );
  }

  /// Updates the daily showtime nudge.
  ///
  /// Independent of [setReminder]: the two reminders answer different
  /// questions (a rehearsal schedule vs. a once-a-day nudge) and are stored,
  /// scheduled and cancelled on their own tracks.
  Future<void> setDailyReminder({
    required bool enabled,
    required int hour,
    required int minute,
  }) {
    return _write(
      AppPreferencesCompanion(
        dailyReminderEnabled: Value<bool>(enabled),
        dailyReminderHour: Value<int>(hour.clamp(0, 23)),
        dailyReminderMinute: Value<int>(minute.clamp(0, 59)),
      ),
    );
  }

  Future<void> _write(AppPreferencesCompanion values) =>
      (_db.update(_db.appPreferences)..where((AppPreferences t) => t.id.equals(1)))
          .write(values);
}

/// Weekday helpers for the reminder bitmask.
extension ReminderDays on AppPreferenceRow {
  bool remindsOn(int isoWeekday) =>
      reminderWeekdayMask & (1 << (isoWeekday - DateTime.monday)) != 0;

  /// ISO weekdays the reminder fires on, Monday first.
  List<int> get reminderWeekdays => <int>[
    for (int day = DateTime.monday; day <= DateTime.sunday; day++)
      if (remindsOn(day)) day,
  ];
}

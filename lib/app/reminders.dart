import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/app_database.dart';
import '../data/providers.dart';
import '../data/repositories/preferences_repository.dart';

/// Schedules the weekly rehearsal reminder.
///
/// Everything is local: the notification is built on the device from the days
/// and time the user chose, and nothing about their acts leaves it. Permission
/// is requested only when a reminder is switched on, and if it is refused the
/// preference is written back to off so the UI never claims a reminder is
/// active when iOS will not deliver it.
class ReminderService {
  ReminderService(this._ref);

  final Ref _ref;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _initialised = false;

  /// One id per weekday keeps rescheduling simple: cancel the range, then write
  /// back only the days that are still selected.
  static const int _idBase = 4100;

  static const String _channelId = 'rehearsal_reminders';

  Future<void> _ensureInitialised() async {
    if (_initialised) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await _localTimeZone()));

    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(
          // Nothing is requested up front — see [requestPermission].
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    _initialised = true;
  }

  /// Asks iOS for permission, returning whether it was granted.
  Future<bool> requestPermission() async {
    await _ensureInitialised();

    final IOSFlutterLocalNotificationsPlugin? ios = _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: false, sound: true) ??
          false;
    }

    final AndroidFlutterLocalNotificationsPlugin? android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    return false;
  }

  /// Brings the scheduled notifications in line with the stored preferences.
  Future<void> sync() async {
    await _ensureInitialised();

    final AppPreferenceRow prefs = await _ref.read(preferencesRepositoryProvider).read();

    for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
      await _plugin.cancel(id: _idBase + day);
    }

    if (!prefs.reminderEnabled) return;

    for (final int weekday in prefs.reminderWeekdays) {
      await _plugin.zonedSchedule(
        id: _idBase + weekday,
        title: 'Rehearsal time',
        body: 'Open Tumbling Tricks and log what you work today.',
        scheduledDate:
            _nextInstanceOf(weekday, prefs.reminderHour, prefs.reminderMinute),
        notificationDetails: const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            _channelId,
            'Rehearsal reminders',
            channelDescription: 'The weekly rehearsal reminder you set in the app.',
            importance: Importance.defaultImportance,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // Repeats on the same weekday and time every week.
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelAll() async {
    await _ensureInitialised();
    await _plugin.cancelAll();
  }

  /// The next occurrence of [weekday] at [hour]:[minute], in local time.
  static tz.TZDateTime _nextInstanceOf(int weekday, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime candidate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (candidate.weekday != weekday || !candidate.isAfter(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  /// Resolves the device's zone name, falling back to UTC.
  ///
  /// A wrong fallback would only shift the reminder, never break the app, so
  /// this stays deliberately simple rather than pulling in another dependency.
  static Future<String> _localTimeZone() async {
    try {
      final Duration offset = DateTime.now().timeZoneOffset;
      for (final tz.Location location in tz.timeZoneDatabase.locations.values) {
        final tz.TZDateTime probe = tz.TZDateTime.now(location);
        if (probe.timeZoneOffset == offset) return location.name;
      }
    } catch (_) {
      // Falls through to UTC.
    }
    return 'UTC';
  }
}

final Provider<ReminderService> reminderProvider = Provider<ReminderService>(
  ReminderService.new,
);

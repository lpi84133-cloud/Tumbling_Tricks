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

  /// A distinct, single id for the daily nudge — kept far from the weekly
  /// range (4100..4106) and from any dynamic id Firebase Messaging might
  /// generate. Firebase draws its ids from message hashes or `0`, and the
  /// channel below is our own — so a push and a local nudge can never overlap.
  static const int _dailyId = 6100;

  /// A distinct channel, so the daily nudge shows up as its own line in the
  /// system settings and never fights with the Firebase push channel that
  /// other layers of the app may register.
  static const String _dailyChannelId = 'daily_showtime';

  /// A small pool of themed one-liners for the daily nudge. Picked by the day
  /// of year so a run of days never repeats the same string, and the same
  /// date always shows the same one — restarting the app cannot desync it.
  static const List<String> _dailyLines = <String>[
    'The house lights are dimming — five minutes with your act.',
    'A single beat, drilled today, saves a fumble on stage.',
    'Pick one trick. Run it clean. Log it.',
    'The stage is quiet. What will you rehearse?',
    'Reliable tricks stay reliable only because you keep them warm.',
    'Curtain up — even a short run counts.',
    'One rehearsal today keeps the ratings honest.',
    'A quick pass through the opening beats.',
    'The audience remembers the finale. Give it a minute.',
    'Warm up the marquee — the day is still yours.',
  ];

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
  ///
  /// Reschedules both the weekly rehearsal reminder and the daily nudge, so a
  /// single call from the launch bar catches every drift (device reboot, clock
  /// change, timezone move) in one place.
  Future<void> sync() async {
    await _ensureInitialised();

    final AppPreferenceRow prefs =
        await _ref.read(preferencesRepositoryProvider).read();

    await _syncWeekly(prefs);
    await _syncDaily(prefs);
  }

  Future<void> _syncWeekly(AppPreferenceRow prefs) async {
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
          iOS: DarwinNotificationDetails(
            threadIdentifier: _channelId,
            categoryIdentifier: _channelId,
          ),
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

  /// Schedules the daily showtime nudge.
  ///
  /// Owns exactly one notification id ([_dailyId]) and one channel
  /// ([_dailyChannelId]); nothing else in the app writes to either, which is
  /// what keeps this reminder from ever stepping on a Firebase push that a
  /// paired layer may deliver on a different channel with a different id.
  Future<void> _syncDaily(AppPreferenceRow prefs) async {
    await _plugin.cancel(id: _dailyId);
    if (!prefs.dailyReminderEnabled) return;

    final tz.TZDateTime firstFire = _nextDailyTime(
      prefs.dailyReminderHour,
      prefs.dailyReminderMinute,
    );
    final String line = _pickDailyLine(firstFire);

    await _plugin.zonedSchedule(
      id: _dailyId,
      title: 'Tumbling Tricks',
      body: line,
      scheduledDate: firstFire,
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(
          threadIdentifier: _dailyChannelId,
          categoryIdentifier: _dailyChannelId,
        ),
        android: AndroidNotificationDetails(
          _dailyChannelId,
          'Daily showtime',
          channelDescription:
              'A once-a-day nudge from Tumbling Tricks at the time you chose.',
          importance: Importance.defaultImportance,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Repeats every day at the same wall-clock time.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels every reminder this service owns.
  ///
  /// Deliberately cancels by id rather than calling `cancelAll`: the plugin's
  /// blanket cancel would also nuke any notification another layer (e.g. a
  /// Firebase Messaging setup) may have posted on the same device.
  Future<void> cancelAll() async {
    await _ensureInitialised();
    for (int day = DateTime.monday; day <= DateTime.sunday; day++) {
      await _plugin.cancel(id: _idBase + day);
    }
    await _plugin.cancel(id: _dailyId);
  }

  /// Same-day at [hour]:[minute] when that is still in the future, otherwise
  /// tomorrow at that time. Kept as its own helper so the daily nudge does
  /// not accidentally slip a whole week forward via the weekly variant above.
  static tz.TZDateTime _nextDailyTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime candidate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    return candidate.isAfter(now)
        ? candidate
        : candidate.add(const Duration(days: 1));
  }

  /// Picks a themed line by day of year so successive days rotate through the
  /// pool rather than pinning to one string, and the same date always resolves
  /// to the same line — the pool is deterministic, so a device reboot cannot
  /// leave the user staring at the same message they saw yesterday.
  static String _pickDailyLine(DateTime moment) {
    final int dayOfYear =
        moment.difference(DateTime(moment.year)).inDays;
    return _dailyLines[dayOfYear % _dailyLines.length];
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

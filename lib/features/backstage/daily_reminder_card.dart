import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/reminders.dart';
import '../../data/app_database.dart';
import '../../data/providers.dart';
import '../../design/design.dart';

/// The daily showtime nudge.
///
/// A single reminder that fires once a day at the time the user picks. Owns
/// nothing else — the weekly rehearsal reminder has its own card and its own
/// switch, so the two never trip over each other.
class DailyReminderCard extends ConsumerStatefulWidget {
  const DailyReminderCard({super.key});

  @override
  ConsumerState<DailyReminderCard> createState() => _DailyReminderCardState();
}

class _DailyReminderCardState extends ConsumerState<DailyReminderCard> {
  bool _busy = false;
  bool _permissionRefused = false;

  Future<void> _toggle(AppPreferenceRow prefs, bool wanted) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _permissionRefused = false;
    });

    try {
      if (wanted) {
        final bool granted = await ref.read(reminderProvider).requestPermission();
        if (!granted) {
          if (mounted) setState(() => _permissionRefused = true);
          return;
        }
      }

      await ref.read(preferencesRepositoryProvider).setDailyReminder(
        enabled: wanted,
        hour: prefs.dailyReminderHour,
        minute: prefs.dailyReminderMinute,
      );
      await ref.read(reminderProvider).sync();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickTime(AppPreferenceRow prefs) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: prefs.dailyReminderHour,
        minute: prefs.dailyReminderMinute,
      ),
      helpText: 'When should the daily nudge arrive?',
    );
    if (picked == null) return;

    await ref.read(preferencesRepositoryProvider).setDailyReminder(
      enabled: prefs.dailyReminderEnabled,
      hour: picked.hour,
      minute: picked.minute,
    );
    await ref.read(reminderProvider).sync();
  }

  @override
  Widget build(BuildContext context) {
    final AppPreferenceRow? prefs = ref.watch(preferencesProvider).value;
    if (prefs == null) return const SizedBox.shrink();

    return PanelCard(
      padding: const EdgeInsets.symmetric(horizontal: Gap.sm, vertical: Gap.xs),
      child: Column(
        children: <Widget>[
          SwitchListTile(
            value: prefs.dailyReminderEnabled,
            title: const Text('Daily showtime'),
            subtitle: Text(
              prefs.dailyReminderEnabled
                  ? 'A once-a-day nudge, delivered locally at the time you set.'
                  : 'A once-a-day nudge to keep the routine warm.',
            ),
            onChanged: _busy ? null : (bool value) => _toggle(prefs, value),
          ),
          if (_permissionRefused)
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.md, 0, Gap.md, Gap.md),
              child: Text(
                'iOS declined notifications for this app. Everything else keeps '
                'working; you can allow them later in the Settings app.',
                style: AppText.caption.copyWith(color: Palette.caution),
              ),
            ),
          if (prefs.dailyReminderEnabled) ...<Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Gap.md),
              child: GoldRule(),
            ),
            ListTile(
              leading: const Icon(Icons.access_time_rounded, color: Palette.brass),
              title: const Text('Time'),
              trailing: Text(
                '${prefs.dailyReminderHour.toString().padLeft(2, '0')}:'
                '${prefs.dailyReminderMinute.toString().padLeft(2, '0')}',
                style: AppText.timecode,
              ),
              onTap: () => _pickTime(prefs),
            ),
          ],
        ],
      ),
    );
  }
}

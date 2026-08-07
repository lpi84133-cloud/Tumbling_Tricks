import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/reminders.dart';
import '../../data/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/preferences_repository.dart';
import '../../design/design.dart';

/// The rehearsal reminder settings.
///
/// The switch does not simply flip a flag: turning it on asks iOS for permission
/// first, and if that is refused the preference is left off, so the card can
/// never show an active reminder that will not arrive.
class ReminderCard extends ConsumerStatefulWidget {
  const ReminderCard({super.key});

  @override
  ConsumerState<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends ConsumerState<ReminderCard> {
  bool _busy = false;
  bool _permissionRefused = false;

  static const List<String> _dayLabels = <String>[
    'M', 'T', 'W', 'T', 'F', 'S', 'S',
  ];

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

      await ref.read(preferencesRepositoryProvider).setReminder(
        enabled: wanted,
        hour: prefs.reminderHour,
        minute: prefs.reminderMinute,
        // Turning the reminder on with nothing selected would store as
        // disabled, so a first-time switch-on seeds the working week.
        weekdayMask: prefs.reminderWeekdayMask == 0 ? 0x1F : prefs.reminderWeekdayMask,
      );
      await ref.read(reminderProvider).sync();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleDay(AppPreferenceRow prefs, int isoWeekday) async {
    final int bit = 1 << (isoWeekday - DateTime.monday);
    final int mask = prefs.reminderWeekdayMask ^ bit;

    await ref.read(preferencesRepositoryProvider).setReminder(
      enabled: prefs.reminderEnabled,
      hour: prefs.reminderHour,
      minute: prefs.reminderMinute,
      weekdayMask: mask,
    );
    await ref.read(reminderProvider).sync();
  }

  Future<void> _pickTime(AppPreferenceRow prefs) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: prefs.reminderHour, minute: prefs.reminderMinute),
      helpText: 'When should the reminder arrive?',
    );
    if (picked == null) return;

    await ref.read(preferencesRepositoryProvider).setReminder(
      enabled: prefs.reminderEnabled,
      hour: picked.hour,
      minute: picked.minute,
      weekdayMask: prefs.reminderWeekdayMask,
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
            value: prefs.reminderEnabled,
            title: const Text('Rehearsal reminder'),
            subtitle: Text(
              prefs.reminderEnabled
                  ? 'Scheduled on this device — arrives with or without a connection.'
                  : 'A weekly nudge to log what you worked.',
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
          if (prefs.reminderEnabled) ...<Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Gap.md),
              child: GoldRule(),
            ),
            ListTile(
              leading: const Icon(Icons.schedule_rounded, color: Palette.brass),
              title: const Text('Time'),
              trailing: Text(
                '${prefs.reminderHour.toString().padLeft(2, '0')}:'
                '${prefs.reminderMinute.toString().padLeft(2, '0')}',
                style: AppText.timecode,
              ),
              onTap: () => _pickTime(prefs),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.md, 0, Gap.md, Gap.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('DAYS', style: AppText.micro),
                  Gap.vSm,
                  Row(
                    children: <Widget>[
                      for (int day = DateTime.monday; day <= DateTime.sunday; day++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: Gap.xs),
                            child: _DayToggle(
                              label: _dayLabels[day - 1],
                              selected: prefs.remindsOn(day),
                              onTap: () => _toggleDay(prefs, day),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DayToggle extends StatelessWidget {
  const _DayToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 26,
      child: AnimatedContainer(
        duration: Motion.quick,
        height: Layout.minTouch,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: Corners.chip,
          color: selected ? Palette.brass.withValues(alpha: 0.16) : null,
          border: Border.all(
            color: selected ? Palette.brass : Palette.hairline,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: AppText.action.copyWith(
            color: selected ? Palette.brassGlow : Palette.textTertiary,
          ),
        ),
      ),
    );
  }
}

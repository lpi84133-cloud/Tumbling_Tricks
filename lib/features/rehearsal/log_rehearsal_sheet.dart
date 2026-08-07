import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../design/design.dart';
import '../shared/format.dart';
import '../shared/sheet_shell.dart';

/// Records one rehearsal session against an act.
///
/// Logging also credits every trick currently in that act's run order, which is
/// why the sheet asks what was worked rather than making the user tick tricks
/// off one at a time.
class LogRehearsalSheet extends ConsumerStatefulWidget {
  const LogRehearsalSheet({required this.actId, required this.actTitle, super.key});

  final int actId;
  final String actTitle;

  static Future<bool> show(
    BuildContext context, {
    required int actId,
    required String actTitle,
  }) async {
    final bool? logged = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          LogRehearsalSheet(actId: actId, actTitle: actTitle),
    );
    return logged ?? false;
  }

  @override
  ConsumerState<LogRehearsalSheet> createState() => _LogRehearsalSheetState();
}

class _LogRehearsalSheetState extends ConsumerState<LogRehearsalSheet> {
  final TextEditingController _focus = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  DateTime _happenedAt = DateTime.now();
  int _minutes = 45;
  int _confidence = 3;
  bool _saving = false;

  static const List<int> _presets = <int>[15, 30, 45, 60, 90, 120];

  static const List<String> _confidenceLabels = <String>[
    'Rough — it fell apart',
    'Shaky — several drops',
    'Solid — a clean run',
    'Strong — barely a wobble',
    'Show-ready — I would perform it tonight',
  ];

  @override
  void dispose() {
    _focus.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _happenedAt,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      helpText: 'When was the session?',
    );
    if (picked != null) {
      setState(() => _happenedAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _happenedAt.hour,
        _happenedAt.minute,
      ));
    }
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() => _saving = true);

    await ref.read(rehearsalRepositoryProvider).log(
      actId: widget.actId,
      happenedAt: _happenedAt,
      minutes: _minutes,
      confidence: _confidence,
      focus: _focus.text,
      notes: _notes.text,
    );

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return SheetShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
                  Text('Log a rehearsal', style: AppText.screenTitle),
                  Gap.vXs,
                  Text(widget.actTitle, style: AppText.caption),
                  Gap.vXl,
                  PanelCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Gap.lg,
                      vertical: Gap.sm,
                    ),
                    onTap: _pickDate,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.event_outlined, color: Palette.brass, size: 20),
                        Gap.hMd,
                        Expanded(
                          child: Text(
                            '${Fmt.relativeDay(_happenedAt)} · ${Fmt.date(_happenedAt)}',
                            style: AppText.bodyStrong,
                          ),
                        ),
                        Text('CHANGE', style: AppText.micro.copyWith(color: Palette.brass)),
                      ],
                    ),
                  ),
                  Gap.vXl,
                  SectionHeading(label: 'How long — ${Fmt.minutes(_minutes)}'),
                  Gap.vMd,
                  Wrap(
                    spacing: Gap.sm,
                    runSpacing: Gap.sm,
                    children: <Widget>[
                      for (final int preset in _presets)
                        ChoiceChip(
                          label: Text(Fmt.minutes(preset)),
                          selected: _minutes == preset,
                          onSelected: (_) => setState(() => _minutes = preset),
                        ),
                    ],
                  ),
                  Slider(
                    value: _minutes.toDouble(),
                    min: 5,
                    max: 240,
                    divisions: 47,
                    label: Fmt.minutes(_minutes),
                    onChanged: (double value) =>
                        setState(() => _minutes = value.round()),
                  ),
                  Gap.vLg,
                  const SectionHeading(label: 'How did it feel?'),
                  Gap.vMd,
                  Row(
                    children: <Widget>[
                      for (int score = 1; score <= 5; score++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: Gap.xs),
                            child: _ScoreButton(
                              score: score,
                              selected: _confidence == score,
                              onTap: () => setState(() => _confidence = score),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Gap.vSm,
                  Text(_confidenceLabels[_confidence - 1], style: AppText.caption),
                  Gap.vXl,
                  TextField(
                    controller: _focus,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 90,
                    decoration: const InputDecoration(
                      labelText: 'What did you work?',
                      hintText: 'Finale sequence, transitions…',
                    ),
                  ),
                  Gap.vSm,
                  TextField(
                    controller: _notes,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  Gap.vXl,
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _saving ? null : () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                      ),
                      Gap.hMd,
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _saving ? null : _submit,
                          child: Text(_saving ? 'SAVING…' : 'LOG THE SESSION'),
                        ),
                      ),
                    ],
                  ),
        ],
      ),
    );
  }
}

class _ScoreButton extends StatelessWidget {
  const _ScoreButton({
    required this.score,
    required this.selected,
    required this.onTap,
  });

  final int score;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 32,
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
          '$score',
          style: AppText.timecode.copyWith(
            color: selected ? Palette.brassGlow : Palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

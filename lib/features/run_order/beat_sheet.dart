import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/run_order_repository.dart';
import '../../design/design.dart';
import '../shared/format.dart';
import '../shared/sheet_shell.dart';

/// Adds a one-off beat, or edits an existing one.
///
/// The same form serves both because a beat is only four fields, and splitting
/// them would mean two places to keep the duration rules in step.
class BeatSheet extends ConsumerStatefulWidget {
  const BeatSheet({required this.blockId, this.beat, super.key});

  final int blockId;

  /// Null when adding.
  final RunOrderItemRow? beat;

  static Future<void> add(BuildContext context, int blockId) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => BeatSheet(blockId: blockId),
    );
  }

  static Future<void> edit(BuildContext context, RunOrderItemRow beat) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          BeatSheet(blockId: beat.blockId, beat: beat),
    );
  }

  @override
  ConsumerState<BeatSheet> createState() => _BeatSheetState();
}

class _BeatSheetState extends ConsumerState<BeatSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _cue;

  late int _seconds;
  late bool _confirmed;
  bool _saving = false;

  bool get _isEditing => widget.beat != null;

  @override
  void initState() {
    super.initState();
    _label = TextEditingController(text: widget.beat?.label ?? '');
    _cue = TextEditingController(text: widget.beat?.cueNote ?? '');
    _seconds = widget.beat?.seconds ?? 15;
    _confirmed = widget.beat?.isConfirmed ?? false;
  }

  @override
  void dispose() {
    _label.dispose();
    _cue.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false) || _saving) return;
    setState(() => _saving = true);

    final RunOrderRepository repo = ref.read(runOrderRepositoryProvider);
    if (_isEditing) {
      await repo.updateBeat(
        beatId: widget.beat!.id,
        label: _label.text,
        cueNote: _cue.text,
        seconds: _seconds,
        isConfirmed: _confirmed,
      );
    } else {
      await repo.addBeat(
        blockId: widget.blockId,
        label: _label.text,
        cueNote: _cue.text,
        seconds: _seconds,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref.read(runOrderRepositoryProvider).deleteBeat(widget.beat!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SheetShell(
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_isEditing ? 'Edit beat' : 'Add a beat', style: AppText.screenTitle),
            Gap.vXs,
            Text(
              _isEditing
                  ? 'Timing and cues for this moment of the act.'
                  : 'A moment that is not a catalogued trick — a bow, a set change, '
                      'a held pose.',
              style: AppText.caption,
            ),
            Gap.vXl,
            TextFormField(
              controller: _label,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 90,
              decoration: const InputDecoration(labelText: 'What happens', counterText: ''),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty) ? 'Describe the beat' : null,
            ),
            Gap.vLg,
            SectionHeading(label: 'How long — ${Fmt.duration(_seconds)}'),
            Slider(
              value: _seconds.toDouble().clamp(3, 300),
              min: 3,
              max: 300,
              divisions: 99,
              label: Fmt.duration(_seconds),
              onChanged: (double value) => setState(() => _seconds = value.round()),
            ),
            Gap.vSm,
            TextFormField(
              controller: _cue,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Cue note (optional)',
                helperText: 'What the operator or your partner needs to know.',
                alignLabelWithHint: true,
              ),
            ),
            Gap.vLg,
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _confirmed,
              title: const Text('Choreographed and timed'),
              subtitle: const Text('Counts towards the act\'s readiness.'),
              onChanged: (bool value) => setState(() => _confirmed = value),
            ),
            Gap.vLg,
            Row(
              children: <Widget>[
                if (_isEditing)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Palette.danger),
                      onPressed: _saving ? null : _delete,
                      child: const Text('REMOVE'),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving ? null : () => Navigator.of(context).pop(),
                      child: const Text('CANCEL'),
                    ),
                  ),
                Gap.hMd,
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: Text(_isEditing ? 'SAVE' : 'ADD THE BEAT'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

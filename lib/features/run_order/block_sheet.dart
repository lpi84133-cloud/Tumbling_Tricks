import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../data/repositories/run_order_repository.dart';
import '../../design/design.dart';
import '../shared/format.dart';
import '../shared/sheet_shell.dart';

/// Adds a structural block to the run order, or edits one.
class BlockSheet extends ConsumerStatefulWidget {
  const BlockSheet({required this.actId, this.block, super.key});

  final int actId;
  final ActBlockRow? block;

  static Future<void> add(BuildContext context, int actId) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => BlockSheet(actId: actId),
    );
  }

  static Future<void> edit(BuildContext context, ActBlockRow block) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          BlockSheet(actId: block.actId, block: block),
    );
  }

  @override
  ConsumerState<BlockSheet> createState() => _BlockSheetState();
}

class _BlockSheetState extends ConsumerState<BlockSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _intent;

  late BlockRole _role;
  late int _planned;
  bool _saving = false;

  bool get _isEditing => widget.block != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.block?.title ?? '');
    _intent = TextEditingController(text: widget.block?.intent ?? '');
    _role = widget.block?.role ?? BlockRole.main;
    _planned = widget.block?.plannedSeconds ?? 45;
  }

  @override
  void dispose() {
    _title.dispose();
    _intent.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false) || _saving) return;
    setState(() => _saving = true);

    final RunOrderRepository repo = ref.read(runOrderRepositoryProvider);
    if (_isEditing) {
      await repo.updateBlock(
        blockId: widget.block!.id,
        title: _title.text,
        intent: _intent.text,
        plannedSeconds: _planned,
        role: _role,
      );
    } else {
      await repo.addBlock(
        actId: widget.actId,
        role: _role,
        title: _title.text,
        intent: _intent.text,
        plannedSeconds: _planned,
      );
    }

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
            Text(_isEditing ? 'Edit block' : 'Add a block',
                style: AppText.screenTitle),
            Gap.vXs,
            Text(
              'A block is a section of the act. Beats go inside it.',
              style: AppText.caption,
            ),
            Gap.vXl,
            const SectionHeading(label: 'Role in the act'),
            Gap.vMd,
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: <Widget>[
                for (final BlockRole role in BlockRole.values)
                  ChoiceChip(
                    label: Text(role.label),
                    selected: _role == role,
                    onSelected: (_) => setState(() => _role = role),
                  ),
              ],
            ),
            Gap.vSm,
            Text(_role.blurb, style: AppText.caption),
            Gap.vXl,
            TextFormField(
              controller: _title,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 90,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: _role.label,
                counterText: '',
              ),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty) ? 'Name the block' : null,
            ),
            Gap.vLg,
            SectionHeading(label: 'Intended length — ${Fmt.duration(_planned)}'),
            Slider(
              value: _planned.toDouble().clamp(10, 600),
              min: 10,
              max: 600,
              divisions: 59,
              label: Fmt.duration(_planned),
              onChanged: (double value) => setState(() => _planned = value.round()),
            ),
            Text(
              'An estimate to aim at. The real length comes from the beats you add.',
              style: AppText.micro,
            ),
            Gap.vLg,
            TextFormField(
              controller: _intent,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'What this section has to achieve',
                alignLabelWithHint: true,
              ),
            ),
            Gap.vXl,
            Row(
              children: <Widget>[
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
                    child: Text(_isEditing ? 'SAVE' : 'ADD THE BLOCK'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/format.dart';
import '../shared/sheet_shell.dart';

/// Collects the few things needed to open a new act, then creates it.
///
/// Everything else about an act can be edited later, so this asks only for what
/// the run-order template genuinely needs: a name, a target running time and an
/// emblem to recognise it by.
class NewActSheet extends ConsumerStatefulWidget {
  const NewActSheet({super.key});

  /// Returns the new act's id, or `null` if the user backed out.
  static Future<int?> show(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const NewActSheet(),
    );
  }

  @override
  ConsumerState<NewActSheet> createState() => _NewActSheetState();
}

class _NewActSheetState extends ConsumerState<NewActSheet> {
  final TextEditingController _title = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  ActEmblem _emblem = ActEmblem.tent;
  int _targetSeconds = 240;
  bool _saving = false;

  static const List<int> _durations = <int>[120, 180, 240, 300, 420, 600];

  @override
  void initState() {
    super.initState();
    final int? preferred = ref.read(preferencesProvider).value?.defaultTargetSeconds;
    if (preferred != null) _targetSeconds = preferred;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false) || _saving) return;
    setState(() => _saving = true);

    final int id = await ref.read(actRepositoryProvider).create(
      title: _title.text,
      targetSeconds: _targetSeconds,
      emblem: _emblem,
    );

    if (mounted) Navigator.of(context).pop(id);
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
            Center(child: Image.asset(TimelineArt.flourishSmall, height: 18)),
            Gap.vLg,
            Text('New act', style: AppText.screenTitle),
            Gap.vXs,
            Text(
              'A run order, a checklist and a stage plot are set up for you.',
              style: AppText.caption,
            ),
            Gap.vXl,
            TextFormField(
              controller: _title,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              maxLength: 90,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Closing set, Gala opener…',
                counterText: '',
              ),
              validator: (String? value) => (value == null || value.trim().isEmpty)
                  ? 'Give the act a name'
                  : null,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            Gap.vLg,
            const SectionHeading(label: 'Target running time'),
            Gap.vMd,
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: <Widget>[
                for (final int seconds in _durations)
                  ChoiceChip(
                    label: Text(Fmt.duration(seconds)),
                    selected: _targetSeconds == seconds,
                    onSelected: (_) => setState(() => _targetSeconds = seconds),
                  ),
              ],
            ),
            Gap.vXl,
            const SectionHeading(label: 'Emblem'),
            Gap.vMd,
            Row(
              children: <Widget>[
                for (final ActEmblem emblem in ActEmblem.values)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: Gap.sm),
                      child: _EmblemChoice(
                        emblem: emblem,
                        selected: _emblem == emblem,
                        onTap: () => setState(() => _emblem = emblem),
                      ),
                    ),
                  ),
              ],
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
                    child: Text(_saving ? 'OPENING…' : 'OPEN THE ACT'),
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

class _EmblemChoice extends StatelessWidget {
  const _EmblemChoice({
    required this.emblem,
    required this.selected,
    required this.onTap,
  });

  final ActEmblem emblem;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: emblem.label,
      child: InkResponse(
        onTap: onTap,
        radius: 34,
        child: AnimatedContainer(
          duration: Motion.quick,
          padding: const EdgeInsets.all(Gap.sm),
          decoration: BoxDecoration(
            borderRadius: Corners.card,
            color: selected ? Palette.brass.withValues(alpha: 0.14) : null,
            border: Border.all(
              color: selected ? Palette.brass : Palette.hairline,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Image.asset(emblem.medallion, height: 34),
        ),
      ),
    );
  }
}

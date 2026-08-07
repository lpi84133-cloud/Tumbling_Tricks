import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/format.dart';
import '../shared/sheet_shell.dart';

/// A sheet wrapper that keeps the two trick flows — reading one and writing one
/// — in the same place, since they share most of their chrome.
abstract final class TrickSheet {
  static Future<void> open(BuildContext context, int trickId) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => SheetShell(child: _TrickDetail(trickId: trickId)),
    );
  }

  static Future<int?> create(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => const SheetShell(child: _TrickForm()),
    );
  }
}

class _TrickDetail extends ConsumerWidget {
  const _TrickDetail({required this.trickId});

  final int trickId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TrickRow? trick = ref.watch(trickProvider(trickId)).value;
    if (trick == null) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(trick.discipline.icon, height: 44),
            Gap.hLg,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(trick.name, style: AppText.cardTitle),
                  Gap.vXxs,
                  Text(
                    '${trick.discipline.label} · difficulty ${trick.difficulty}/5 · '
                    '${Fmt.duration(trick.typicalSeconds)}',
                    style: AppText.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (trick.summary.isNotEmpty) ...<Widget>[
          Gap.vLg,
          Text(trick.summary, style: AppText.body),
        ],
        if (trick.setupNote != null) ...<Widget>[
          Gap.vXl,
          const SectionHeading(label: 'Setup'),
          Gap.vSm,
          Text(trick.setupNote!, style: AppText.body),
        ],
        if (trick.safetyNote != null) ...<Widget>[
          Gap.vXl,
          PanelCard(
            accent: Palette.caution,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(ChecklistArt.safety, height: 26),
                Gap.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('SAFETY',
                          style: AppText.micro.copyWith(color: Palette.caution)),
                      Gap.vXxs,
                      Text(trick.safetyNote!, style: AppText.body),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        Gap.vXl,
        const SectionHeading(label: 'How reliable is it?'),
        Gap.vMd,
        Wrap(
          spacing: Gap.sm,
          runSpacing: Gap.sm,
          children: <Widget>[
            for (final Mastery mastery in Mastery.values)
              ChoiceChip(
                label: Text(mastery.label),
                avatar: Image.asset(mastery.badge, height: 16),
                selected: trick.mastery == mastery,
                onSelected: (_) =>
                    ref.read(trickRepositoryProvider).setMastery(trick.id, mastery),
              ),
          ],
        ),
        Gap.vSm,
        Text(trick.mastery.blurb, style: AppText.caption),
        Gap.vXl,
        Row(
          children: <Widget>[
            if (trick.timesRehearsed > 0)
              Expanded(
                child: Text(
                  'Drilled ${trick.timesRehearsed}× · last '
                  '${Fmt.relativeDay(trick.lastRehearsedAt!).toLowerCase()}',
                  style: AppText.micro,
                ),
              )
            else
              Expanded(
                child: Text(
                  'Rehearsal sessions credit every trick in the act\'s run order.',
                  style: AppText.micro,
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('DONE'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrickForm extends ConsumerStatefulWidget {
  const _TrickForm();

  @override
  ConsumerState<_TrickForm> createState() => _TrickFormState();
}

class _TrickFormState extends ConsumerState<_TrickForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _safety = TextEditingController();

  Discipline _discipline = Discipline.acrobatics;
  int _difficulty = 2;
  int _seconds = 12;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _summary.dispose();
    _safety.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false) || _saving) return;
    setState(() => _saving = true);

    final int id = await ref.read(trickRepositoryProvider).create(
      name: _name.text,
      discipline: _discipline,
      difficulty: _difficulty,
      summary: _summary.text,
      safetyNote: _safety.text,
      typicalSeconds: _seconds,
    );

    if (mounted) Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Add a trick', style: AppText.screenTitle),
          Gap.vXs,
          Text(
            'It joins the library and can be dropped into any run order.',
            style: AppText.caption,
          ),
          Gap.vXl,
          TextFormField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 80,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (String? value) => (value == null || value.trim().isEmpty)
                ? 'Give the trick a name'
                : null,
          ),
          Gap.vLg,
          const SectionHeading(label: 'Discipline'),
          Gap.vMd,
          Row(
            children: <Widget>[
              for (final Discipline discipline in Discipline.values)
                Expanded(
                  child: InkResponse(
                    onTap: () => setState(() => _discipline = discipline),
                    radius: 40,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
                      child: Column(
                        children: <Widget>[
                          AnimatedOpacity(
                            opacity: _discipline == discipline ? 1 : 0.5,
                            duration: Motion.quick,
                            child: Image.asset(discipline.icon, height: 32),
                          ),
                          Gap.vXs,
                          Text(
                            discipline.label.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: AppText.micro.copyWith(
                              color: _discipline == discipline
                                  ? Palette.brass
                                  : Palette.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Gap.vXl,
          SectionHeading(label: 'Difficulty — $_difficulty of 5'),
          Slider(
            value: _difficulty.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$_difficulty',
            onChanged: (double value) => setState(() => _difficulty = value.round()),
          ),
          SectionHeading(label: 'Time on stage — ${Fmt.duration(_seconds)}'),
          Slider(
            value: _seconds.toDouble(),
            min: 4,
            max: 120,
            divisions: 29,
            label: Fmt.duration(_seconds),
            onChanged: (double value) => setState(() => _seconds = value.round()),
          ),
          Gap.vLg,
          TextFormField(
            controller: _summary,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'What it is',
              alignLabelWithHint: true,
            ),
          ),
          Gap.vLg,
          TextFormField(
            controller: _safety,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Safety notes (optional)',
              helperText: 'Spotting, matting, rigging — shown prominently.',
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
                  child: Text(_saving ? 'SAVING…' : 'ADD TO LIBRARY'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

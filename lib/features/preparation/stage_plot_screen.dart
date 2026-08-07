import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../data/enums.dart';
import '../../data/models/act_summary.dart';
import '../../data/providers.dart';
import '../../data/repositories/preparation_repository.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/act_widgets.dart';
import '../shared/page_frame.dart';
import '../shared/sheet_shell.dart';

/// The act's technical rider: what the venue has to provide, and whether they
/// have agreed to it.
///
/// Presented on aged paper because this is the page that gets shown to a stage
/// manager, and it should read as a document rather than as app furniture.
class StagePlotScreen extends ConsumerWidget {
  const StagePlotScreen({required this.actId, super.key});

  final int actId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<StagePlotItemRow> lines =
        ref.watch(stagePlotProvider(actId)).value ?? const <StagePlotItemRow>[];
    final ActSummary? summary = ref.watch(actSummaryProvider(actId)).value;

    final int confirmed = lines.where((StagePlotItemRow l) => l.isConfirmed).length;

    return PageFrame(
      header: MarqueeHeader(
        eyebrow: summary?.title,
        title: 'Stage Plot',
        crest: Ornaments.crestTent,
        onBack: () => context.pop(),
      ),
      floating: FilledButton.icon(
        onPressed: () => _PlotSheet.add(context, actId),
        icon: const Icon(Icons.add_rounded),
        label: const Text('ADD A LINE'),
      ),
      slivers: <Widget>[
        if (lines.isEmpty)
          PageSliver(
            child: EmptyStage(
              crest: Ornaments.crestTent,
              title: 'No technical needs listed',
              body: 'List the lighting, sound, props and drapes this act needs, '
                  'then tick each line as the venue confirms it.',
              actionLabel: 'Add the first line',
              onAction: () => _PlotSheet.add(context, actId),
            ),
          )
        else ...<Widget>[
          PageSliver(
            child: PanelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$confirmed of ${lines.length} confirmed with the venue',
                      style: AppText.bodyStrong),
                  Gap.vMd,
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: confirmed / lines.length),
                    duration: Motion.normal,
                    curve: Motion.progress,
                    builder: (BuildContext context, double t, _) =>
                        BrassProgressBar(value: t, height: 10),
                  ),
                ],
              ),
            ),
          ),
          PageSliver(
            top: Gap.xl,
            child: PaperCard(
              texture: Papers.linen,
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.lg,
                vertical: Gap.lg,
              ),
              child: PaperInk(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'TECHNICAL RIDER',
                      style: AppText.sectionLabel.copyWith(
                        color: Palette.textOnPaperSoft,
                      ),
                    ),
                    Gap.vSm,
                    for (final StagePlotItemRow line in lines)
                      _PlotRow(line: line),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlotRow extends ConsumerWidget {
  const _PlotRow({required this.line});

  final StagePlotItemRow line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _PlotSheet.edit(context, line),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(line.equipment.icon, height: 26),
            Gap.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    line.label,
                    style: AppText.bodyStrong.copyWith(color: Palette.textOnPaper),
                  ),
                  if (line.spec != null)
                    Text(
                      line.spec!,
                      style: AppText.caption.copyWith(color: Palette.textOnPaperSoft),
                    ),
                ],
              ),
            ),
            Gap.hSm,
            // A stamp rather than a checkbox: on paper, "confirmed" is something
            // that gets marked on the sheet.
            GestureDetector(
              onTap: () => ref
                  .read(preparationRepositoryProvider)
                  .setPlotConfirmed(line.id, confirmed: !line.isConfirmed),
              child: SizedBox(
                width: 44,
                height: 44,
                child: line.isConfirmed
                    ? Image.asset(ProgressArt.checkCrimsonBold, height: 30)
                    : Center(
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Palette.textOnPaperSoft),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlotSheet extends ConsumerStatefulWidget {
  const _PlotSheet({required this.actId, this.line});

  final int actId;
  final StagePlotItemRow? line;

  static Future<void> add(BuildContext context, int actId) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _PlotSheet(actId: actId),
    );
  }

  static Future<void> edit(BuildContext context, StagePlotItemRow line) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _PlotSheet(actId: line.actId, line: line),
    );
  }

  @override
  ConsumerState<_PlotSheet> createState() => _PlotSheetState();
}

class _PlotSheetState extends ConsumerState<_PlotSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _spec;
  late StageEquipment _equipment;

  bool get _isEditing => widget.line != null;

  @override
  void initState() {
    super.initState();
    _label = TextEditingController(text: widget.line?.label ?? '');
    _spec = TextEditingController(text: widget.line?.spec ?? '');
    _equipment = widget.line?.equipment ?? StageEquipment.fresnelLight;
  }

  @override
  void dispose() {
    _label.dispose();
    _spec.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;

    final PreparationRepository repo = ref.read(preparationRepositoryProvider);
    if (_isEditing) {
      await repo.updatePlotLine(
        itemId: widget.line!.id,
        label: _label.text,
        spec: _spec.text,
        equipment: _equipment,
      );
    } else {
      await repo.addPlotLine(
        actId: widget.actId,
        equipment: _equipment,
        label: _label.text,
        spec: _spec.text,
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
            Text(_isEditing ? 'Edit line' : 'Add a line',
                style: AppText.screenTitle),
            Gap.vXl,
            TextFormField(
              controller: _label,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: 'What is needed',
                counterText: '',
              ),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty) ? 'Name the need' : null,
            ),
            Gap.vLg,
            const SectionHeading(label: 'Kind'),
            Gap.vMd,
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: <Widget>[
                for (final StageEquipment equipment in StageEquipment.values)
                  ChoiceChip(
                    label: Text(equipment.label),
                    avatar: Image.asset(equipment.icon, height: 16),
                    selected: _equipment == equipment,
                    onSelected: (_) => setState(() => _equipment = equipment),
                  ),
              ],
            ),
            Gap.vXl,
            TextFormField(
              controller: _spec,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Specification (optional)',
                helperText: 'Channel numbers, colour, position, model.',
                alignLabelWithHint: true,
              ),
            ),
            Gap.vXl,
            Row(
              children: <Widget>[
                if (_isEditing)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(foregroundColor: Palette.danger),
                      onPressed: () async {
                        await ref
                            .read(preparationRepositoryProvider)
                            .deletePlotLine(widget.line!.id);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('REMOVE'),
                    ),
                  )
                else
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('CANCEL'),
                    ),
                  ),
                Gap.hMd,
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(_isEditing ? 'SAVE' : 'ADD'),
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

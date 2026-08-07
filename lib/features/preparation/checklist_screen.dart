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

/// The act's rehearsal checklist, grouped by what part of the show it concerns.
class ChecklistScreen extends ConsumerWidget {
  const ChecklistScreen({required this.actId, super.key});

  final int actId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ChecklistItemRow> items =
        ref.watch(checklistProvider(actId)).value ?? const <ChecklistItemRow>[];
    final ActSummary? summary = ref.watch(actSummaryProvider(actId)).value;

    final int done = items.where((ChecklistItemRow i) => i.isDone).length;

    return PageFrame(
      header: MarqueeHeader(
        eyebrow: summary?.title,
        title: 'Checklist',
        crest: Ornaments.crestStar,
        onBack: () => context.pop(),
        trailing: items.isEmpty
            ? null
            : IconButton(
                onPressed: () => _confirmReset(context, ref),
                icon: const Icon(Icons.restart_alt_rounded),
                color: Palette.brass,
                tooltip: 'Clear all ticks',
              ),
      ),
      floating: FilledButton.icon(
        onPressed: () => _CheckSheet.add(context, actId),
        icon: const Icon(Icons.add_rounded),
        label: const Text('ADD A CHECK'),
      ),
      slivers: <Widget>[
        if (items.isEmpty)
          PageSliver(
            child: EmptyStage(
              crest: Ornaments.crestStar,
              title: 'Nothing to check yet',
              body: 'List what has to be true before this act can go on: music '
                  'cut, costume repaired, props packed, rigging checked.',
              actionLabel: 'Add the first check',
              onAction: () => _CheckSheet.add(context, actId),
            ),
          )
        else ...<Widget>[
          PageSliver(
            child: PanelCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('$done of ${items.length} done',
                            style: AppText.cardTitle),
                      ),
                      if (done == items.length)
                        Image.asset(ProgressArt.sealEmerald, height: 30),
                    ],
                  ),
                  Gap.vMd,
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: done / items.length),
                    duration: Motion.normal,
                    curve: Motion.progress,
                    builder: (BuildContext context, double t, _) =>
                        BrassProgressBar(value: t, height: 10),
                  ),
                ],
              ),
            ),
          ),
          for (final ChecklistCategory category in ChecklistCategory.values)
            if (items.any((ChecklistItemRow i) => i.category == category))
              PageSliver(
                top: Gap.xl,
                child: _CategoryGroup(
                  category: category,
                  items: items
                      .where((ChecklistItemRow i) => i.category == category)
                      .toList(growable: false),
                ),
              ),
        ],
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Clear every tick?'),
        content: Text(
          'The checks stay in the list, but all of them go back to undone. '
          'Useful when the act is being restaged.',
          style: AppText.body,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('KEEP THEM'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
    if (yes ?? false) {
      await ref.read(preparationRepositoryProvider).resetChecklist(actId);
    }
  }
}

class _CategoryGroup extends ConsumerWidget {
  const _CategoryGroup({required this.category, required this.items});

  final ChecklistCategory category;
  final List<ChecklistItemRow> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset(category.icon, height: 22),
            Gap.hSm,
            Expanded(child: SectionHeading(label: category.label)),
          ],
        ),
        Gap.vMd,
        PanelCard(
          padding: const EdgeInsets.symmetric(vertical: Gap.xs),
          child: Column(
            children: <Widget>[
              for (final ChecklistItemRow item in items)
                CheckboxListTile(
                  value: item.isDone,
                  onChanged: (bool? value) => ref
                      .read(preparationRepositoryProvider)
                      .setCheckDone(item.id, done: value ?? false),
                  title: Text(
                    item.label,
                    style: item.isDone
                        ? AppText.body.copyWith(
                            color: Palette.textTertiary,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Palette.textTertiary,
                          )
                        : AppText.body,
                  ),
                  subtitle: item.detail == null
                      ? null
                      : Text(item.detail!, style: AppText.micro),
                  secondary: IconButton(
                    onPressed: () => _CheckSheet.edit(context, item),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: Palette.textTertiary,
                    tooltip: 'Edit',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Adds or edits one check.
class _CheckSheet extends ConsumerStatefulWidget {
  const _CheckSheet({required this.actId, this.item});

  final int actId;
  final ChecklistItemRow? item;

  static Future<void> add(BuildContext context, int actId) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _CheckSheet(actId: actId),
    );
  }

  static Future<void> edit(BuildContext context, ChecklistItemRow item) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) =>
          _CheckSheet(actId: item.actId, item: item),
    );
  }

  @override
  ConsumerState<_CheckSheet> createState() => _CheckSheetState();
}

class _CheckSheetState extends ConsumerState<_CheckSheet> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late final TextEditingController _label;
  late final TextEditingController _detail;
  late ChecklistCategory _category;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    _label = TextEditingController(text: widget.item?.label ?? '');
    _detail = TextEditingController(text: widget.item?.detail ?? '');
    _category = widget.item?.category ?? ChecklistCategory.props;
  }

  @override
  void dispose() {
    _label.dispose();
    _detail.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;

    final PreparationRepository repo = ref.read(preparationRepositoryProvider);
    if (_isEditing) {
      await repo.updateCheck(
        itemId: widget.item!.id,
        label: _label.text,
        detail: _detail.text,
        category: _category,
      );
    } else {
      await repo.addCheck(
        actId: widget.actId,
        category: _category,
        label: _label.text,
        detail: _detail.text,
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
            Text(_isEditing ? 'Edit check' : 'Add a check',
                style: AppText.screenTitle),
            Gap.vXl,
            TextFormField(
              controller: _label,
              autofocus: !_isEditing,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: 'What has to be true',
                counterText: '',
              ),
              validator: (String? value) =>
                  (value == null || value.trim().isEmpty) ? 'Describe the check' : null,
            ),
            Gap.vLg,
            const SectionHeading(label: 'Part of the show'),
            Gap.vMd,
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: <Widget>[
                for (final ChecklistCategory category in ChecklistCategory.values)
                  ChoiceChip(
                    label: Text(category.label),
                    avatar: Image.asset(category.icon, height: 16),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  ),
              ],
            ),
            Gap.vXl,
            TextFormField(
              controller: _detail,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Detail (optional)',
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
                            .deleteCheck(widget.item!.id);
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

import '../enums.dart';

/// What a brand new act starts out with.
///
/// A freshly created act arrives with its five structural blocks, a starter
/// rehearsal checklist and a starter stage plot, so the user lands on something
/// they can immediately work rather than on three empty lists. Every line is
/// editable and deletable.

/// A block in the starter structure. `share` is the fraction of the act's
/// target running time the block is initially estimated at.
class BlockTemplate {
  const BlockTemplate({
    required this.role,
    required this.title,
    required this.intent,
    required this.share,
  });

  final BlockRole role;
  final String title;
  final String intent;
  final double share;
}

const List<BlockTemplate> kBlockTemplate = <BlockTemplate>[
  BlockTemplate(
    role: BlockRole.opening,
    title: 'Opening',
    intent: 'Establish the character and get the room watching.',
    share: 0.15,
  ),
  BlockTemplate(
    role: BlockRole.main,
    title: 'Main element',
    intent: 'The strongest sustained material in the act.',
    share: 0.30,
  ),
  BlockTemplate(
    role: BlockRole.transition,
    title: 'Transition',
    intent: 'Reset props and position without losing the audience.',
    share: 0.10,
  ),
  BlockTemplate(
    role: BlockRole.highlight,
    title: 'Highlight',
    intent: 'The single moment the act is remembered for.',
    share: 0.30,
  ),
  BlockTemplate(
    role: BlockRole.finale,
    title: 'Finale',
    intent: 'Land the ending cleanly and hold for the applause.',
    share: 0.15,
  ),
];

/// A starter checklist line.
class ChecklistTemplate {
  const ChecklistTemplate({
    required this.category,
    required this.label,
    this.detail,
  });

  final ChecklistCategory category;
  final String label;
  final String? detail;
}

const List<ChecklistTemplate> kChecklistTemplate = <ChecklistTemplate>[
  ChecklistTemplate(
    category: ChecklistCategory.music,
    label: 'Track edited to final length',
    detail: 'Cut, fades and any stings in place.',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.music,
    label: 'Backup copy on a second device',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.costume,
    label: 'Costume fitted and repaired',
    detail: 'Move through the whole act in it, not just stand in it.',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.props,
    label: 'Props counted and packed',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.props,
    label: 'Props checked for wear',
    detail: 'Anything consumable replaced and spares counted.',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.lighting,
    label: 'Lighting states agreed with the operator',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.lighting,
    label: 'Cue sheet handed over',
    detail: 'Written cues, not a verbal briefing.',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.stage,
    label: 'Stage surface and marks checked',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.stage,
    label: 'Wing space and clearances confirmed',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.safety,
    label: 'Matting and spotting agreed',
    detail: 'Who spots what, and where they stand.',
  ),
  ChecklistTemplate(
    category: ChecklistCategory.safety,
    label: 'Rigging and equipment inspected',
  ),
];

/// A starter stage plot line.
class StagePlotTemplate {
  const StagePlotTemplate({
    required this.equipment,
    required this.label,
    this.spec,
  });

  final StageEquipment equipment;
  final String label;
  final String? spec;
}

const List<StagePlotTemplate> kStagePlotTemplate = <StagePlotTemplate>[
  StagePlotTemplate(
    equipment: StageEquipment.fresnelLight,
    label: 'General cover',
    spec: 'Warm wash, up on the opening cue.',
  ),
  StagePlotTemplate(
    equipment: StageEquipment.profileLight,
    label: 'Special on the highlight',
    spec: 'Hard edge, centre stage.',
  ),
  StagePlotTemplate(
    equipment: StageEquipment.music,
    label: 'Playback',
    spec: 'Operator holds the cue sheet; track starts on the entrance.',
  ),
  StagePlotTemplate(
    equipment: StageEquipment.curtain,
    label: 'Tabs for the entrance',
  ),
  StagePlotTemplate(
    equipment: StageEquipment.pedestal,
    label: 'Set pieces',
    spec: 'Positions marked on the deck.',
  ),
];

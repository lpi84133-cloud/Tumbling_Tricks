/// Bridges the domain vocabulary to the painted artwork and palette.
///
/// The mappings live in the design layer on purpose: `data/enums.dart` stays a
/// pure description of the domain, and nothing in the data layer imports
/// Flutter.
library;

import 'package:flutter/material.dart';

import '../data/enums.dart';
import '../data/models/act_report.dart';
import 'app_assets.dart';
import 'palette.dart';

extension DisciplineArt on Discipline {
  String get icon => switch (this) {
    Discipline.acrobatics => TrickArt.acrobatics,
    Discipline.cardWork => TrickArt.cards,
    Discipline.illusion => TrickArt.magic,
    Discipline.stagecraft => TrickArt.stage,
  };
}

extension ActStatusArt on ActStatus {
  String get seal => switch (this) {
    ActStatus.draft => StatusArt.draft,
    ActStatus.planning => StatusArt.planning,
    ActStatus.rehearsal => StatusArt.rehearsal,
    ActStatus.ready => StatusArt.ready,
    ActStatus.completed => StatusArt.completed,
  };

  /// Colour used for the accent bar on an act card and for its status chip.
  Color get accent => switch (this) {
    ActStatus.draft => Palette.textTertiary,
    ActStatus.planning => Palette.brassDim,
    ActStatus.rehearsal => Palette.caution,
    ActStatus.ready => Palette.emeraldGlow,
    ActStatus.completed => Palette.brass,
  };
}

extension ChecklistCategoryArt on ChecklistCategory {
  String get icon => switch (this) {
    ChecklistCategory.music => ChecklistArt.music,
    ChecklistCategory.costume => ChecklistArt.costume,
    ChecklistCategory.props => ChecklistArt.props,
    ChecklistCategory.lighting => ChecklistArt.lighting,
    ChecklistCategory.stage => ChecklistArt.stage,
    ChecklistCategory.safety => ChecklistArt.safety,
  };
}

extension StageEquipmentArt on StageEquipment {
  String get icon => switch (this) {
    StageEquipment.fresnelLight => EquipmentArt.fresnelLight,
    StageEquipment.profileLight => EquipmentArt.profileLight,
    StageEquipment.microphone => EquipmentArt.microphone,
    StageEquipment.music => EquipmentArt.music,
    StageEquipment.costume => EquipmentArt.costume,
    StageEquipment.curtain => EquipmentArt.curtain,
    StageEquipment.pedestal => EquipmentArt.pedestal,
  };
}

extension BlockRoleArt on BlockRole {
  /// Card artwork behind a block in the Run Order builder.
  String get card => switch (this) {
    BlockRole.opening => TimelineArt.cardCurtain,
    BlockRole.main => TimelineArt.cardTent,
    BlockRole.transition => TimelineArt.cardChandelier,
    BlockRole.highlight => TimelineArt.cardSpotlight,
    BlockRole.finale => TimelineArt.cardFireworks,
  };

  /// Pin marking the block on the performance timeline.
  String get pin => switch (this) {
    BlockRole.opening => TimelineArt.pinCurtain,
    BlockRole.main => TimelineArt.pinSwag,
    BlockRole.transition => TimelineArt.pinTassel,
    BlockRole.highlight => TimelineArt.pinStar,
    BlockRole.finale => TimelineArt.pinFireworks,
  };

  /// Pennant used as the block's label on the timeline.
  String get pennant => switch (this) {
    BlockRole.opening => TimelineArt.pennantCurtain,
    BlockRole.main => TimelineArt.pennantSwag,
    BlockRole.transition => TimelineArt.pennantTassel,
    BlockRole.highlight => TimelineArt.pennantStar,
    BlockRole.finale => TimelineArt.pennantFireworks,
  };

  Color get tint => switch (this) {
    BlockRole.opening => Palette.bordeauxGlow,
    BlockRole.main => Palette.brass,
    BlockRole.transition => Palette.textTertiary,
    BlockRole.highlight => Palette.brassGlow,
    BlockRole.finale => Palette.emeraldGlow,
  };
}

extension MasteryArt on Mastery {
  /// Badge shown against a trick in the library.
  String get badge => switch (this) {
    Mastery.learning => ProgressArt.pinFeather,
    Mastery.drilling => ProgressArt.pinDrape,
    Mastery.reliable => ProgressArt.pinStar,
    Mastery.showReady => ProgressArt.pinCrown,
  };

  Color get tint => switch (this) {
    Mastery.learning => Palette.textTertiary,
    Mastery.drilling => Palette.caution,
    Mastery.reliable => Palette.brass,
    Mastery.showReady => Palette.emeraldGlow,
  };
}

extension PageRulingArt on PageRuling {
  String get sheet => switch (this) {
    PageRuling.lined => Pages.lined,
    PageRuling.blocks => Pages.blocks,
    PageRuling.grid => Pages.grid,
    PageRuling.schedule => Pages.schedule,
  };
}

extension PaperStockArt on PaperStock {
  String get texture => switch (this) {
    PaperStock.aged => Papers.aged,
    PaperStock.sunburst => Papers.sunburst,
    PaperStock.linen => Papers.linen,
    PaperStock.ticket => Papers.ticket,
  };
}

extension CueFrameStyleArt on CueFrameStyle {
  String get frame => switch (this) {
    CueFrameStyle.curtain => CueFrames.curtain,
    CueFrameStyle.tent => CueFrames.tent,
    CueFrameStyle.jester => CueFrames.jester,
    CueFrameStyle.stripes => CueFrames.stripes,
  };
}

extension IssueSeverityArt on IssueSeverity {
  String get label => switch (this) {
    IssueSeverity.info => 'Info',
    IssueSeverity.warning => 'Warning',
    IssueSeverity.critical => 'Critical',
  };

  Color get tint => switch (this) {
    IssueSeverity.info => Palette.brassDim,
    IssueSeverity.warning => Palette.caution,
    IssueSeverity.critical => Palette.danger,
  };

  IconData get icon => switch (this) {
    IssueSeverity.info => Icons.info_outline_rounded,
    IssueSeverity.warning => Icons.warning_amber_rounded,
    IssueSeverity.critical => Icons.error_outline_rounded,
  };
}

extension ActEmblemArt on ActEmblem {
  String get medallion => switch (this) {
    ActEmblem.joker => Emblems.joker,
    ActEmblem.mask => Emblems.mask,
    ActEmblem.cards => Emblems.cards,
    ActEmblem.tent => Emblems.tent,
  };

  /// Matching crest, used on the header of the act's detail screen.
  String get crest => switch (this) {
    ActEmblem.joker => Ornaments.crestShell,
    ActEmblem.mask => Ornaments.crestMask,
    ActEmblem.cards => Ornaments.crestStar,
    ActEmblem.tent => Ornaments.crestTent,
  };
}

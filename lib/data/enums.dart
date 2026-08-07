/// Domain vocabulary, kept free of any Flutter or artwork dependency.
///
/// Every value is stored in SQLite by `name`, so entries can be added freely
/// but must never be renamed without a migration.
library;

/// The four disciplines an act draws its material from.
enum Discipline {
  acrobatics('Acrobatics', 'Tumbling passes, balances and partner work'),
  cardWork('Card Work', 'Fans, flourishes and table routines'),
  illusion('Illusion', 'Sleight of hand, reveals and vanishes'),
  stagecraft('Stagecraft', 'Presentation, blocking and audience work');

  const Discipline(this.label, this.blurb);

  final String label;
  final String blurb;
}

/// How far a trick has been taken. Deliberately about rehearsal readiness
/// rather than a score: there is nothing to level up.
enum Mastery {
  learning('Learning', 'Still breaking the shape down'),
  drilling('Drilling', 'Repeatable, not yet consistent'),
  reliable('Reliable', 'Lands consistently in rehearsal'),
  showReady('Show ready', 'Safe to put in front of an audience');

  const Mastery(this.label, this.blurb);

  final String label;
  final String blurb;

  /// Fraction of the way to show-ready, used by readiness maths.
  double get weight => index / (Mastery.values.length - 1);
}

/// The five structural roles a block can play inside an act.
///
/// Order matters: this is the order the builder offers when a new act is
/// created, and it matches the shape described in the product brief.
enum BlockRole {
  opening('Opening', 'Set the tone and get the audience with you'),
  main('Main element', 'The strongest material in the act'),
  transition('Transition', 'Reset props, costume or position'),
  highlight('Highlight', 'The moment the act is remembered for'),
  finale('Finale', 'Land the ending and hold the applause');

  const BlockRole(this.label, this.blurb);

  final String label;
  final String blurb;
}

/// Preparation stage of an act.
enum ActStatus {
  draft('Draft', 'Captured, not yet planned'),
  planning('Planning', 'Structure and running order taking shape'),
  rehearsal('Rehearsal', 'In the room, working it'),
  ready('Ready', 'Cleared to perform'),
  completed('Completed', 'Performed and archived');

  const ActStatus(this.label, this.blurb);

  final String label;
  final String blurb;

  bool get isArchivable => this == ActStatus.completed;

  /// Statuses that count as active work on the Stage Console.
  static const Set<ActStatus> active = <ActStatus>{
    ActStatus.draft,
    ActStatus.planning,
    ActStatus.rehearsal,
    ActStatus.ready,
  };
}

/// Categories in the rehearsal checklist.
enum ChecklistCategory {
  music('Music', 'Track, edit, cues and backup copy'),
  costume('Costume', 'Fit, quick changes and repairs'),
  props('Props', 'Condition, count and placement'),
  lighting('Lighting', 'States, follow spots and blackouts'),
  stage('Stage', 'Surface, marks, wings and clearances'),
  safety('Safety', 'Spotting, rigging, matting and limits');

  const ChecklistCategory(this.label, this.blurb);

  final String label;
  final String blurb;
}

/// Equipment lines on the stage plot, i.e. the technical rider.
enum StageEquipment {
  fresnelLight('Fresnel wash', 'General cover and colour'),
  profileLight('Profile spot', 'Hard-edged specials and follow'),
  microphone('Microphone', 'Announcements and radio packs'),
  music('Playback', 'Desk, outputs and operator cue sheet'),
  costume('Wardrobe', 'Hanging space, steamer, quick-change area'),
  curtain('Drapes', 'Tabs, legs, borders and travellers'),
  pedestal('Pedestal', 'Rostra, platforms and set pieces');

  const StageEquipment(this.label, this.blurb);

  final String label;
  final String blurb;
}

/// Page rulings available to a note, mirroring the printed planner pages.
enum PageRuling {
  lined('Lined', 'Running prose and cue lists'),
  blocks('Blocks', 'Beat-by-beat boxes'),
  grid('Grid', 'Stage positions and spacing'),
  schedule('Schedule', 'Call times and rehearsal plan');

  const PageRuling(this.label, this.blurb);

  final String label;
  final String blurb;
}

/// Paper stocks a note or cue card can be printed on.
enum PaperStock {
  aged('Aged'),
  sunburst('Sunburst'),
  linen('Linen'),
  ticket('Ticket');

  const PaperStock(this.label);

  final String label;
}

/// Frame styles for cue cards.
enum CueFrameStyle {
  curtain('Curtain'),
  tent('Big top'),
  jester('Jester'),
  stripes('Stripes');

  const CueFrameStyle(this.label);

  final String label;
}

/// Emblem chosen as an act's cover mark.
enum ActEmblem {
  joker('Joker'),
  mask('Mask'),
  cards('Cards'),
  tent('Big top');

  const ActEmblem(this.label);

  final String label;
}

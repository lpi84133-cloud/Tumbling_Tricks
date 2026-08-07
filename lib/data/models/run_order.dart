import '../app_database.dart';
import '../enums.dart';

/// A block together with the beats inside it, in performance order.
class RunOrderBlock {
  const RunOrderBlock({required this.block, required this.beats});

  final ActBlockRow block;
  final List<RunOrderItemRow> beats;

  int get id => block.id;
  BlockRole get role => block.role;
  String get title => block.title;

  /// Sum of the beats' durations. This is the real number; `plannedSeconds` on
  /// the block is the user's estimate before the beats exist.
  int get actualSeconds =>
      beats.fold<int>(0, (int sum, RunOrderItemRow b) => sum + b.seconds);

  int get estimateSeconds => block.plannedSeconds;

  int get confirmedCount =>
      beats.where((RunOrderItemRow b) => b.isConfirmed).length;

  bool get isEmpty => beats.isEmpty;
  bool get isFullyConfirmed => beats.isNotEmpty && confirmedCount == beats.length;

  /// How far the block is from the estimate the user set for it.
  int get estimateDriftSeconds => actualSeconds - estimateSeconds;
}

/// The complete run order of an act.
class RunOrder {
  const RunOrder({required this.actId, required this.blocks});

  final int actId;
  final List<RunOrderBlock> blocks;

  static const RunOrder empty = RunOrder(actId: 0, blocks: <RunOrderBlock>[]);

  int get totalSeconds =>
      blocks.fold<int>(0, (int sum, RunOrderBlock b) => sum + b.actualSeconds);

  int get beatCount =>
      blocks.fold<int>(0, (int sum, RunOrderBlock b) => sum + b.beats.length);

  bool get isEmpty => blocks.isEmpty;

  /// Cumulative start time of each block, so the timeline can be laid out
  /// without recomputing offsets in the widget tree.
  List<int> get blockStartOffsets {
    final List<int> offsets = <int>[];
    int running = 0;
    for (final RunOrderBlock block in blocks) {
      offsets.add(running);
      running += block.actualSeconds;
    }
    return offsets;
  }

  /// Every beat flattened into performance order, paired with its block.
  List<({RunOrderBlock block, RunOrderItemRow beat, int startSeconds})> get timeline {
    final List<({RunOrderBlock block, RunOrderItemRow beat, int startSeconds})> out =
        <({RunOrderBlock block, RunOrderItemRow beat, int startSeconds})>[];
    int running = 0;
    for (final RunOrderBlock block in blocks) {
      for (final RunOrderItemRow beat in block.beats) {
        out.add((block: block, beat: beat, startSeconds: running));
        running += beat.seconds;
      }
    }
    return out;
  }
}

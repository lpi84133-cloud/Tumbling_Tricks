import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_database.dart';
import '../../data/models/act_summary.dart';
import '../../data/models/run_order.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/act_widgets.dart';
import '../shared/format.dart';
import '../shared/page_frame.dart';

/// The act laid out against the clock.
///
/// The run order screen is for building; this one is for reading the act as the
/// audience will experience it. Each beat's height is proportional to its
/// duration, so a block that eats half the act looks like it does.
class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({required this.actId, super.key});

  final int actId;

  /// Vertical pixels per second. Chosen so a four-minute act fits in roughly two
  /// screens: long enough to feel the proportions, short enough to scan.
  static const double _scale = 2.4;
  static const double _minBeatHeight = 44;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RunOrder order = ref.watch(runOrderProvider(actId)).value ?? RunOrder.empty;
    final ActSummary? summary = ref.watch(actSummaryProvider(actId)).value;

    return PageFrame(
      scene: StageScene.finale,
      artworkOpacity: 0.16,
      header: MarqueeHeader(
        eyebrow: summary?.title,
        title: 'Performance Timeline',
        crest: Ornaments.crestStar,
        onBack: () => context.pop(),
        subtitle: order.isEmpty
            ? null
            : '${Fmt.clock(order.totalSeconds)} across '
                '${order.blocks.length} ${order.blocks.length == 1 ? 'block' : 'blocks'}',
      ),
      slivers: <Widget>[
        if (order.isEmpty)
          PageSliver(
            child: EmptyStage(
              crest: Ornaments.crestStar,
              title: 'Nothing to lay out yet',
              body: 'Build the run order first. The timeline draws itself from '
                  'the blocks and beats you put in it.',
              actionLabel: 'Open the run order',
              onAction: () => context.pushReplacement('/acts/$actId/run-order'),
            ),
          )
        else
          PageSliver(
            child: Column(
              children: <Widget>[
                for (int i = 0; i < order.blocks.length; i++)
                  _BlockSegment(
                    entry: order.blocks[i],
                    startSeconds: order.blockStartOffsets[i],
                    isLast: i == order.blocks.length - 1,
                  ),
                Gap.vLg,
                Image.asset(TimelineArt.ornamentFleur, height: 22),
                Gap.vSm,
                Text('CURTAIN', style: AppText.sectionLabel),
              ],
            ),
          ),
      ],
    );
  }
}

class _BlockSegment extends StatelessWidget {
  const _BlockSegment({
    required this.entry,
    required this.startSeconds,
    required this.isLast,
  });

  final RunOrderBlock entry;
  final int startSeconds;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    int running = startSeconds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // The block's pennant, hung from the timeline like a scene marker.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 52,
              child: Text(
                Fmt.clock(startSeconds),
                style: AppText.timecode.copyWith(fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
            Gap.hMd,
            Image.asset(entry.role.pennant, height: 30),
            Gap.hSm,
            Expanded(
              child: Text(
                entry.title,
                style: AppText.cardTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (entry.beats.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 64, top: Gap.sm, bottom: Gap.lg),
            child: Text('nothing placed here yet', style: AppText.micro),
          )
        else
          for (final RunOrderItemRow beat in entry.beats)
            Builder(
              builder: (BuildContext context) {
                final int start = running;
                running += beat.seconds;
                return _BeatSegment(
                  beat: beat,
                  startSeconds: start,
                  tint: entry.role.tint,
                );
              },
            ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Gap.md),
            child: Image.asset(TimelineArt.dividerBeads, height: 12),
          ),
      ],
    );
  }
}

class _BeatSegment extends StatelessWidget {
  const _BeatSegment({
    required this.beat,
    required this.startSeconds,
    required this.tint,
  });

  final RunOrderItemRow beat;
  final int startSeconds;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final double height = (beat.seconds * TimelineScreen._scale)
        .clamp(TimelineScreen._minBeatHeight, 320);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          width: 52,
          child: Padding(
            padding: const EdgeInsets.only(top: Gap.sm),
            child: Text(
              Fmt.clock(startSeconds),
              style: AppText.micro,
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Gap.hMd,
        // The spine: a brass rule the whole act hangs from.
        SizedBox(
          width: 2,
          child: ColoredBox(color: tint.withValues(alpha: 0.5)),
        ),
        Gap.hMd,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: Gap.xs),
            child: SizedBox(
              height: height,
              child: PanelCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: Gap.md,
                  vertical: Gap.sm,
                ),
                accent: beat.isConfirmed ? Palette.emeraldGlow : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            beat.label,
                            style: AppText.bodyStrong,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          Fmt.clock(beat.seconds),
                          style: AppText.timecode.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    if (beat.cueNote != null) ...<Widget>[
                      Gap.vXs,
                      Expanded(
                        child: Text(
                          beat.cueNote!,
                          style: AppText.micro,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

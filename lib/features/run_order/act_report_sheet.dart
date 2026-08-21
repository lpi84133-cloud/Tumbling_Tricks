import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/models/act_report.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';
import '../shared/sheet_shell.dart';

/// A structural readout of an act's run order.
///
/// The report cannot be dismissed, marked resolved or muted — the only way to
/// clear a finding is to change the underlying run order. This is deliberate:
/// the linter's value is that it stays honest.
abstract final class ActReportSheet {
  static Future<void> show(BuildContext context, int actId) {
    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => _ActReportSheet(actId: actId),
    );
  }
}

class _ActReportSheet extends ConsumerWidget {
  const _ActReportSheet({required this.actId});

  final int actId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ActReport> report = ref.watch(actReportProvider(actId));

    return SheetShell(
      heightFraction: 0.92,
      child: switch (report) {
        AsyncData(value: final ActReport value) => _ReportBody(report: value),
        AsyncError(:final Object error) => Padding(
            padding: const EdgeInsets.symmetric(vertical: Gap.xl),
            child: Text('Could not read the run order.\n$error',
                style: AppText.caption),
          ),
        _ => const Padding(
            padding: EdgeInsets.symmetric(vertical: Gap.xxl),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      },
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report});

  final ActReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Structure report', style: AppText.cardTitle),
        Gap.vXs,
        Text(
          'Every finding comes from the run order as it stands. Fix the beat, '
          'the finding disappears.',
          style: AppText.caption,
        ),
        Gap.vLg,
        _SeverityStrip(report: report),
        Gap.vXl,
        const SectionHeading(label: 'Energy curve'),
        Gap.vMd,
        PanelCard(
          padding: const EdgeInsets.fromLTRB(Gap.md, Gap.lg, Gap.md, Gap.md),
          child: report.curve.isEmpty
              ? SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('No beats to plot yet.', style: AppText.caption),
                  ),
                )
              : _EnergyCurve(points: report.curve),
        ),
        Gap.vXl,
        const SectionHeading(label: 'Findings'),
        Gap.vMd,
        if (report.isClean)
          PanelCard(
            accent: Palette.emeraldGlow,
            child: Row(
              children: <Widget>[
                const Icon(Icons.check_circle_rounded,
                    color: Palette.emeraldGlow, size: 22),
                Gap.hMd,
                Expanded(
                  child: Text(
                    'Structure reads clean. Nothing worth flagging in the '
                    'current run order.',
                    style: AppText.body,
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: <Widget>[
              for (final ActIssue issue in report.issues)
                Padding(
                  padding: const EdgeInsets.only(bottom: Gap.sm),
                  child: _IssueCard(issue: issue),
                ),
            ],
          ),
        Gap.vLg,
      ],
    );
  }
}

/// Coloured counter row: at a glance, how many findings of each level exist.
class _SeverityStrip extends StatelessWidget {
  const _SeverityStrip({required this.report});

  final ActReport report;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      accent: report.overallSeverity.tint,
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
      child: Row(
        children: <Widget>[
          for (final IssueSeverity level in IssueSeverity.values)
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    '${report.countOf(level)}',
                    style: AppText.timecodeLarge.copyWith(color: level.tint),
                  ),
                  Gap.vXxs,
                  Text(
                    level.label.toUpperCase(),
                    style: AppText.micro,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One row per finding, with the severity colour picked up as the accent bar.
class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final ActIssue issue;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      accent: issue.severity.tint,
      padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(issue.severity.icon, color: issue.severity.tint, size: 18),
              Gap.hSm,
              Expanded(
                child: Text(issue.title, style: AppText.bodyStrong),
              ),
              Text(
                issue.severity.label.toUpperCase(),
                style: AppText.micro.copyWith(color: issue.severity.tint),
              ),
            ],
          ),
          Gap.vSm,
          Text(issue.detail, style: AppText.caption),
          Gap.vXs,
          Text(
            issue.advice,
            style: AppText.caption.copyWith(color: Palette.brassLift),
          ),
        ],
      ),
    );
  }
}

/// The energy curve: one bar per beat, coloured by its block role, height
/// proportional to the linked trick's difficulty.
///
/// Painted rather than plotted with a charting package: the whole surface
/// needs to sit on the same brass hairline the rest of the app uses, and the
/// data is at most a couple of dozen values.
class _EnergyCurve extends StatelessWidget {
  const _EnergyCurve({required this.points});

  final List<EnergyPoint> points;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 132,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, 132),
                painter: _EnergyPainter(points: points),
              );
            },
          ),
        ),
        Gap.vSm,
        Wrap(
          spacing: Gap.md,
          runSpacing: Gap.xs,
          children: <Widget>[
            for (final BlockRole role in _rolesShown(points))
              _LegendDot(role: role),
          ],
        ),
      ],
    );
  }

  static List<BlockRole> _rolesShown(List<EnergyPoint> points) {
    final Set<BlockRole> present = <BlockRole>{
      for (final EnergyPoint p in points) p.role,
    };
    return BlockRole.values.where(present.contains).toList(growable: false);
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.role});

  final BlockRole role;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: role.tint, shape: BoxShape.circle),
        ),
        Gap.hXs,
        Text(role.label, style: AppText.micro),
      ],
    );
  }
}

class _EnergyPainter extends CustomPainter {
  _EnergyPainter({required this.points});

  final List<EnergyPoint> points;

  static const double _maxDifficulty = 5;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final int totalSeconds =
        points.last.endSeconds > 0 ? points.last.endSeconds : 1;

    // Horizontal guide lines at each difficulty step, so the eye can compare
    // beats without a numeric axis.
    final Paint guide = Paint()
      ..color = Palette.hairline
      ..strokeWidth = 0.6;
    for (int level = 1; level <= _maxDifficulty; level++) {
      final double y = size.height * (1 - level / _maxDifficulty);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), guide);
    }

    // Each beat is drawn as a rectangle whose width is its share of the total
    // running time, and whose height is its difficulty. Free-form beats
    // (difficulty 0) show as a low neutral bar rather than nothing, so the
    // timeline still reads continuously.
    for (final EnergyPoint point in points) {
      final double left = size.width * point.startSeconds / totalSeconds;
      final double right = size.width * point.endSeconds / totalSeconds;
      final double difficulty = point.difficulty <= 0 ? 0.6 : point.difficulty;
      final double height = size.height * (difficulty / _maxDifficulty);
      final double top = size.height - height;

      // Gap between bars, but never wider than the bar itself, so a very short
      // beat still shows.
      final double barWidth = math.max(2, right - left - 1);

      final Rect rect = Rect.fromLTWH(left, top, barWidth, height);
      final Paint fill = Paint()
        ..color = point.difficulty <= 0
            ? Palette.textDisabled
            : point.role.tint.withValues(alpha: 0.85);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        fill,
      );
    }

    // Baseline so an empty column reads as intentional rather than a bug.
    final Paint baseline = Paint()
      ..color = Palette.brassDim
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height - 0.5),
      Offset(size.width, size.height - 0.5),
      baseline,
    );
  }

  @override
  bool shouldRepaint(covariant _EnergyPainter old) => old.points != points;
}

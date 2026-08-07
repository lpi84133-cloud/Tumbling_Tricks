import 'package:intl/intl.dart';

/// Formatting shared across screens, so a duration or a date never appears in
/// two different shapes.
abstract final class Fmt {
  /// `4:05` — running times and cue positions.
  static String clock(int seconds) {
    final int safe = seconds < 0 ? -seconds : seconds;
    final int m = safe ~/ 60;
    final int s = safe % 60;
    return '${seconds < 0 ? '−' : ''}$m:${s.toString().padLeft(2, '0')}';
  }

  /// `4 min 05 s` — spoken form, used where a bare clock would be ambiguous.
  static String duration(int seconds) {
    if (seconds < 60) return '$seconds s';
    final int m = seconds ~/ 60;
    final int s = seconds % 60;
    return s == 0 ? '$m min' : '$m min $s s';
  }

  /// `1 h 30 min` — rehearsal lengths, which are recorded in minutes.
  static String minutes(int value) {
    if (value < 60) return '$value min';
    final int h = value ~/ 60;
    final int m = value % 60;
    return m == 0 ? '$h h' : '$h h $m min';
  }

  static final DateFormat _day = DateFormat('d MMM');
  static final DateFormat _dayYear = DateFormat('d MMM yyyy');

  /// `12 Mar`, or `12 Mar 2025` when it is not the current year.
  static String date(DateTime value, {DateTime? now}) {
    final DateTime reference = now ?? DateTime.now();
    return value.year == reference.year ? _day.format(value) : _dayYear.format(value);
  }

  /// `Today`, `Yesterday`, `4 days ago`, then falls back to a date.
  static String relativeDay(DateTime value, {DateTime? now}) {
    final DateTime reference = now ?? DateTime.now();
    final DateTime a = DateTime(value.year, value.month, value.day);
    final DateTime b = DateTime(reference.year, reference.month, reference.day);
    final int days = b.difference(a).inDays;

    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days > 1 && days < 7) return '$days days ago';
    if (days < 0 && days > -7) return 'In ${-days} days';
    if (days == -1) return 'Tomorrow';
    return date(value, now: reference);
  }

  /// `in 12 days` / `9 days ago`, for a performance date.
  static String countdown(DateTime target, {DateTime? now}) {
    final DateTime reference = now ?? DateTime.now();
    final int days = DateTime(target.year, target.month, target.day)
        .difference(DateTime(reference.year, reference.month, reference.day))
        .inDays;

    if (days == 0) return 'today';
    if (days == 1) return 'tomorrow';
    if (days > 1) return 'in $days days';
    if (days == -1) return 'yesterday';
    return '${-days} days ago';
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show DataClass;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/app_database.dart';

/// Writes a readable copy of everything the app holds and hands it to the share
/// sheet.
///
/// The format is plain JSON rather than a database file so the user can open the
/// export anywhere and see their own work. Nothing is uploaded by this app; where
/// the file goes afterwards is entirely the user's choice.
abstract final class DataExport {
  static Future<void> share(AppDatabase db) async {
    final Map<String, Object?> payload = <String, Object?>{
      'app': 'Tumbling Tricks',
      'exportedAt': DateTime.now().toIso8601String(),
      'formatVersion': 1,
      'profile': await _rows(db.select(db.performerProfiles).get()),
      'preferences': await _rows(db.select(db.appPreferences).get()),
      'acts': await _rows(db.select(db.acts).get()),
      'blocks': await _rows(db.select(db.actBlocks).get()),
      'runOrder': await _rows(db.select(db.runOrderItems).get()),
      'checklist': await _rows(db.select(db.checklistItems).get()),
      'stagePlot': await _rows(db.select(db.stagePlotItems).get()),
      'notes': await _rows(db.select(db.notes).get()),
      'rehearsals': await _rows(db.select(db.rehearsals).get()),
      'tricks': await _rows(db.select(db.tricks).get()),
    };

    final Directory dir = await getTemporaryDirectory();
    final String stamp = DateTime.now()
        .toIso8601String()
        .substring(0, 16)
        .replaceAll(RegExp(r'[:T]'), '-');
    final File file = File(p.join(dir.path, 'tumbling-tricks-$stamp.json'));

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
      flush: true,
    );

    await SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(file.path, mimeType: 'application/json')],
        subject: 'Tumbling Tricks export',
        text: 'A copy of the acts, tricks and rehearsals held on this device.',
      ),
    );
  }

  /// Drift data classes already know how to describe themselves as a map, which
  /// keeps the export in step with the schema automatically.
  static Future<List<Map<String, Object?>>> _rows<T extends DataClass>(
    Future<List<T>> query,
  ) async {
    final List<T> rows = await query;
    return rows.map((T row) => _stringifyDates(row.toJson())).toList(growable: false);
  }

  /// `toJson` leaves `DateTime` values as objects, which the encoder cannot
  /// handle, so they become ISO strings here.
  static Map<String, Object?> _stringifyDates(Map<String, Object?> row) {
    return row.map((String key, Object? value) => MapEntry<String, Object?>(
      key,
      value is DateTime ? value.toIso8601String() : value,
    ));
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Stores the performer photo inside the app's documents directory.
///
/// The picked image is re-encoded at a modest size before being saved, for three
/// reasons: a 12-megapixel original would be wasteful for a 96pt avatar, the
/// re-encode strips the original's metadata including any location tags, and the
/// result is small enough that the app stays quick to back up.
///
/// Only the file name is handed back to the database — see [ProfileRepository]
/// for why the absolute path must not be stored.
abstract final class ProfilePhotoStore {
  static const int _maxEdge = 512;
  static const String _prefix = 'performer_photo_';

  /// Opens the camera or the photo library, then saves the result.
  ///
  /// Returns the stored file name, or `null` if the user cancelled. The system
  /// permission prompt appears here and only here, at the moment the user asked
  /// for a photo.
  static Future<String?> pickAndStore(ImageSource source) async {
    final XFile? picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 92,
      preferredCameraDevice: CameraDevice.front,
    );
    if (picked == null) return null;

    final Uint8List bytes = await picked.readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) return null;

    final img.Image square = _squareCrop(decoded);
    final img.Image resized = square.width > _maxEdge
        ? img.copyResize(
            square,
            width: _maxEdge,
            height: _maxEdge,
            interpolation: img.Interpolation.average,
          )
        : square;

    final Directory dir = await getApplicationDocumentsDirectory();
    final String fileName =
        '$_prefix${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File target = File(p.join(dir.path, fileName));
    await target.writeAsBytes(img.encodeJpg(resized, quality: 88), flush: true);

    await _removeOthers(dir, keep: fileName);
    return fileName;
  }

  /// Resolves a stored file name to a file, or `null` if it is missing.
  ///
  /// A missing file is treated as "no photo" rather than an error: the container
  /// can be restored without its documents in some migration paths, and losing
  /// an avatar should never block the profile screen.
  static Future<File?> resolve(String? fileName) async {
    if (fileName == null || fileName.isEmpty) return null;
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, fileName));
    return file.existsSync() ? file : null;
  }

  static Future<void> deleteAll() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    await _removeOthers(dir, keep: null);
  }

  static img.Image _squareCrop(img.Image source) {
    final int edge = source.width < source.height ? source.width : source.height;
    return img.copyCrop(
      source,
      x: (source.width - edge) ~/ 2,
      y: (source.height - edge) ~/ 2,
      width: edge,
      height: edge,
    );
  }

  static Future<void> _removeOthers(Directory dir, {required String? keep}) async {
    await for (final FileSystemEntity entity in dir.list()) {
      if (entity is! File) continue;
      final String name = p.basename(entity.path);
      if (!name.startsWith(_prefix)) continue;
      if (name == keep) continue;
      await entity.delete();
    }
  }
}

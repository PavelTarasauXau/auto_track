import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:image/image.dart' as img;

/// Shrinks camera photos (5–10 MB) to Full HD JPEGs (~300–600 KB).
///
/// Decoding and encoding a large JPEG takes hundreds of milliseconds, so the
/// work runs in a separate isolate and the UI keeps rendering smoothly.
abstract final class ImageCompressor {
  /// Longest side of the result, in pixels.
  static const maxSide = 1920;
  static const quality = 80;

  /// Compresses [sourcePath] into a JPEG at [targetPath] in a background
  /// isolate. Returns `false` if the file is not a decodable image
  /// (nothing is written in that case).
  static Future<bool> compressFile(String sourcePath, String targetPath) =>
      Isolate.run(() => compressSync(sourcePath, targetPath));

  /// The actual work; synchronous, runs inside the isolate.
  static bool compressSync(String sourcePath, String targetPath) {
    final decoded = img.decodeImage(File(sourcePath).readAsBytesSync());
    if (decoded == null) return false;

    // Phones store rotation in EXIF instead of rotating pixels; apply it,
    // because EXIF is dropped when re-encoding.
    var image = img.bakeOrientation(decoded);

    final longest = max(image.width, image.height);
    if (longest > maxSide) {
      final landscape = image.width >= image.height;
      image = img.copyResize(
        image,
        width: landscape ? maxSide : null,
        height: landscape ? null : maxSide,
        interpolation: img.Interpolation.average,
      );
    }

    File(targetPath).writeAsBytesSync(img.encodeJpg(image, quality: quality));
    return true;
  }
}

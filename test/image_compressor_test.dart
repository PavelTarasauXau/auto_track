import 'dart:io';

import 'package:auto_track/services/file_storage.dart';
import 'package:auto_track/services/image_compressor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('autotrack_img'));
  tearDown(() => dir.deleteSync(recursive: true));

  /// Writes a noisy JPEG (noise keeps it large, like a real photo).
  String writeJpeg(String name, int width, int height, {int? orientation}) {
    final image = img.Image(width: width, height: height);
    for (final pixel in image) {
      pixel
        ..r = (pixel.x * 7 + pixel.y * 13) % 256
        ..g = (pixel.x * pixel.y) % 256
        ..b = (pixel.x ^ pixel.y) % 256;
    }
    if (orientation != null) image.exif.imageIfd.orientation = orientation;
    final path = p.join(dir.path, name);
    File(path).writeAsBytesSync(img.encodeJpg(image, quality: 95));
    return path;
  }

  img.Image readJpeg(String path) =>
      img.decodeJpg(File(path).readAsBytesSync())!;

  String out(String name) => p.join(dir.path, name);

  test('large landscape photo is scaled down to 1920 px', () async {
    final src = writeJpeg('big.jpg', 4000, 3000);
    expect(await ImageCompressor.compressFile(src, out('o.jpg')), isTrue);

    final result = readJpeg(out('o.jpg'));
    expect(result.width, 1920);
    expect(result.height, 1440);
    expect(File(out('o.jpg')).lengthSync(), lessThan(File(src).lengthSync()));
  });

  test('portrait photo keeps its orientation', () async {
    final src = writeJpeg('tall.jpg', 3000, 4000);
    await ImageCompressor.compressFile(src, out('o.jpg'));

    final result = readJpeg(out('o.jpg'));
    expect(result.width, 1440);
    expect(result.height, 1920);
  });

  test('small photo is not enlarged', () async {
    final src = writeJpeg('small.jpg', 800, 600);
    await ImageCompressor.compressFile(src, out('o.jpg'));

    final result = readJpeg(out('o.jpg'));
    expect(result.width, 800);
    expect(result.height, 600);
  });

  test('EXIF rotation is applied to the pixels', () async {
    // Orientation 6 = the camera was held rotated 90° clockwise.
    final src = writeJpeg('rotated.jpg', 400, 200, orientation: 6);
    await ImageCompressor.compressFile(src, out('o.jpg'));

    final result = readJpeg(out('o.jpg'));
    expect(result.width, 200);
    expect(result.height, 400);
  });

  test('non-image file is rejected', () async {
    final src = out('note.txt');
    File(src).writeAsStringSync('not an image');

    expect(await ImageCompressor.compressFile(src, out('o.jpg')), isFalse);
    expect(File(out('o.jpg')).existsSync(), isFalse);
  });

  group('FileStorage.importImage', () {
    late FileStorage storage;

    setUp(() {
      final receipts = Directory(p.join(dir.path, 'receipts'))..createSync();
      storage = FileStorage(receipts);
    });

    test('stores a compressed JPEG under a unique name', () async {
      final src = writeJpeg('photo.jpg', 2500, 2500);
      final name = await storage.importImage(src);

      expect(name, endsWith('.jpg'));
      expect(readJpeg(storage.pathOf(name)).width, 1920);
      // The original is left untouched.
      expect(File(src).existsSync(), isTrue);
      expect(await storage.importImage(src), isNot(name));
    });

    test('copies undecodable files as is', () async {
      final src = out('scan.heic');
      File(src).writeAsStringSync('heic data');

      final name = await storage.importImage(src);
      expect(name, endsWith('.heic'));
      expect(storage.fileOf(name).readAsStringSync(), 'heic data');
    });
  });
}

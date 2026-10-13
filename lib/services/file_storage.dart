import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'image_compressor.dart';

/// Stores receipt and document photos in `<app documents>/receipts/`.
///
/// The database keeps only file names; this class turns them into paths.
class FileStorage {
  FileStorage(this.directory);

  final Directory directory;

  static const _uuid = Uuid();

  static Future<FileStorage> open() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'receipts'));
    await dir.create(recursive: true);
    return FileStorage(dir);
  }

  String pathOf(String fileName) => p.join(directory.path, fileName);

  File fileOf(String fileName) => File(pathOf(fileName));

  /// A new unique file name with the given extension, e.g. `<uuid>.jpg`.
  String newFileName([String extension = '.jpg']) => '${_uuid.v4()}$extension';

  /// Copies an external file (camera, gallery) into storage under a unique
  /// name and returns that name.
  Future<String> importFile(String sourcePath) async {
    final ext = p.extension(sourcePath).toLowerCase();
    final name = newFileName(ext.isEmpty ? '.jpg' : ext);
    await File(sourcePath).copy(pathOf(name));
    return name;
  }

  /// Compresses a photo (camera, gallery) into storage in a background
  /// isolate and returns the new file name. Files that cannot be decoded
  /// (e.g. HEIC) are copied as is.
  Future<String> importImage(String sourcePath) async {
    final name = newFileName('.jpg');
    final ok = await ImageCompressor.compressFile(sourcePath, pathOf(name));
    return ok ? name : importFile(sourcePath);
  }

  /// Best-effort cleanup: a file that cannot be deleted (e.g. locked by
  /// another process on Windows) is logged and left behind instead of
  /// failing the operation that triggered the cleanup.
  ///
  /// Deleting takes microseconds, so it is done synchronously: simpler,
  /// and it completes even while a screen is being disposed.
  Future<void> delete(String fileName) async {
    final file = fileOf(fileName);
    try {
      if (file.existsSync()) file.deleteSync();
    } on FileSystemException catch (e) {
      debugPrint('Could not delete $fileName: $e');
    }
  }

  Future<void> deleteAll(Iterable<String> fileNames) async {
    for (final name in fileNames) {
      await delete(name);
    }
  }
}

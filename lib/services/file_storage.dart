import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> delete(String fileName) async {
    final file = fileOf(fileName);
    if (await file.exists()) await file.delete();
  }

  Future<void> deleteAll(Iterable<String> fileNames) async {
    for (final name in fileNames) {
      await delete(name);
    }
  }
}

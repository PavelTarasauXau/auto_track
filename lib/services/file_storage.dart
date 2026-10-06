import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Stores receipt and document photos in `<app documents>/receipts/`.
///
/// The database keeps only file names; this class turns them into paths.
class FileStorage {
  FileStorage(this.directory);

  final Directory directory;

  static Future<FileStorage> open() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'receipts'));
    await dir.create(recursive: true);
    return FileStorage(dir);
  }

  String pathOf(String fileName) => p.join(directory.path, fileName);

  File fileOf(String fileName) => File(pathOf(fileName));

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

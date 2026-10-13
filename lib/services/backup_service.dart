import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../data/db/database.dart';

/// Thrown when a file is not a valid AutoTrack backup.
class BackupException implements Exception {
  const BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// A backup unpacked into a temporary directory and validated.
class UnpackedBackup {
  const UnpackedBackup({
    required this.databasePath,
    required this.receiptsPath,
    required this.createdAt,
  });

  final String databasePath;
  final String receiptsPath;
  final DateTime createdAt;
}

/// ZIP backup of all data: the SQLite database plus the receipts folder.
///
/// ```
/// autotrack-backup-20261013-1530.zip
/// ├── manifest.json        app id, schema version, date
/// ├── autotrack.sqlite     consistent snapshot (VACUUM INTO)
/// └── receipts/…           photos
/// ```
class BackupService {
  BackupService({
    required this.db,
    required this.databaseFile,
    required this.receiptsDir,
  });

  final AppDatabase db;

  /// The live database file (`<app documents>/autotrack.sqlite`).
  final File databaseFile;
  final Directory receiptsDir;

  static const _manifest = 'manifest.json';
  static const _database = 'autotrack.sqlite';
  static const _receipts = 'receipts';
  static const _appId = 'autotrack';

  /// Creates the backup in [tempDir] and returns the ZIP file.
  Future<File> create(Directory tempDir, {DateTime? now}) async {
    final time = now ?? DateTime.now();
    final snapshot = File(p.join(tempDir.path, 'snapshot.sqlite'));
    if (snapshot.existsSync()) snapshot.deleteSync();

    // A consistent copy even while the app keeps using the database.
    await db.customStatement('VACUUM INTO ?', [snapshot.path]);

    final zipPath = p.join(
      tempDir.path,
      'autotrack-backup-${DateFormat('yyyyMMdd-HHmm').format(time)}.zip',
    );
    final manifest = jsonEncode({
      'app': _appId,
      'schemaVersion': db.schemaVersion,
      'createdAt': time.toIso8601String(),
    });
    final receiptsPath = receiptsDir.path;

    // Compressing all photos takes a while: do it off the UI thread.
    await Isolate.run(() {
      final encoder = ZipFileEncoder()..create(zipPath);
      encoder.addArchiveFile(ArchiveFile.string(_manifest, manifest));
      encoder.addFileSync(File(snapshot.path), _database);
      final receipts = Directory(receiptsPath);
      if (receipts.existsSync()) {
        for (final f in receipts.listSync().whereType<File>()) {
          encoder.addFileSync(f, '$_receipts/${p.basename(f.path)}');
        }
      }
      encoder.closeSync();
    });

    snapshot.deleteSync();
    return File(zipPath);
  }

  /// Extracts [zipPath] into [workDir] in a background isolate and checks
  /// that it is a backup this app version can read.
  static Future<UnpackedBackup> unpack(
    String zipPath,
    Directory workDir, {
    required int currentSchemaVersion,
  }) async {
    final workPath = workDir.path;
    final error = await Isolate.run<String?>(() {
      try {
        final input = InputFileStream(zipPath);
        try {
          // Entries are read lazily, so the stream stays open until
          // everything is extracted.
          final archive = ZipDecoder().decodeStream(input);
          // Garbage input decodes to an empty archive instead of failing.
          if (archive.isEmpty) return 'The file is not a ZIP archive';
          extractArchiveToDiskSync(archive, workPath);
          return null;
        } finally {
          input.closeSync();
        }
      } catch (_) {
        return 'The file is not a ZIP archive';
      }
    });
    if (error != null) throw BackupException(error);

    final manifestFile = File(p.join(workPath, _manifest));
    if (!manifestFile.existsSync()) {
      throw const BackupException('This is not an AutoTrack backup');
    }
    final Map<String, dynamic> manifest;
    try {
      manifest = jsonDecode(manifestFile.readAsStringSync());
    } on FormatException {
      throw const BackupException('The backup is damaged');
    }
    if (manifest['app'] != _appId) {
      throw const BackupException('This is not an AutoTrack backup');
    }
    final version = manifest['schemaVersion'];
    if (version is! int || version > currentSchemaVersion) {
      throw const BackupException(
        'The backup was made by a newer version of the app',
      );
    }

    final database = File(p.join(workPath, _database));
    if (!database.existsSync() || !_isSqlite(database)) {
      throw const BackupException('The backup is damaged');
    }
    return UnpackedBackup(
      databasePath: database.path,
      receiptsPath: p.join(workPath, _receipts),
      createdAt:
          DateTime.tryParse(manifest['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Replaces the database file and all photos with the backup.
  /// The database must be closed before and reopened after.
  void replaceData(UnpackedBackup backup) {
    // WAL and journal files of the old database must go as well.
    for (final suffix in ['', '-wal', '-shm', '-journal']) {
      final f = File('${databaseFile.path}$suffix');
      if (f.existsSync()) f.deleteSync();
    }
    File(backup.databasePath).copySync(databaseFile.path);

    if (receiptsDir.existsSync()) {
      for (final f in receiptsDir.listSync().whereType<File>()) {
        f.deleteSync();
      }
    } else {
      receiptsDir.createSync(recursive: true);
    }
    final source = Directory(backup.receiptsPath);
    if (source.existsSync()) {
      for (final f in source.listSync().whereType<File>()) {
        f.copySync(p.join(receiptsDir.path, p.basename(f.path)));
      }
    }
  }

  /// SQLite files start with "SQLite format 3\0".
  static bool _isSqlite(File file) {
    final raf = file.openSync();
    try {
      final header = raf.readSync(16);
      return utf8.decode(header, allowMalformed: true) ==
          'SQLite format 3\u0000';
    } finally {
      raf.closeSync();
    }
  }
}

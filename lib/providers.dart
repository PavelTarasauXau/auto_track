import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/db/database.dart';
import 'data/repositories/attachment_repository.dart';
import 'data/repositories/record_repository.dart';
import 'data/repositories/reminder_repository.dart';
import 'data/repositories/task_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'services/file_storage.dart';

/// The app database. Overridden with an in-memory one in tests.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Resolved asynchronously in `main()` and injected via an override.
final fileStorageProvider = Provider<FileStorage>(
  (ref) => throw UnimplementedError('Override fileStorageProvider in main()'),
);

final vehicleRepositoryProvider = Provider(
  (ref) => VehicleRepository(
    ref.watch(databaseProvider),
    ref.watch(fileStorageProvider),
  ),
);

final recordRepositoryProvider = Provider(
  (ref) => RecordRepository(
    ref.watch(databaseProvider),
    ref.watch(fileStorageProvider),
  ),
);

final taskRepositoryProvider = Provider(
  (ref) => TaskRepository(ref.watch(databaseProvider)),
);

final reminderRepositoryProvider = Provider(
  (ref) => ReminderRepository(ref.watch(databaseProvider)),
);

final attachmentRepositoryProvider = Provider(
  (ref) => AttachmentRepository(
    ref.watch(databaseProvider),
    ref.watch(fileStorageProvider),
  ),
);

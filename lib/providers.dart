import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/db/database.dart';
import 'data/repositories/attachment_repository.dart';
import 'data/repositories/record_models.dart';
import 'data/repositories/record_repository.dart';
import 'data/repositories/reminder_repository.dart';
import 'data/repositories/task_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'domain/task_view.dart';
import 'services/backup_service.dart';
import 'services/file_storage.dart';
import 'services/photo_picker.dart';

// ---------------------------------------------------------------------------
// Infrastructure

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

/// Resolved asynchronously in `main()` and injected via an override.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError('Override sharedPreferencesProvider in main()'),
);

/// Camera / gallery access. Replaced with a fake in widget tests.
final photoPickerProvider = Provider((ref) => const PhotoPicker());

/// Compresses a picked photo into storage and returns its file name.
/// Replaced in widget tests, where background isolates cannot run.
final photoImporterProvider = Provider<Future<String> Function(String path)>(
  (ref) => ref.watch(fileStorageProvider).importImage,
);

// ---------------------------------------------------------------------------
// Repositories

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

// ---------------------------------------------------------------------------
// Vehicles

final vehiclesProvider = StreamProvider<List<Vehicle>>(
  (ref) => ref.watch(vehicleRepositoryProvider).watchAll(),
);

final odometerLogProvider = StreamProvider.family<List<OdometerLog>, int>(
  (ref, vehicleId) =>
      ref.watch(vehicleRepositoryProvider).watchOdometerLog(vehicleId),
);

/// Id of the vehicle chosen in the garage, remembered between launches.
final selectedVehicleIdProvider = NotifierProvider<SelectedVehicleId, int?>(
  SelectedVehicleId.new,
);

class SelectedVehicleId extends Notifier<int?> {
  static const _key = 'selected_vehicle_id';

  @override
  int? build() => ref.watch(sharedPreferencesProvider).getInt(_key);

  Future<void> select(int id) async {
    state = id;
    await ref.read(sharedPreferencesProvider).setInt(_key, id);
  }
}

/// The vehicle all tabs work with. Falls back to the first vehicle when
/// nothing is selected or the selected one was deleted; `null` when the
/// garage is empty.
final currentVehicleProvider = Provider<AsyncValue<Vehicle?>>((ref) {
  final selectedId = ref.watch(selectedVehicleIdProvider);
  return ref
      .watch(vehiclesProvider)
      .whenData(
        (vehicles) => vehicles.isEmpty
            ? null
            : vehicles.firstWhere(
                (v) => v.id == selectedId,
                orElse: () => vehicles.first,
              ),
      );
});

// ---------------------------------------------------------------------------
// Records and tasks

/// A record with fuel data, items, photos and completed tasks.
final recordDetailsProvider = StreamProvider.family<RecordDetails?, int>(
  (ref, id) => ref.watch(recordRepositoryProvider).watchDetails(id),
);

/// The latest records of a vehicle, for the dashboard.
final recentRecordsProvider = StreamProvider.family<List<ServiceRecord>, int>(
  (ref, vehicleId) =>
      ref.watch(recordRepositoryProvider).watchRecords(vehicleId, limit: 3),
);

final activeTasksProvider = StreamProvider.family<List<MaintenanceTask>, int>(
  (ref, vehicleId) => ref.watch(taskRepositoryProvider).watchActive(vehicleId),
);

final completedTasksProvider =
    StreamProvider.family<List<MaintenanceTask>, int>(
      (ref, vehicleId) =>
          ref.watch(taskRepositoryProvider).watchCompleted(vehicleId),
    );

final allActiveTasksProvider = StreamProvider<List<MaintenanceTask>>(
  (ref) => ref.watch(taskRepositoryProvider).watchAllActive(),
);

/// Active tasks of a vehicle with their status, most urgent first.
final taskViewsProvider = Provider.family<AsyncValue<List<TaskView>>, int>((
  ref,
  vehicleId,
) {
  final tasks = ref.watch(activeTasksProvider(vehicleId));
  final vehicle = ref
      .watch(vehiclesProvider)
      .value
      ?.where((v) => v.id == vehicleId)
      .firstOrNull;
  final logs = ref.watch(odometerLogProvider(vehicleId)).value ?? const [];
  return tasks.whenData(
    (list) => vehicle == null
        ? const []
        : buildTaskViews(
            list,
            currentOdo: vehicle.currentOdo,
            logs: logs,
            now: DateTime.now(),
          ),
  );
});

// ---------------------------------------------------------------------------
// Statistics

final allRecordsProvider = StreamProvider.family<List<ServiceRecord>, int>(
  (ref, vehicleId) => ref.watch(recordRepositoryProvider).watchAll(vehicleId),
);

final fuelRecordsProvider =
    StreamProvider.family<List<(ServiceRecord, FuelDetail)>, int>(
      (ref, vehicleId) =>
          ref.watch(recordRepositoryProvider).watchFuelRecords(vehicleId),
    );

// ---------------------------------------------------------------------------
// Export & backup (platform access behind providers so tests can fake it)

/// Where exported files are written before sharing.
final tempDirProvider = Provider<Future<Directory> Function()>(
  (ref) => getTemporaryDirectory,
);

/// Opens the system share sheet for a file.
final shareFileProvider =
    Provider<Future<void> Function(String path, String subject)>(
      (ref) => (path, subject) async {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(path)], subject: subject),
        );
      },
    );

/// Lets the user pick a backup ZIP; `null` when cancelled.
final pickBackupFileProvider = Provider<Future<String?> Function()>(
  (ref) => () async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    return files.firstOrNull?.path;
  },
);

final backupServiceProvider = Provider((ref) {
  final storage = ref.watch(fileStorageProvider);
  return BackupService(
    db: ref.watch(databaseProvider),
    // drift_flutter keeps the database next to the receipts folder, in the
    // app documents directory.
    databaseFile: File(
      p.join(storage.directory.parent.path, '${AppDatabase.fileName}.sqlite'),
    ),
    receiptsDir: storage.directory,
  );
});

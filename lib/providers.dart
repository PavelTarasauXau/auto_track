import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/db/database.dart';
import 'data/repositories/attachment_repository.dart';
import 'data/repositories/record_repository.dart';
import 'data/repositories/reminder_repository.dart';
import 'data/repositories/task_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'services/file_storage.dart';

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

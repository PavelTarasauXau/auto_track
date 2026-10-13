import 'package:drift/drift.dart';

import '../../services/file_storage.dart';
import '../db/database.dart';

class VehicleRepository {
  VehicleRepository(this._db, this._files);

  final AppDatabase _db;
  final FileStorage _files;

  Stream<List<Vehicle>> watchAll() => (_db.select(
    _db.vehicles,
  )..orderBy([(v) => OrderingTerm.asc(v.createdAt)])).watch();

  Stream<Vehicle?> watchById(int id) => (_db.select(
    _db.vehicles,
  )..where((v) => v.id.equals(id))).watchSingleOrNull();

  Future<Vehicle?> getById(int id) => (_db.select(
    _db.vehicles,
  )..where((v) => v.id.equals(id))).getSingleOrNull();

  /// Inserts when [vehicle] has no id, updates otherwise. Returns the id.
  Future<int> save(VehiclesCompanion vehicle) async {
    if (vehicle.id.present) {
      await (_db.update(
        _db.vehicles,
      )..where((v) => v.id.equals(vehicle.id.value))).write(vehicle);
      return vehicle.id.value;
    }
    return _db.transaction(() async {
      final id = await _db.into(_db.vehicles).insert(vehicle);
      final odo = vehicle.currentOdo.present ? vehicle.currentOdo.value : 0;
      await _logOdometer(id, odo, DateTime.now());
      return id;
    });
  }

  /// Sets a new odometer reading. Lower values than the current one are
  /// allowed (typo fixes), the UI is responsible for warning the user.
  Future<void> updateOdometer(int vehicleId, int value, {DateTime? date}) {
    return _db.transaction(() async {
      await (_db.update(_db.vehicles)..where((v) => v.id.equals(vehicleId)))
          .write(VehiclesCompanion(currentOdo: Value(value)));
      await _logOdometer(vehicleId, value, date ?? DateTime.now());
    });
  }

  Stream<List<OdometerLog>> watchOdometerLog(int vehicleId) =>
      (_db.select(_db.odometerLogs)
            ..where((l) => l.vehicleId.equals(vehicleId))
            ..orderBy([(l) => OrderingTerm.asc(l.date)]))
          .watch();

  /// Deletes the vehicle with all its data (cascade) and photo files.
  Future<void> delete(int id) async {
    final vehicle = await getById(id);
    if (vehicle == null) return;
    final files =
        await (_db.selectOnly(_db.attachments)
              ..addColumns([_db.attachments.fileName])
              ..where(_db.attachments.vehicleId.equals(id)))
            .map((row) => row.read(_db.attachments.fileName)!)
            .get();

    await _db.transaction(() async {
      // The FTS table is not covered by foreign keys.
      await _db.customStatement(
        'DELETE FROM record_search WHERE rowid IN '
        '(SELECT id FROM service_records WHERE vehicle_id = ?)',
        [id],
      );
      await (_db.delete(_db.vehicles)..where((v) => v.id.equals(id))).go();
    });

    await _files.deleteAll([...files, ?vehicle.photoFileName]);
  }

  Future<void> _logOdometer(int vehicleId, int value, DateTime date) => _db
      .into(_db.odometerLogs)
      .insert(
        OdometerLogsCompanion.insert(
          vehicleId: vehicleId,
          date: date,
          value: value,
        ),
      );
}

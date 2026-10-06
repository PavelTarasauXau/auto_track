import 'package:drift/drift.dart';

import '../../core/enums.dart';
import '../db/database.dart';

class ReminderRepository {
  ReminderRepository(this._db);

  final AppDatabase _db;

  /// Reminders of a vehicle plus general ones (without a vehicle).
  Stream<List<Reminder>> watchForVehicle(int? vehicleId) {
    final query = _db.select(_db.reminders)
      ..orderBy([
        (r) => OrderingTerm.asc(r.isDone),
        (r) => OrderingTerm.asc(r.remindAt),
      ]);
    if (vehicleId != null) {
      query.where((r) => r.vehicleId.equals(vehicleId) | r.vehicleId.isNull());
    }
    return query.watch();
  }

  /// Reminders that still have to fire (notification scheduling).
  Future<List<Reminder>> getPending() =>
      (_db.select(_db.reminders)..where((r) => r.isDone.not())).get();

  Future<int> save({
    int? id,
    int? vehicleId,
    required String title,
    String? note,
    required DateTime remindAt,
    RepeatRule repeat = RepeatRule.none,
  }) async {
    final companion = RemindersCompanion(
      vehicleId: Value(vehicleId),
      title: Value(title.trim()),
      note: Value(note),
      remindAt: Value(remindAt),
      repeat: Value(repeat),
      isDone: const Value(false),
    );
    if (id == null) return _db.into(_db.reminders).insert(companion);
    await (_db.update(
      _db.reminders,
    )..where((r) => r.id.equals(id))).write(companion);
    return id;
  }

  Future<void> setDone(int id, bool done) =>
      (_db.update(_db.reminders)..where((r) => r.id.equals(id))).write(
        RemindersCompanion(isDone: Value(done)),
      );

  Future<void> delete(int id) =>
      (_db.delete(_db.reminders)..where((r) => r.id.equals(id))).go();
}

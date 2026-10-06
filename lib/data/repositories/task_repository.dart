import 'package:drift/drift.dart';

import '../../domain/task_schedule.dart';
import '../db/database.dart';

class TaskDraft {
  const TaskDraft({
    this.id,
    required this.vehicleId,
    required this.title,
    this.intervalKm,
    this.intervalDays,
    this.lastDoneOdo,
    this.lastDoneDate,
    this.fixedDueOdo,
    this.fixedDueDate,
    this.remindBeforeKm = 500,
    this.remindBeforeDays = 14,
    this.note,
  });

  final int? id;
  final int vehicleId;
  final String title;

  /// Recurring task: at least one interval is set.
  final int? intervalKm;
  final int? intervalDays;
  final int? lastDoneOdo;
  final DateTime? lastDoneDate;

  /// One-off task (or a recurring one never done): explicit due point.
  final int? fixedDueOdo;
  final DateTime? fixedDueDate;

  final int remindBeforeKm;
  final int remindBeforeDays;
  final String? note;
}

class TaskRepository {
  TaskRepository(this._db);

  final AppDatabase _db;

  /// Active tasks of a vehicle. Sorting by urgency is done in the UI layer
  /// because it depends on the current odometer.
  Stream<List<MaintenanceTask>> watchActive(int vehicleId) =>
      (_db.select(_db.maintenanceTasks)
            ..where((t) => t.vehicleId.equals(vehicleId) & t.isActive)
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  /// Completed one-off tasks.
  Stream<List<MaintenanceTask>> watchCompleted(int vehicleId) =>
      (_db.select(_db.maintenanceTasks)
            ..where((t) => t.vehicleId.equals(vehicleId) & t.isActive.not())
            ..orderBy([(t) => OrderingTerm.desc(t.lastDoneDate)]))
          .watch();

  /// Active tasks of all vehicles (notification scheduling).
  Future<List<MaintenanceTask>> getAllActive() =>
      (_db.select(_db.maintenanceTasks)..where((t) => t.isActive)).get();

  Future<MaintenanceTask?> getById(int id) => (_db.select(
    _db.maintenanceTasks,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> save(TaskDraft draft) async {
    final due = computeDue(
      intervalKm: draft.intervalKm,
      intervalDays: draft.intervalDays,
      lastDoneOdo: draft.lastDoneOdo,
      lastDoneDate: draft.lastDoneDate,
      fixedOdo: draft.fixedDueOdo,
      fixedDate: draft.fixedDueDate,
    );
    final companion = MaintenanceTasksCompanion(
      vehicleId: Value(draft.vehicleId),
      title: Value(draft.title.trim()),
      intervalKm: Value(draft.intervalKm),
      intervalDays: Value(draft.intervalDays),
      lastDoneOdo: Value(draft.lastDoneOdo),
      lastDoneDate: Value(draft.lastDoneDate),
      dueOdo: Value(due.odo),
      dueDate: Value(due.date),
      remindBeforeKm: Value(draft.remindBeforeKm),
      remindBeforeDays: Value(draft.remindBeforeDays),
      note: Value(draft.note),
      isActive: const Value(true),
    );
    if (draft.id == null) {
      return _db.into(_db.maintenanceTasks).insert(companion);
    }
    await (_db.update(
      _db.maintenanceTasks,
    )..where((t) => t.id.equals(draft.id!))).write(companion);
    return draft.id!;
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.maintenanceTasks)..where((t) => t.id.equals(id))).go();
}

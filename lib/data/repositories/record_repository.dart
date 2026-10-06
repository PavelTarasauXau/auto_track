import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../core/enums.dart';
import '../../domain/task_schedule.dart';
import '../../services/file_storage.dart';
import '../db/database.dart';
import 'record_models.dart';

class RecordRepository {
  RecordRepository(this._db, this._files);

  final AppDatabase _db;
  final FileStorage _files;

  /// Records of a vehicle, newest first. The list grows with [limit]
  /// (infinite scroll) and updates automatically when data changes.
  Stream<List<ServiceRecord>> watchRecords(
    int vehicleId, {
    RecordFilter filter = const RecordFilter(),
    int limit = 30,
  }) {
    final query = _db.select(_db.serviceRecords)
      ..where((r) => r.vehicleId.equals(vehicleId));
    if (filter.types.isNotEmpty) {
      query.where((r) => r.type.isInValues(filter.types));
    }
    if (filter.from != null) {
      query.where((r) => r.date.isBiggerOrEqualValue(filter.from!));
    }
    final match = ftsMatchQuery(filter.query);
    if (match != null) {
      // Custom expressions cannot take bound variables, so the (already
      // sanitized) match string is inlined as an escaped SQL literal.
      final literal = "'${match.replaceAll("'", "''")}'";
      query.where(
        (r) => CustomExpression<bool>(
          'service_records.id IN (SELECT rowid FROM record_search '
          'WHERE record_search MATCH $literal)',
        ),
      );
    }
    query
      ..orderBy([
        (r) => OrderingTerm.desc(r.date),
        (r) => OrderingTerm.desc(r.id),
      ])
      ..limit(limit);
    return query.watch();
  }

  /// All records of a vehicle in chronological order (stats, export).
  Future<List<ServiceRecord>> getAll(int vehicleId) =>
      (_db.select(_db.serviceRecords)
            ..where((r) => r.vehicleId.equals(vehicleId))
            ..orderBy([(r) => OrderingTerm.asc(r.date)]))
          .get();

  /// Fuel records joined with their details, chronological.
  Future<List<(ServiceRecord, FuelDetail)>> getFuelRecords(int vehicleId) {
    final query =
        _db.select(_db.serviceRecords).join([
            innerJoin(
              _db.fuelDetails,
              _db.fuelDetails.recordId.equalsExp(_db.serviceRecords.id),
            ),
          ])
          ..where(_db.serviceRecords.vehicleId.equals(vehicleId))
          ..orderBy([OrderingTerm.asc(_db.serviceRecords.odometer)]);
    return query
        .map(
          (row) => (
            row.readTable(_db.serviceRecords),
            row.readTable(_db.fuelDetails),
          ),
        )
        .get();
  }

  Stream<RecordDetails?> watchDetails(int id) {
    // Re-run when any of the related tables change.
    final trigger = _db
        .customSelect(
          'SELECT 1',
          readsFrom: {
            _db.serviceRecords,
            _db.fuelDetails,
            _db.recordItems,
            _db.attachments,
            _db.recordTasks,
            _db.maintenanceTasks,
          },
        )
        .watch();
    return trigger.asyncMap((_) => getDetails(id));
  }

  Future<RecordDetails?> getDetails(int id) async {
    final record = await (_db.select(
      _db.serviceRecords,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (record == null) return null;

    final fuel = await (_db.select(
      _db.fuelDetails,
    )..where((f) => f.recordId.equals(id))).getSingleOrNull();
    final items =
        await (_db.select(_db.recordItems)
              ..where((i) => i.recordId.equals(id))
              ..orderBy([(i) => OrderingTerm.asc(i.position)]))
            .get();
    final attachments =
        await (_db.select(_db.attachments)
              ..where((a) => a.recordId.equals(id))
              ..orderBy([(a) => OrderingTerm.asc(a.id)]))
            .get();
    final tasks =
        await (_db.select(_db.maintenanceTasks).join([
              innerJoin(
                _db.recordTasks,
                _db.recordTasks.taskId.equalsExp(_db.maintenanceTasks.id),
              ),
            ])..where(_db.recordTasks.recordId.equals(id)))
            .map((row) => row.readTable(_db.maintenanceTasks))
            .get();

    return RecordDetails(
      record: record,
      fuel: fuel,
      items: items,
      attachments: attachments,
      completedTasks: tasks,
    );
  }

  /// Creates or updates a record with all related data. Also:
  /// - raises the vehicle odometer if the record has a higher reading;
  /// - marks [RecordDraft.completedTaskIds] as done and reschedules them;
  /// - deletes files of attachments removed from the record.
  Future<int> save(RecordDraft draft) async {
    final removedFiles = <String>[];

    final id = await _db.transaction(() async {
      final companion = ServiceRecordsCompanion(
        vehicleId: Value(draft.vehicleId),
        type: Value(draft.type),
        date: Value(draft.date),
        odometer: Value(draft.odometer),
        title: Value(draft.title),
        station: Value(_blankToNull(draft.station)),
        cost: Value(draft.cost),
        note: Value(_blankToNull(draft.note)),
      );

      final int id;
      if (draft.id == null) {
        id = await _db.into(_db.serviceRecords).insert(companion);
      } else {
        id = draft.id!;
        await (_db.update(
          _db.serviceRecords,
        )..where((r) => r.id.equals(id))).write(companion);
      }

      await _saveFuel(id, draft);
      await _saveItems(id, draft.items);
      removedFiles.addAll(await _saveAttachments(id, draft));
      await _saveCompletedTasks(id, draft);
      await _raiseOdometer(draft.vehicleId, draft.odometer, draft.date);
      await _updateSearchIndex(id, draft);
      return id;
    });

    await _files.deleteAll(removedFiles);
    return id;
  }

  /// Deletes the record, its related rows (cascade) and attachment files.
  Future<void> delete(int id) async {
    final files =
        await (_db.selectOnly(_db.attachments)
              ..addColumns([_db.attachments.fileName])
              ..where(_db.attachments.recordId.equals(id)))
            .map((row) => row.read(_db.attachments.fileName)!)
            .get();

    await _db.transaction(() async {
      await _db.customStatement('DELETE FROM record_search WHERE rowid = ?', [
        id,
      ]);
      await (_db.delete(
        _db.serviceRecords,
      )..where((r) => r.id.equals(id))).go();
    });

    await _files.deleteAll(files);
  }

  Future<void> _saveFuel(int recordId, RecordDraft draft) async {
    final fuel = draft.fuel;
    if (draft.type == RecordType.fuel && fuel != null) {
      await _db
          .into(_db.fuelDetails)
          .insertOnConflictUpdate(
            FuelDetailsCompanion.insert(
              recordId: Value(recordId),
              liters: fuel.liters,
              pricePerLiter: fuel.pricePerLiter,
              fullTank: Value(fuel.fullTank),
            ),
          );
    } else {
      await (_db.delete(
        _db.fuelDetails,
      )..where((f) => f.recordId.equals(recordId))).go();
    }
  }

  Future<void> _saveItems(int recordId, List<ItemDraft> items) async {
    await (_db.delete(
      _db.recordItems,
    )..where((i) => i.recordId.equals(recordId))).go();
    await _db.batch((b) {
      b.insertAll(_db.recordItems, [
        for (final (i, item) in items.indexed)
          RecordItemsCompanion.insert(
            recordId: recordId,
            kind: item.kind,
            name: item.name.trim(),
            partNumber: Value(_blankToNull(item.partNumber)),
            cost: Value(item.cost),
            position: Value(i),
          ),
      ]);
    });
  }

  /// Returns file names of attachments that were removed.
  Future<List<String>> _saveAttachments(int recordId, RecordDraft draft) async {
    final existing = await (_db.select(
      _db.attachments,
    )..where((a) => a.recordId.equals(recordId))).get();
    final keptIds = {
      for (final a in draft.attachments)
        if (a.id != null) a.id!,
    };

    final removed = existing.where((a) => !keptIds.contains(a.id)).toList();
    if (removed.isNotEmpty) {
      await (_db.delete(
        _db.attachments,
      )..where((a) => a.id.isIn(removed.map((a) => a.id)))).go();
    }

    for (final a in draft.attachments) {
      final companion = AttachmentsCompanion(
        vehicleId: Value(draft.vehicleId),
        recordId: Value(recordId),
        fileName: Value(a.fileName),
        docType: Value(a.docType),
        caption: Value(_blankToNull(a.caption)),
      );
      if (a.id == null) {
        await _db.into(_db.attachments).insert(companion);
      } else {
        await (_db.update(
          _db.attachments,
        )..where((row) => row.id.equals(a.id!))).write(companion);
      }
    }
    return removed.map((a) => a.fileName).toList();
  }

  Future<void> _saveCompletedTasks(int recordId, RecordDraft draft) async {
    final before = await (_db.select(
      _db.recordTasks,
    )..where((t) => t.recordId.equals(recordId))).map((t) => t.taskId).get();

    await (_db.delete(
      _db.recordTasks,
    )..where((t) => t.recordId.equals(recordId))).go();
    for (final taskId in draft.completedTaskIds) {
      await _db
          .into(_db.recordTasks)
          .insert(
            RecordTasksCompanion.insert(recordId: recordId, taskId: taskId),
          );
    }

    // Unchecking a task later does not roll back its schedule; only newly
    // linked tasks are rescheduled.
    final newlyCompleted = draft.completedTaskIds.difference(before.toSet());
    for (final taskId in newlyCompleted) {
      await completeTask(taskId, odo: draft.odometer, date: draft.date);
    }
  }

  /// Marks a task as done at the given point and computes the next due one.
  /// Older completions (e.g. a record entered retroactively) are ignored.
  Future<void> completeTask(
    int taskId, {
    required int odo,
    required DateTime date,
  }) async {
    final task = await (_db.select(
      _db.maintenanceTasks,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (task == null) return;
    if (task.lastDoneDate != null && date.isBefore(task.lastDoneDate!)) return;

    final recurring = task.intervalKm != null || task.intervalDays != null;
    final due = computeDue(
      intervalKm: task.intervalKm,
      intervalDays: task.intervalDays,
      lastDoneOdo: odo,
      lastDoneDate: date,
    );
    await (_db.update(
      _db.maintenanceTasks,
    )..where((t) => t.id.equals(taskId))).write(
      MaintenanceTasksCompanion(
        lastDoneOdo: Value(odo),
        lastDoneDate: Value(date),
        dueOdo: Value(recurring ? due.odo : task.dueOdo),
        dueDate: Value(recurring ? due.date : task.dueDate),
        isActive: Value(recurring),
      ),
    );
  }

  Future<void> _raiseOdometer(
    int vehicleId,
    int odometer,
    DateTime date,
  ) async {
    final vehicle = await (_db.select(
      _db.vehicles,
    )..where((v) => v.id.equals(vehicleId))).getSingle();
    if (odometer <= vehicle.currentOdo) return;
    await (_db.update(_db.vehicles)..where((v) => v.id.equals(vehicleId)))
        .write(VehiclesCompanion(currentOdo: Value(odometer)));
    await _db
        .into(_db.odometerLogs)
        .insert(
          OdometerLogsCompanion.insert(
            vehicleId: vehicleId,
            date: date,
            value: odometer,
          ),
        );
  }

  Future<void> _updateSearchIndex(int id, RecordDraft draft) async {
    final text = [
      draft.title,
      draft.type.label,
      draft.station,
      draft.note,
      for (final item in draft.items) ...[item.name, item.partNumber],
      for (final a in draft.attachments) a.caption,
      // Several date formats so that "2026-03", "03.2026" or "March" match.
      DateFormat('yyyy-MM-dd dd.MM.yyyy MMMM yyyy').format(draft.date),
    ].whereType<String>().join(' ');

    await _db.customStatement('DELETE FROM record_search WHERE rowid = ?', [
      id,
    ]);
    await _db.customStatement(
      'INSERT INTO record_search(rowid, content) VALUES (?, ?)',
      [id, text],
    );
  }
}

/// Turns user input into an FTS5 prefix query: `oil filt` → `"oil"* "filt"*`.
/// Returns `null` for an empty query.
String? ftsMatchQuery(String? input) {
  final tokens = (input ?? '')
      .split(RegExp(r'[\s.,;:/\\-]+'))
      .where((t) => t.isNotEmpty)
      .map((t) => '"${t.replaceAll('"', '""')}"*');
  return tokens.isEmpty ? null : tokens.join(' ');
}

String? _blankToNull(String? s) {
  final trimmed = s?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

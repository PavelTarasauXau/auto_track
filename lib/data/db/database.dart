import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/enums.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Vehicles,
    OdometerLogs,
    ServiceRecords,
    FuelDetails,
    RecordItems,
    MaintenanceTasks,
    RecordTasks,
    Reminders,
    Attachments,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device database. Pass [executor] to use another one,
  /// e.g. `NativeDatabase.memory()` in tests.
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: fileName));

  /// Stored as `<app documents>/autotrack.sqlite`.
  static const fileName = 'autotrack';

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Full-text index over records. rowid = service_records.id;
      // kept in sync by RecordRepository.
      await customStatement(
        "CREATE VIRTUAL TABLE record_search USING fts5(content, tokenize = 'unicode61')",
      );
    },
    beforeOpen: (details) async {
      // SQLite ignores ON DELETE CASCADE unless this is enabled.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  bool _closed = false;

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await super.close();
  }
}

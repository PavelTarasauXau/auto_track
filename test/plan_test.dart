import 'dart:io';

import 'package:auto_track/app.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/task_repository.dart';
import 'package:auto_track/domain/maintenance_templates.dart';
import 'package:auto_track/features/plan/task_tile.dart';
import 'package:auto_track/providers.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late TaskRepository tasks;
  late int carId;

  setUp(() async {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    tempDir = Directory.systemTemp.createTempSync('autotrack_plan');
    tasks = TaskRepository(db);
    SharedPreferences.setMockInitialValues({});
    carId = await db
        .into(db.vehicles)
        .insert(
          VehiclesCompanion.insert(
            brand: 'Toyota',
            model: 'Corolla',
            currentOdo: const Value(50000),
          ),
        );
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          fileStorageProvider.overrideWithValue(FileStorage(tempDir)),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const AutoTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPlan(WidgetTester tester) async {
    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  /// Oil change done at 40,300 km → due at 50,300 km: 300 km left.
  Future<int> addOilTask() => tasks.save(
    TaskDraft(
      vehicleId: carId,
      title: 'Engine oil',
      intervalKm: 10000,
      lastDoneOdo: 40300,
    ),
  );

  testWidgets('templates fill an empty plan', (tester) async {
    await pumpApp(tester);
    await openPlan(tester);
    expect(find.text('No maintenance plan yet'), findsOneWidget);

    await tester.tap(find.text('Add from templates'));
    await tester.pumpAndSettle();
    final common = maintenanceTemplates.where((t) => t.common).length;
    await tester.tap(find.text('Add $common tasks'));
    await tester.pumpAndSettle();

    // The list builds tiles lazily, so count the saved tasks.
    final saved = await db.select(db.maintenanceTasks).get();
    expect(saved, hasLength(common));
    expect(find.byType(TaskTile), findsWidgets);
    final oil = saved.firstWhere((t) => t.title == 'Engine oil & filter');
    expect(oil.dueOdo, 60000); // counted from the current mileage
    expect(oil.dueDate, isNotNull);
  });

  testWidgets('a recurring task created in the form becomes due soon', (
    tester,
  ) async {
    await pumpApp(tester);
    await openPlan(tester);
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    await tester.enterText(field('Task *'), 'Engine oil');
    await tester.enterText(field('Kilometers').first, '10000');
    await tester.enterText(field('Mileage'), '40300');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Engine oil'), findsOneWidget);
    expect(find.text('in 300 km'), findsOneWidget);

    // The dashboard lists it under Maintenance.
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Engine oil'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('in 300 km'), findsOneWidget);
  });

  testWidgets('recurring task needs an interval', (tester) async {
    await pumpApp(tester);
    await openPlan(tester);
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();

    await tester.enterText(field('Task *'), 'Something');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Set an interval'), findsOneWidget);
    expect(await db.select(db.maintenanceTasks).get(), isEmpty);
  });

  testWidgets('mark done reschedules the task', (tester) async {
    final id = await addOilTask();
    await pumpApp(tester);
    await openPlan(tester);
    expect(find.text('in 300 km'), findsOneWidget);

    await tester.tap(find.byTooltip('Task actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark done'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Mileage'), '50200');
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.text('in 10,000 km'), findsOneWidget);
    final task = await tasks.getById(id);
    expect(task!.lastDoneOdo, 50200);
    expect(task.dueOdo, 60200);
    // The odometer is raised to the reported mileage.
    final car = await db.select(db.vehicles).getSingle();
    expect(car.currentOdo, 50200);
  });

  testWidgets('log service from a task preselects it in the record form', (
    tester,
  ) async {
    final id = await addOilTask();
    await pumpApp(tester);
    await openPlan(tester);

    await tester.tap(find.byTooltip('Task actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log service'));
    await tester.pumpAndSettle();

    final chip = find.widgetWithText(FilterChip, 'Engine oil');
    await tester.scrollUntilVisible(
      chip,
      300,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(tester.widget<FilterChip>(chip).selected, isTrue);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final task = await tasks.getById(id);
    expect(task!.dueOdo, 60000); // done at 50,000 km
    final record = await db.select(db.serviceRecords).getSingle();
    expect(record.title, 'Engine oil');
  });

  testWidgets('overdue one-time task shows a badge in the garage', (
    tester,
  ) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await tasks.save(
      TaskDraft(
        vehicleId: carId,
        title: 'Replace wipers',
        fixedDueDate: DateTime(yesterday.year, yesterday.month, yesterday.day),
      ),
    );
    await pumpApp(tester);
    await openPlan(tester);
    expect(find.text('1 day overdue'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_drop_down)); // opens the garage
    await tester.pumpAndSettle();
    expect(find.text('1 overdue'), findsOneWidget);
  });

  testWidgets('completed one-time task can be restored', (tester) async {
    final id = await tasks.save(
      TaskDraft(vehicleId: carId, title: 'Brake pads', fixedDueOdo: 52000),
    );
    await pumpApp(tester);
    await openPlan(tester);

    await tester.tap(find.byTooltip('Task actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskTile), findsNothing);
    await tester.tap(find.text('Completed (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restore'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskTile), findsOneWidget);
    expect((await tasks.getById(id))!.isActive, isTrue);
  });
}

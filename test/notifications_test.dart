import 'dart:async';
import 'dart:io';

import 'package:auto_track/app.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/task_repository.dart';
import 'package:auto_track/domain/notification_planner.dart';
import 'package:auto_track/notifications.dart';
import 'package:auto_track/providers.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:auto_track/services/notification_service.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records what the app asks the notification system to do.
class FakeGateway implements NotificationGateway {
  List<PlannedNotification> scheduled = [];
  final shown = <String>[];
  final tapController = StreamController<String>.broadcast();
  final permissionRequests = <bool>[]; // exactAlarms flag of each request
  bool enabled = true;

  @override
  Future<void> replaceScheduled(List<PlannedNotification> plan) async =>
      scheduled = plan;

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async => shown.add(title);

  @override
  Future<bool> requestPermissions({bool exactAlarms = false}) async {
    permissionRequests.add(exactAlarms);
    enabled = true;
    return true;
  }

  @override
  Future<bool> notificationsEnabled() async => enabled;

  @override
  Stream<String> get taps => tapController.stream;

  @override
  String? takeLaunchPayload() => null;
}

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FakeGateway gateway;
  late int carId;

  setUp(() async {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    tempDir = Directory.systemTemp.createTempSync('autotrack_notif');
    gateway = FakeGateway();
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
    await gateway.tapController.close();
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // A typical phone screen (Redmi Note 8: 393×851 dp).
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          fileStorageProvider.overrideWithValue(FileStorage(tempDir)),
          sharedPreferencesProvider.overrideWithValue(prefs),
          notificationGatewayProvider.overrideWithValue(gateway),
        ],
        child: const AutoTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openReminders(WidgetTester tester) async {
    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reminders'));
    await tester.pumpAndSettle();
  }

  List<PlannedNotification> scheduledReminders() => gateway.scheduled
      .where((n) => n.channel == NotificationChannel.reminders)
      .toList();

  testWidgets('a new reminder is scheduled and asks for permissions', (
    tester,
  ) async {
    await pumpApp(tester);
    await openReminders(tester);
    expect(find.text('No reminders'), findsOneWidget);

    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Remind me to *'),
      'Refuel',
    );
    await tester.tap(find.text('Tomorrow 18:00'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Refuel'), findsOneWidget);
    expect(find.textContaining('Tomorrow, 18:00'), findsOneWidget);

    final now = DateTime.now();
    final n = scheduledReminders().single;
    expect(n.title, 'Refuel');
    expect(n.body, 'Toyota Corolla');
    expect(n.at, DateTime(now.year, now.month, now.day + 1, 18));
    // Exact alarms are requested for reminders.
    expect(gateway.permissionRequests, contains(true));
  });

  testWidgets('reminder needs a title', (tester) async {
    await pumpApp(tester);
    await openReminders(tester);
    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsOneWidget);
    expect(await db.select(db.reminders).get(), isEmpty);
  });

  testWidgets('one-time reminder cannot be saved in the past', (tester) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await db
        .into(db.reminders)
        .insert(
          RemindersCompanion.insert(title: 'Old one', remindAt: yesterday),
        );
    await pumpApp(tester);
    await openReminders(tester);
    expect(find.textContaining('missed'), findsOneWidget);
    expect(scheduledReminders(), isEmpty);

    await tester.tap(find.text('Old one'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Pick a time in the future'), findsOneWidget);

    // Moving it to tomorrow fixes it.
    await tester.tap(find.text('Tomorrow 9:00'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(scheduledReminders().single.title, 'Old one');
  });

  testWidgets('marking a reminder done removes it from the schedule', (
    tester,
  ) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await db
        .into(db.reminders)
        .insert(
          RemindersCompanion.insert(
            vehicleId: Value(carId),
            title: 'Wash the car',
            remindAt: tomorrow,
          ),
        );
    await pumpApp(tester);
    expect(scheduledReminders(), hasLength(1));

    await openReminders(tester);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(scheduledReminders(), isEmpty);
    expect(find.text('Done'), findsOneWidget);
  });

  testWidgets('task that becomes due after an odometer update notifies', (
    tester,
  ) async {
    // Due at 51,000 km: 1,000 km left, more than the 500 km threshold.
    await TaskRepository(db).save(
      TaskDraft(
        vehicleId: carId,
        title: 'Engine oil',
        intervalKm: 10000,
        lastDoneOdo: 41000,
      ),
    );
    await pumpApp(tester);
    expect(gateway.shown, isEmpty); // nothing on start

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Current mileage'),
      '50600',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(gateway.shown, ['Due soon: Engine oil']);
    // The mileage request is part of the plan for vehicles with km tasks.
    expect(
      gateway.scheduled.where((n) => n.channel == NotificationChannel.mileage),
      hasLength(1),
    );
  });

  testWidgets('tapping a notification opens its screen', (tester) async {
    final taskId = await TaskRepository(db)
        .save(TaskDraft(vehicleId: carId, title: 'Wipers', fixedDueOdo: 60000));
    await pumpApp(tester);

    gateway.tapController.add('/task/$taskId/edit');
    await tester.pumpAndSettle();

    expect(find.text('Edit task'), findsOneWidget);
    expect(find.text('Wipers'), findsOneWidget);
  });

  testWidgets('banner offers to enable notifications', (tester) async {
    gateway.enabled = false;
    await pumpApp(tester);
    await openReminders(tester);
    expect(find.text('Notifications are off'), findsOneWidget);

    await tester.tap(find.text('Enable'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications are off'), findsNothing);
    expect(gateway.permissionRequests, contains(true));
  });
}

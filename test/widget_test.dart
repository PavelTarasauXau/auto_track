import 'dart:io';

import 'package:auto_track/app.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/providers.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('autotrack_widget');
    SharedPreferences.setMockInitialValues({});
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

  /// Unmounts the app so drift stream subscriptions are cancelled
  /// before the test ends.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  }

  testWidgets('bottom navigation switches tabs', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Service history'), findsOneWidget);

    await tester.tap(find.text('Plan'));
    await tester.pumpAndSettle();
    expect(find.text('Maintenance'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('adding the first vehicle shows it on the dashboard', (
    tester,
  ) async {
    await pumpApp(tester);
    expect(find.text('Welcome to AutoTrack'), findsOneWidget);

    await tester.tap(find.text('Add vehicle'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Brand *'),
      'Toyota',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Model *'),
      'Corolla',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Current mileage *'),
      '51000',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Toyota Corolla'), findsWidgets);
    expect(find.text('51,000 km'), findsOneWidget);

    await unmount(tester);
  });

  testWidgets('vehicle form validates required fields', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Add vehicle'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsNWidgets(2));
    expect(find.text('Enter the mileage'), findsOneWidget);
    expect(await db.select(db.vehicles).get(), isEmpty);

    await unmount(tester);
  });

  testWidgets('selecting a vehicle in the garage makes it current', (
    tester,
  ) async {
    await db
        .into(db.vehicles)
        .insert(VehiclesCompanion.insert(brand: 'Toyota', model: 'Corolla'));
    await db
        .into(db.vehicles)
        .insert(
          VehiclesCompanion.insert(
            brand: 'Skoda',
            model: 'Octavia',
            currentOdo: const Value(120000),
          ),
        );
    await pumpApp(tester);
    expect(find.text('Toyota Corolla'), findsWidgets);

    // The app bar title opens the garage.
    await tester.tap(find.byIcon(Icons.arrow_drop_down));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skoda Octavia'));
    await tester.pumpAndSettle();

    expect(find.text('Skoda Octavia'), findsWidgets);
    expect(find.text('120,000 km'), findsOneWidget);

    await unmount(tester);
  });
}

import 'dart:io';

import 'package:auto_track/app.dart';
import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/record_models.dart';
import 'package:auto_track/data/repositories/record_repository.dart';
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
  late RecordRepository records;
  late int carId;

  setUp(() async {
    // Close stream queries without a timer, otherwise the widget test
    // framework reports pending timers after the tree is disposed.
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    tempDir = Directory.systemTemp.createTempSync('autotrack_records');
    records = RecordRepository(db, FileStorage(tempDir));
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
        ],
        child: const AutoTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label) => find.widgetWithText(TextFormField, label);

  String fieldText(WidgetTester tester, String label) => tester
      .widget<EditableText>(
        find.descendant(of: field(label), matching: find.byType(EditableText)),
      )
      .controller
      .text;

  RecordDraft draft(RecordType type, String title, {DateTime? date}) =>
      RecordDraft(
        vehicleId: carId,
        type: type,
        date: date ?? DateTime.now(),
        odometer: 50000,
        title: title,
      );

  testWidgets('refuel calculates the total and raises the odometer', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Refuel'));
    await tester.pumpAndSettle();

    await tester.enterText(field('Mileage *'), '50600');
    await tester.enterText(field('Liters *'), '40');
    await tester.enterText(field('Price per liter'), '1,5');
    await tester.pump();
    expect(fieldText(tester, 'Total cost'), '60.00');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Back on the dashboard: new odometer and the record in "Recent".
    expect(find.text('50,600 km'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Recent records'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('60.00'), findsOneWidget);

    final fuel = await db.select(db.fuelDetails).getSingle();
    expect(fuel.liters, 40);
    expect(fuel.pricePerLiter, 1.5);
  });

  testWidgets('fuel total without price computes the price', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Refuel'));
    await tester.pumpAndSettle();

    await tester.enterText(field('Liters *'), '40');
    await tester.enterText(field('Total cost'), '50');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final fuel = await db.select(db.fuelDetails).getSingle();
    expect(fuel.pricePerLiter, 1.25);
  });

  testWidgets('service with items: create, view details, delete', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('No records yet'), findsOneWidget);

    await tester.tap(find.byTooltip('Add record'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Title'), 'Oil change');

    await tester.tap(find.text('Add work or part'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Part'));
    await tester.pumpAndSettle();
    await tester.enterText(field('Name *'), 'Oil filter');
    await tester.enterText(field('Part number'), 'w712');
    await tester.enterText(field('Cost'), '15');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    expect(find.text('Oil filter'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Total is the sum of items.
    expect(find.text('Oil change'), findsOneWidget);
    expect(find.text('15.00'), findsWidgets);

    await tester.tap(find.text('Oil change'));
    await tester.pumpAndSettle();
    expect(find.text('Works & parts'), findsOneWidget);
    expect(find.text('Oil filter'), findsOneWidget);
    expect(find.text('W712'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('No records yet'), findsOneWidget);
    expect(await db.select(db.serviceRecords).get(), isEmpty);
  });

  testWidgets('editing keeps the data and updates the list', (tester) async {
    final id = await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.fuel,
        date: DateTime.now(),
        odometer: 50000,
        title: 'Fuel',
        cost: 60,
        fuel: const FuelDraft(liters: 40, pricePerLiter: 1.5),
      ),
    );
    await pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Fuel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    expect(fieldText(tester, 'Liters *'), '40');
    expect(fieldText(tester, 'Price per liter'), '1.5');

    await tester.enterText(field('Title'), 'Highway refuel');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Highway refuel'), findsOneWidget); // details
    final saved = await records.getDetails(id);
    expect(saved!.fuel!.liters, 40);
  });

  testWidgets('type filter narrows the list', (tester) async {
    await records.save(draft(RecordType.service, 'Brake service'));
    await records.save(draft(RecordType.wash, 'Full wash'));
    await pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Brake service'), findsOneWidget);
    expect(find.text('Full wash'), findsOneWidget);

    final wash = find.widgetWithText(FilterChip, 'Wash');
    await tester.ensureVisible(wash); // the chip row scrolls horizontally
    await tester.pumpAndSettle();
    await tester.tap(wash);
    await tester.pumpAndSettle();
    expect(find.text('Brake service'), findsNothing);
    expect(find.text('Full wash'), findsOneWidget);
  });

  testWidgets('list loads more records while scrolling', (tester) async {
    final start = DateTime(2026, 1, 1);
    for (var i = 1; i <= 45; i++) {
      await records.save(
        draft(
          RecordType.other,
          'Record $i',
          date: start.add(Duration(days: i)),
        ),
      );
    }
    await pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Record 45'), findsOneWidget); // newest first

    // The oldest record is beyond the first page of 30.
    final list = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    // Loading the next page must keep the list (no spinner, no jump).
    await tester.drag(list, const Offset(0, -2000));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Record 1'),
      500,
      scrollable: list,
    );
    expect(find.text('Record 1'), findsOneWidget);
  });
}

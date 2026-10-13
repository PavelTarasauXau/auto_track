import 'dart:io';

import 'package:auto_track/app.dart';
import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/record_models.dart';
import 'package:auto_track/data/repositories/record_repository.dart';
import 'package:auto_track/providers.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:auto_track/services/photo_picker.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class FakePhotoPicker extends PhotoPicker {
  FakePhotoPicker(this.paths);

  final List<String> paths;

  @override
  Future<List<String>> pick(PhotoSource source) async => paths;
}

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FileStorage storage;
  late RecordRepository records;
  late int carId;
  late String galleryPhoto;
  late List<(String, String)> shared; // (path, subject)
  String? pickedBackup;

  setUp(() async {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    tempDir = Directory.systemTemp.createTempSync('autotrack_screens');
    storage = FileStorage(
      Directory(p.join(tempDir.path, 'receipts'))..createSync(),
    );
    records = RecordRepository(db, storage);
    shared = [];
    pickedBackup = null;
    SharedPreferences.setMockInitialValues({});

    final jpeg = img.encodeJpg(img.Image(width: 8, height: 8));
    galleryPhoto = (File(
      p.join(tempDir.path, 'gallery.jpg'),
    )..writeAsBytesSync(jpeg)).path;
    for (final name in ['receipt.jpg', 'policy.jpg']) {
      File(storage.pathOf(name)).writeAsBytesSync(jpeg);
    }

    carId = await db
        .into(db.vehicles)
        .insert(
          VehiclesCompanion.insert(
            brand: 'Toyota',
            model: 'Corolla',
            currentOdo: const Value(52000),
          ),
        );
  });

  tearDown(() async {
    await db.close();
    try {
      tempDir.deleteSync(recursive: true);
    } on FileSystemException {
      // Windows may still hold image files open; it is a temp folder.
    }
  });

  Future<void> pumpApp(WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    var imported = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          fileStorageProvider.overrideWithValue(storage),
          sharedPreferencesProvider.overrideWithValue(prefs),
          photoPickerProvider.overrideWithValue(
            FakePhotoPicker([galleryPhoto]),
          ),
          photoImporterProvider.overrideWithValue((path) async {
            final name = 'imported${imported++}.jpg';
            File(path).copySync(storage.pathOf(name));
            return name;
          }),
          tempDirProvider.overrideWithValue(() async => tempDir),
          shareFileProvider.overrideWithValue(
            (path, subject) async => shared.add((path, subject)),
          ),
          pickBackupFileProvider.overrideWithValue(() async => pickedBackup),
        ],
        child: const AutoTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Lets real I/O and background isolates finish; widget tests run on
  /// fake time otherwise.
  Future<void> settleRealWork(WidgetTester tester, {int rounds = 20}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> addSampleData() async {
    await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.service,
        date: DateTime.now(),
        odometer: 52000,
        title: 'Oil change',
        cost: 120,
        attachments: const [AttachmentDraft(fileName: 'receipt.jpg')],
      ),
    );
    await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.fuel,
        date: DateTime.now(),
        odometer: 52000,
        title: 'Fuel',
        cost: 60,
        fuel: const FuelDraft(liters: 40, pricePerLiter: 1.5),
      ),
    );
    await db
        .into(db.attachments)
        .insert(
          AttachmentsCompanion.insert(
            vehicleId: carId,
            fileName: 'policy.jpg',
            docType: DocType.insurance,
            caption: const Value('OSAGO policy'),
          ),
        );
  }

  group('Documents', () {
    testWidgets('grid lists record photos and standalone documents', (
      tester,
    ) async {
      await addSampleData();
      await pumpApp(tester);
      await tester.tap(find.text('Documents'));
      await tester.pumpAndSettle();

      expect(find.text('Oil change'), findsOneWidget);
      expect(find.text('OSAGO policy'), findsOneWidget);

      // Filter by type.
      await tester.tap(find.widgetWithText(FilterChip, 'Insurance'));
      await tester.pumpAndSettle();
      expect(find.text('Oil change'), findsNothing);
      expect(find.text('OSAGO policy'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilterChip, 'Insurance'));
      await tester.pumpAndSettle();

      // Search finds the receipt through its record.
      await tester.tap(find.byTooltip('Search'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'oil');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Oil change'), findsOneWidget);
      expect(find.text('OSAGO policy'), findsNothing);
    });

    testWidgets('a document can be added without a record', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('Documents'));
      await tester.pumpAndSettle();
      expect(find.text('No documents yet'), findsOneWidget);

      await tester.tap(find.text('Add document'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from gallery'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Registration'));
      await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'STS');
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      final doc = await db.select(db.attachments).getSingle();
      expect(doc.recordId, isNull);
      expect(doc.docType, DocType.registration);
      expect(doc.caption, 'STS');
      expect(find.text('STS'), findsOneWidget);
    });
  });

  testWidgets('stats show spending and fuel metrics', (tester) async {
    await addSampleData();
    await pumpApp(tester);
    await tester.tap(find.text('Stats'));
    await tester.pumpAndSettle();

    expect(find.text('Total spent'), findsOneWidget);
    expect(find.text('180.00'), findsOneWidget);
    expect(find.text('Spending by category'), findsOneWidget);
    expect(find.text('40 L · 1.50/L'), findsOneWidget);
  });

  group('Export & backup', () {
    Future<void> openDataManager(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Export & backup'));
      await tester.pumpAndSettle();
    }

    testWidgets('CSV export shares a file with the history', (tester) async {
      await addSampleData();
      await pumpApp(tester);
      await openDataManager(tester);

      await tester.tap(find.text('Export CSV'));
      await settleRealWork(tester);

      final (path, subject) = shared.single;
      expect(p.extension(path), '.csv');
      expect(subject, 'Service history: Toyota Corolla');
      expect(File(path).readAsStringSync(), contains('Oil change'));
    });

    testWidgets('backup is created and shared', (tester) async {
      await addSampleData();
      await pumpApp(tester);
      await openDataManager(tester);

      await tester.ensureVisible(find.text('Create backup'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create backup'));
      await settleRealWork(tester, rounds: 40);

      final (path, _) = shared.single;
      expect(p.basename(path), startsWith('autotrack-backup-'));
      expect(File(path).lengthSync(), greaterThan(0));
    });

    testWidgets('restoring a wrong file changes nothing', (tester) async {
      await addSampleData();
      pickedBackup = (File(
        p.join(tempDir.path, 'notes.zip'),
      )..writeAsStringSync('not a backup')).path;
      await pumpApp(tester);
      await openDataManager(tester);

      await tester.ensureVisible(find.text('Restore from backup'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Restore from backup'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
      await settleRealWork(tester);

      expect(find.text('The file is not a ZIP archive'), findsOneWidget);
      expect(await db.select(db.serviceRecords).get(), hasLength(2));
    });
  });
}

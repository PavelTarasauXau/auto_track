import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/record_models.dart';
import 'package:auto_track/data/repositories/record_repository.dart';
import 'package:auto_track/services/backup_service.dart';
import 'package:auto_track/services/export/csv_export.dart';
import 'package:auto_track/services/export/pdf_report.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

void main() {
  late Directory dir;
  late Directory receipts;
  late File dbFile;
  late AppDatabase db;
  late RecordRepository records;
  late int carId;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('autotrack_export');
    receipts = Directory(p.join(dir.path, 'receipts'))..createSync();
    dbFile = File(p.join(dir.path, 'autotrack.sqlite'));
    db = AppDatabase(NativeDatabase(dbFile));
    records = RecordRepository(db, FileStorage(receipts));

    carId = await db
        .into(db.vehicles)
        .insert(
          VehiclesCompanion.insert(
            brand: 'Лада',
            model: 'Веста',
            year: const Value(2020),
            plate: const Value('1234 AB-7'),
            currentOdo: const Value(52000),
          ),
        );
    File(p.join(receipts.path, 'receipt.jpg'))
        .writeAsBytesSync(img.encodeJpg(img.Image(width: 1200, height: 900)));

    await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.service,
        date: DateTime(2026, 3, 14),
        odometer: 51000,
        title: 'Замена масла',
        station: 'СТО "Мотор"',
        cost: 120,
        note: 'Масло 5W-30, "с запасом", 4.2 л',
        items: const [
          ItemDraft(
            kind: ItemKind.part,
            name: 'Фильтр масляный',
            partNumber: 'W712',
            cost: 15,
          ),
        ],
        attachments: const [
          AttachmentDraft(fileName: 'receipt.jpg', caption: 'Чек'),
        ],
      ),
    );
    await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.fuel,
        date: DateTime(2026, 4, 1),
        odometer: 51600,
        title: 'Fuel',
        cost: 60,
        fuel: const FuelDraft(liters: 40, pricePerLiter: 1.5),
      ),
    );
  });

  tearDown(() async {
    await db.close();
    dir.deleteSync(recursive: true);
  });

  Future<List<RecordDetails>> allDetails() async => [
    for (final r in await records.getAll(carId))
      (await records.getDetails(r.id))!,
  ];

  test('CSV has a header, all records and keeps Cyrillic', () async {
    final csv = buildRecordsCsv(await allDetails());

    expect(csv.startsWith('﻿'), isTrue); // BOM for Excel
    final lines = const LineSplitter().convert(csv.substring(1));
    expect(lines.first, startsWith('Date,Mileage (km),Type,Title'));
    expect(lines, hasLength(3));
    expect(lines[1], contains('2026-03-14,51000,Service,Замена масла'));
    expect(lines[1], contains('Фильтр масляный (W712) 15.00'));
    // Quotes and commas inside a value are escaped.
    expect(lines[1], contains('"Масло 5W-30, ""с запасом"", 4.2 л"'));
    expect(lines[2], contains('Fuel,Fuel,,60.00,40.0,1.5,yes'));
  });

  test('service book PDF is built with Cyrillic text and photos', () async {
    final vehicle = await db.select(db.vehicles).getSingle();
    final input = ServiceBookInput(
      vehicle: vehicle,
      records: await allDetails(),
      regularFont: File('assets/fonts/NotoSans-Regular.ttf').readAsBytesSync(),
      boldFont: File('assets/fonts/NotoSans-Bold.ttf').readAsBytesSync(),
      generatedAt: DateTime(2026, 10, 13),
      photosDir: receipts.path,
    );

    final withPhotos = await buildServiceBook(input);
    expect(ascii.decode(withPhotos.sublist(0, 5)), '%PDF-');

    final withoutPhotos = await buildServiceBook(
      ServiceBookInput(
        vehicle: input.vehicle,
        records: input.records,
        regularFont: input.regularFont,
        boldFont: input.boldFont,
        generatedAt: input.generatedAt,
      ),
    );
    expect(withPhotos.length, greaterThan(withoutPhotos.length));
  });

  group('backup', () {
    late BackupService backup;
    late Directory temp;

    setUp(() {
      temp = Directory(p.join(dir.path, 'tmp'))..createSync();
      backup = BackupService(
        db: db,
        databaseFile: dbFile,
        receiptsDir: receipts,
      );
    });

    test('backup contains the database and photos and restores', () async {
      final zip = await backup.create(
        temp,
        now: DateTime(2026, 10, 13, 15, 30),
      );
      expect(p.basename(zip.path), 'autotrack-backup-20261013-1530.zip');

      final unpacked = await BackupService.unpack(
        zip.path,
        Directory(p.join(temp.path, 'restore')),
        currentSchemaVersion: db.schemaVersion,
      );
      expect(unpacked.createdAt, DateTime(2026, 10, 13, 15, 30));
      expect(
        File(p.join(unpacked.receiptsPath, 'receipt.jpg')).existsSync(),
        isTrue,
      );

      // The snapshot is a working database with all data.
      final restored = AppDatabase(NativeDatabase(File(unpacked.databasePath)));
      expect(
        (await restored.select(restored.vehicles).getSingle()).model,
        'Веста',
      );
      expect(
        await restored.select(restored.serviceRecords).get(),
        hasLength(2),
      );
      await restored.close();
    });

    test('replaceData swaps the database file and photos', () async {
      final zip = await backup.create(temp);
      final unpacked = await BackupService.unpack(
        zip.path,
        Directory(p.join(temp.path, 'restore')),
        currentSchemaVersion: db.schemaVersion,
      );

      // Change the live data after the backup was made.
      await db.delete(db.vehicles).go();
      File(p.join(receipts.path, 'new.jpg')).writeAsStringSync('x');
      await db.close();

      backup.replaceData(unpacked);

      final reopened = AppDatabase(NativeDatabase(dbFile));
      expect(await reopened.select(reopened.vehicles).get(), hasLength(1));
      await reopened.close();
      expect(receipts.listSync().map((f) => p.basename(f.path)), [
        'receipt.jpg',
      ]);
      db = AppDatabase(NativeDatabase.memory()); // for tearDown
    });

    Future<String> zipWith(Map<String, String> files) async {
      final archive = Archive();
      for (final MapEntry(key: name, value: content) in files.entries) {
        archive.addFile(ArchiveFile.string(name, content));
      }
      final path = p.join(temp.path, 'test.zip');
      File(path).writeAsBytesSync(ZipEncoder().encode(archive));
      return path;
    }

    Future<String> errorOf(String zipPath) async {
      try {
        await BackupService.unpack(
          zipPath,
          Directory(
            p.join(temp.path, 'out${DateTime.now().microsecondsSinceEpoch}'),
          ),
          currentSchemaVersion: 1,
        );
        return 'no error';
      } on BackupException catch (e) {
        return e.message;
      }
    }

    test('invalid files are rejected', () async {
      final notZip = p.join(temp.path, 'photo.zip');
      File(notZip).writeAsStringSync('definitely not a zip');
      expect(await errorOf(notZip), 'The file is not a ZIP archive');

      expect(
        await errorOf(await zipWith({'readme.txt': 'hi'})),
        'This is not an AutoTrack backup',
      );
      expect(
        await errorOf(
          await zipWith({
            'manifest.json': '{"app":"autotrack","schemaVersion":99}',
            'autotrack.sqlite': 'x',
          }),
        ),
        'The backup was made by a newer version of the app',
      );
      expect(
        await errorOf(
          await zipWith({
            'manifest.json': '{"app":"autotrack","schemaVersion":1}',
            'autotrack.sqlite': 'not a database',
          }),
        ),
        'The backup is damaged',
      );
    });
  });
}

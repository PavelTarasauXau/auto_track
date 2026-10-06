import 'dart:io';

import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/attachment_repository.dart';
import 'package:auto_track/data/repositories/record_models.dart';
import 'package:auto_track/data/repositories/record_repository.dart';
import 'package:auto_track/data/repositories/task_repository.dart';
import 'package:auto_track/data/repositories/vehicle_repository.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FileStorage files;
  late VehicleRepository vehicles;
  late RecordRepository records;
  late TaskRepository tasks;
  late AttachmentRepository attachments;
  late int carId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('autotrack_test');
    files = FileStorage(tempDir);
    vehicles = VehicleRepository(db, files);
    records = RecordRepository(db, files);
    tasks = TaskRepository(db);
    attachments = AttachmentRepository(db, files);

    carId = await vehicles.save(
      VehiclesCompanion.insert(
        brand: 'Toyota',
        model: 'Corolla',
        currentOdo: const Value(50000),
      ),
    );
  });

  tearDown(() async {
    await db.close();
    await tempDir.delete(recursive: true);
  });

  Future<String> fakePhoto(String name) async {
    await files.fileOf(name).writeAsString('jpeg');
    return name;
  }

  RecordDraft serviceDraft({
    int? id,
    int odometer = 51000,
    List<AttachmentDraft> attachments = const [],
    Set<int> completedTaskIds = const {},
  }) => RecordDraft(
    id: id,
    vehicleId: carId,
    type: RecordType.service,
    date: DateTime(2026, 3, 14),
    odometer: odometer,
    title: 'Scheduled service',
    station: 'Best Garage',
    cost: 120,
    items: const [
      ItemDraft(kind: ItemKind.work, name: 'Oil change'),
      ItemDraft(kind: ItemKind.part, name: 'Mann oil filter', cost: 15),
    ],
    attachments: attachments,
    completedTaskIds: completedTaskIds,
  );

  test('new vehicle gets an odometer log entry', () async {
    final log = await vehicles.watchOdometerLog(carId).first;
    expect(log.map((l) => l.value), [50000]);
  });

  test('saving a record stores related data and raises odometer', () async {
    final id = await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.fuel,
        date: DateTime(2026, 3, 1),
        odometer: 50500,
        title: 'Fuel',
        cost: 50,
        fuel: const FuelDraft(liters: 40, pricePerLiter: 1.25),
      ),
    );

    final details = await records.getDetails(id);
    expect(details!.fuel!.liters, 40);
    expect((await vehicles.getById(carId))!.currentOdo, 50500);

    // A record with a lower reading does not lower the odometer.
    await records.save(serviceDraft(odometer: 50100));
    expect((await vehicles.getById(carId))!.currentOdo, 50500);
  });

  test('completing a task reschedules it', () async {
    final taskId = await tasks.save(
      TaskDraft(
        vehicleId: carId,
        title: 'Engine oil',
        intervalKm: 10000,
        intervalDays: 365,
        lastDoneOdo: 41000,
        lastDoneDate: DateTime(2025, 3, 1),
      ),
    );
    expect((await tasks.getById(taskId))!.dueOdo, 51000);

    final recordId = await records.save(
      serviceDraft(completedTaskIds: {taskId}),
    );

    final task = (await tasks.getById(taskId))!;
    expect(task.lastDoneOdo, 51000);
    expect(task.dueOdo, 61000);
    expect(task.dueDate, DateTime(2027, 3, 14));
    expect(task.isActive, isTrue);

    final details = await records.getDetails(recordId);
    expect(details!.completedTasks.map((t) => t.title), ['Engine oil']);
  });

  test('one-off task becomes inactive when completed', () async {
    final taskId = await tasks.save(
      TaskDraft(vehicleId: carId, title: 'Brake pads', fixedDueOdo: 52000),
    );
    await records.save(serviceDraft(completedTaskIds: {taskId}));
    expect((await tasks.getById(taskId))!.isActive, isFalse);
  });

  test('full-text search finds records by item, station and date', () async {
    final id = await records.save(serviceDraft());

    Future<List<int>> search(String q) async =>
        (await records
                .watchRecords(carId, filter: RecordFilter(query: q))
                .first)
            .map((r) => r.id)
            .toList();

    expect(await search('filt'), [id]); // prefix of "filter"
    expect(await search('best garage'), [id]);
    expect(await search('2026-03'), [id]);
    expect(await search('March'), [id]);
    expect(await search("tyres'"), isEmpty); // quote must not break SQL
  });

  test('history filter by type and date', () async {
    await records.save(serviceDraft());
    await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.wash,
        date: DateTime(2026, 9, 1),
        odometer: 52000,
        title: 'Wash',
      ),
    );

    final washes = await records
        .watchRecords(
          carId,
          filter: const RecordFilter(types: {RecordType.wash}),
        )
        .first;
    expect(washes.map((r) => r.title), ['Wash']);

    final recent = await records
        .watchRecords(carId, filter: RecordFilter(from: DateTime(2026, 6, 1)))
        .first;
    expect(recent.length, 1);
  });

  test('removing an attachment while editing deletes its file', () async {
    final a = await fakePhoto('a.jpg');
    final b = await fakePhoto('b.jpg');
    final id = await records.save(
      serviceDraft(
        attachments: [
          AttachmentDraft(fileName: a),
          AttachmentDraft(fileName: b, caption: 'Warranty card'),
        ],
      ),
    );

    final saved = (await records.getDetails(id))!.attachments;
    final keep = saved.firstWhere((x) => x.fileName == b);
    await records.save(
      serviceDraft(
        id: id,
        attachments: [
          AttachmentDraft(id: keep.id, fileName: b, caption: 'Warranty card'),
        ],
      ),
    );

    expect(await files.fileOf(a).exists(), isFalse);
    expect(await files.fileOf(b).exists(), isTrue);

    final docs = await attachments
        .watchDocuments(carId, query: 'warranty')
        .first;
    expect(docs.single.attachment.fileName, b);
    expect(docs.single.record!.id, id);
  });

  test('deleting a vehicle cascades and removes files', () async {
    final photo = await fakePhoto('receipt.jpg');
    await records.save(
      serviceDraft(attachments: [AttachmentDraft(fileName: photo)]),
    );
    await tasks.save(TaskDraft(vehicleId: carId, title: 'Oil'));

    await vehicles.delete(carId);

    expect(await db.select(db.serviceRecords).get(), isEmpty);
    expect(await db.select(db.recordItems).get(), isEmpty);
    expect(await db.select(db.attachments).get(), isEmpty);
    expect(await db.select(db.maintenanceTasks).get(), isEmpty);
    final fts = await db
        .customSelect('SELECT count(*) AS c FROM record_search')
        .getSingle();
    expect(fts.read<int>('c'), 0);
    expect(await files.fileOf(photo).exists(), isFalse);
  });
}

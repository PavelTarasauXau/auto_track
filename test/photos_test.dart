import 'dart:io';

import 'package:auto_track/app.dart';
import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/data/repositories/record_models.dart';
import 'package:auto_track/data/repositories/record_repository.dart';
import 'package:auto_track/providers.dart';
import 'package:auto_track/services/file_storage.dart';
import 'package:auto_track/services/photo_picker.dart';
import 'package:auto_track/widgets/attachment_thumb.dart';
import 'package:drift/drift.dart' show DatabaseConnection, Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

/// Returns prepared files instead of opening the camera or gallery.
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
  late List<String> galleryPhotos;
  late int carId;
  var imported = 0;

  setUp(() async {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    tempDir = Directory.systemTemp.createTempSync('autotrack_photos');
    final receipts = Directory(p.join(tempDir.path, 'receipts'))..createSync();
    storage = FileStorage(receipts);
    records = RecordRepository(db, storage);
    SharedPreferences.setMockInitialValues({});

    // Two small JPEGs standing in for gallery photos.
    final jpeg = img.encodeJpg(img.Image(width: 16, height: 12));
    galleryPhotos = [
      for (final name in ['gallery1.jpg', 'gallery2.jpg'])
        (File(p.join(tempDir.path, name))..writeAsBytesSync(jpeg)).path,
    ];

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
    try {
      tempDir.deleteSync(recursive: true);
    } on FileSystemException {
      // Windows keeps image files locked while Flutter still reads them;
      // it is only a temp folder.
    }
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
          fileStorageProvider.overrideWithValue(storage),
          sharedPreferencesProvider.overrideWithValue(prefs),
          photoPickerProvider.overrideWithValue(FakePhotoPicker(galleryPhotos)),
          // Background isolates cannot run inside widget tests, so photos
          // are copied synchronously here; compression has its own tests.
          photoImporterProvider.overrideWithValue((path) async {
            final name = 'imported${imported++}.jpg';
            File(path).copySync(storage.pathOf(name));
            return name;
          }),
        ],
        child: const AutoTrackApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Lets real file I/O (delete) finish; widget tests run on fake time.
  /// Reading an image file takes several async steps (open, read, close),
  /// and each needs a turn of the real event loop plus a pump.
  Future<void> flushFileIo(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  Future<void> openNewRecordForm(WidgetTester tester) async {
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add record'));
    await tester.pumpAndSettle();
  }

  /// The main vertical list of the current screen.
  Finder screenList() => find
      .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
      .first;

  Future<void> scrollTo(WidgetTester tester, String text) async {
    await tester.scrollUntilVisible(
      find.text(text),
      300,
      scrollable: screenList(),
    );
    // scrollUntilVisible stops as soon as the widget peeks in; make sure it
    // is fully on screen so that taps hit it.
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
  }

  Future<void> addPhotosFromGallery(WidgetTester tester) async {
    await scrollTo(tester, 'Add photo');
    await tester.tap(find.text('Add photo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose from gallery'));
    await tester.pumpAndSettle();
  }

  testWidgets('photos are attached, captioned and shown in the viewer', (
    tester,
  ) async {
    await pumpApp(tester);
    await openNewRecordForm(tester);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Brake pads',
    );

    await addPhotosFromGallery(tester);
    expect(find.byType(AttachmentThumb), findsNWidgets(2));

    // Mark the first photo as a warranty with a caption.
    await tester.tap(find.byType(AttachmentThumb).first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Warranty'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Caption'),
      'Pads warranty',
    );
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await db.select(db.attachments).get();
    expect(saved, hasLength(2));
    expect(saved.first.docType, DocType.warranty);
    expect(saved.first.caption, 'Pads warranty');
    expect(saved.first.vehicleId, carId);

    // Details screen shows the gallery; a tap opens the viewer.
    await tester.tap(find.text('Brake pads'));
    await tester.pumpAndSettle();
    await scrollTo(tester, 'Receipts & photos');
    expect(find.byType(AttachmentThumb), findsNWidgets(2));

    await tester.tap(find.byType(AttachmentThumb).first);
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('Warranty · Pads warranty'), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
  });

  testWidgets('photos are deleted when the form is left without saving', (
    tester,
  ) async {
    await pumpApp(tester);
    await openNewRecordForm(tester);
    await addPhotosFromGallery(tester);
    expect(storage.directory.listSync(), hasLength(2));

    await tester.pageBack();
    await tester.pumpAndSettle();
    await flushFileIo(tester);

    expect(storage.directory.listSync(), isEmpty);
    expect(await db.select(db.attachments).get(), isEmpty);
  });

  testWidgets('removing an unsaved photo deletes its file at once', (
    tester,
  ) async {
    await pumpApp(tester);
    await openNewRecordForm(tester);
    await addPhotosFromGallery(tester);

    await tester.tap(find.byType(AttachmentThumb).first);
    await tester.pumpAndSettle();
    // Let the thumbnails finish reading their files: Windows cannot delete
    // a file that is still open (Android can).
    await flushFileIo(tester);
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    expect(find.byType(AttachmentThumb), findsOneWidget);
    expect(storage.directory.listSync(), hasLength(1));
  });

  testWidgets('removing a saved photo deletes its file on save', (
    tester,
  ) async {
    for (final name in ['old1.jpg', 'old2.jpg']) {
      File(galleryPhotos.first).copySync(storage.pathOf(name));
    }
    await records.save(
      RecordDraft(
        vehicleId: carId,
        type: RecordType.service,
        date: DateTime.now(),
        odometer: 50000,
        title: 'Oil change',
        attachments: const [
          AttachmentDraft(fileName: 'old1.jpg'),
          AttachmentDraft(fileName: 'old2.jpg'),
        ],
      ),
    );

    await pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oil change'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    await scrollTo(tester, 'Add photo');
    await tester.tap(find.byType(AttachmentThumb).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();

    // Not deleted before saving: the user could still cancel the edit.
    expect(storage.fileOf('old1.jpg').existsSync(), isTrue);

    await tester.tap(find.text('Save'));
    await flushFileIo(tester);

    expect(storage.fileOf('old1.jpg').existsSync(), isFalse);
    expect(storage.fileOf('old2.jpg').existsSync(), isTrue);
    final left = await db.select(db.attachments).get();
    expect(left.map((a) => a.fileName), ['old2.jpg']);
  });
}

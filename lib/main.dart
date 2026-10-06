import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'providers.dart';
import 'services/file_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fileStorage = await FileStorage.open();

  runApp(
    ProviderScope(
      overrides: [fileStorageProvider.overrideWithValue(fileStorage)],
      child: const AutoTrackApp(),
    ),
  );
}

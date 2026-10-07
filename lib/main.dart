import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers.dart';
import 'services/file_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fileStorage = await FileStorage.open();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        fileStorageProvider.overrideWithValue(fileStorage),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const AutoTrackApp(),
    ),
  );
}

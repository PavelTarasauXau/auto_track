import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'notifications.dart';
import 'providers.dart';
import 'services/file_storage.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fileStorage = await FileStorage.open();
  final prefs = await SharedPreferences.getInstance();
  final notifications = await LocalNotificationGateway.init();

  runApp(
    ProviderScope(
      overrides: [
        fileStorageProvider.overrideWithValue(fileStorage),
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificationGatewayProvider.overrideWithValue(notifications),
      ],
      child: const AutoTrackApp(),
    ),
  );
}

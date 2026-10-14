import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'notifications.dart';

class AutoTrackApp extends ConsumerWidget {
  const AutoTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keeps scheduled notifications in sync with the data.
    ref.watch(notificationSyncProvider);
    return MaterialApp.router(
      title: 'AutoTrack',
      debugShowCheckedModeBanner: false,
      // The "car dashboard" design is dark by intent.
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

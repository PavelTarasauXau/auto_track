import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../core/enums.dart';
import '../domain/notification_planner.dart';

/// What the app needs from the notification system. The real implementation
/// wraps flutter_local_notifications; tests use a fake.
abstract class NotificationGateway {
  /// Replaces all scheduled notifications with [plan].
  Future<void> replaceScheduled(List<PlannedNotification> plan);

  /// Shows a notification right away.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  });

  /// Asks for the notification permission (Android 13+) and, if
  /// [exactAlarms], for exact alarms (Android 12+). Returns whether
  /// notifications are allowed.
  Future<bool> requestPermissions({bool exactAlarms = false});

  Future<bool> notificationsEnabled();

  /// Routes of tapped notifications.
  Stream<String> get taps;

  /// Route of the notification that launched the app, if any.
  String? takeLaunchPayload();
}

/// Does nothing; the default until the real gateway is set up in `main()`.
class NoopNotificationGateway implements NotificationGateway {
  @override
  Future<void> replaceScheduled(List<PlannedNotification> plan) async {}

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}

  @override
  Future<bool> requestPermissions({bool exactAlarms = false}) async => false;

  @override
  Future<bool> notificationsEnabled() async => false;

  @override
  Stream<String> get taps => const Stream.empty();

  @override
  String? takeLaunchPayload() => null;
}

class LocalNotificationGateway implements NotificationGateway {
  LocalNotificationGateway._(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  final _taps = StreamController<String>.broadcast();
  String? _launchPayload;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  static Future<LocalNotificationGateway> init() async {
    tz_data.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } catch (e) {
      // Unknown zone name: fall back to UTC rather than not starting.
      debugPrint('Time zone lookup failed: $e');
    }

    final gateway = LocalNotificationGateway._(
      FlutterLocalNotificationsPlugin(),
    );
    await gateway._plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null) gateway._taps.add(route);
      },
    );
    final launch = await gateway._plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      gateway._launchPayload = launch!.notificationResponse?.payload;
    }
    return gateway;
  }

  @override
  Stream<String> get taps => _taps.stream;

  @override
  String? takeLaunchPayload() {
    final p = _launchPayload;
    _launchPayload = null;
    return p;
  }

  @override
  Future<void> replaceScheduled(List<PlannedNotification> plan) async {
    // Only scheduled ones are cancelled; notifications already in the
    // shade stay there.
    for (final pending in await _plugin.pendingNotificationRequests()) {
      await _plugin.cancel(id: pending.id);
    }

    final exact = await _android?.canScheduleExactNotifications() ?? false;
    for (final n in plan) {
      await _plugin.zonedSchedule(
        id: n.id,
        title: n.title,
        body: n.body,
        payload: n.payload,
        scheduledDate: tz.TZDateTime.from(n.at, tz.local),
        notificationDetails: _details(n.channel),
        // Without the exact alarm permission Android may delay the
        // notification by a few minutes.
        androidScheduleMode: exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: switch (n.repeat) {
          RepeatRule.none => null,
          RepeatRule.daily => DateTimeComponents.time,
          RepeatRule.weekly => DateTimeComponents.dayOfWeekAndTime,
          RepeatRule.monthly => DateTimeComponents.dayOfMonthAndTime,
          RepeatRule.yearly => DateTimeComponents.dateAndTime,
        },
      );
    }
  }

  @override
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) => _plugin.show(
    id: id,
    title: title,
    body: body,
    payload: payload,
    notificationDetails: _details(NotificationChannel.maintenance),
  );

  @override
  Future<bool> requestPermissions({bool exactAlarms = false}) async {
    final android = _android;
    if (android == null) return false;
    final allowed = await android.requestNotificationsPermission() ?? false;
    if (exactAlarms &&
        !(await android.canScheduleExactNotifications() ?? true)) {
      // Opens the system "Alarms & reminders" screen.
      await android.requestExactAlarmsPermission();
    }
    return allowed;
  }

  @override
  Future<bool> notificationsEnabled() async =>
      await _android?.areNotificationsEnabled() ?? false;

  static NotificationDetails _details(NotificationChannel channel) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel == NotificationChannel.mileage
              ? Importance.defaultImportance
              : Importance.high,
          priority: channel == NotificationChannel.mileage
              ? Priority.defaultPriority
              : Priority.high,
        ),
      );
}

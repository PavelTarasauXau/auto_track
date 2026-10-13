import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router.dart';
import 'data/db/database.dart';
import 'domain/notification_planner.dart';
import 'domain/task_schedule.dart';
import 'domain/task_view.dart';
import 'providers.dart';
import 'services/notification_service.dart';

/// Real gateway is created in `main()`; tests override it with a fake.
/// The no-op default keeps widget tests that do not care about
/// notifications working.
final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => NoopNotificationGateway(),
);

final pendingRemindersProvider = StreamProvider<List<Reminder>>(
  (ref) => ref.watch(reminderRepositoryProvider).watchPending(),
);

final notificationControllerProvider = Provider<NotificationController>((ref) {
  final controller = NotificationController(
    ref.watch(notificationGatewayProvider),
    ref.watch(sharedPreferencesProvider),
    (route) => ref.read(routerProvider).push(route),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

/// Recomputes the notification plan whenever vehicles, tasks, odometer
/// readings or reminders change. Kept alive by the app widget.
final notificationSyncProvider = Provider<void>((ref) {
  final controller = ref.watch(notificationControllerProvider);
  final vehicles = ref.watch(vehiclesProvider).value;
  final reminders = ref.watch(pendingRemindersProvider).value;
  if (vehicles == null || reminders == null) return;

  final tasks = <int, List<TaskView>>{};
  final logs = <int, List<OdometerLog>>{};
  for (final v in vehicles) {
    final views = ref.watch(taskViewsProvider(v.id)).value;
    final vehicleLogs = ref.watch(odometerLogProvider(v.id)).value;
    // Wait until everything is loaded, otherwise a half-built plan would
    // cancel notifications of the vehicles not loaded yet.
    if (views == null || vehicleLogs == null) return;
    tasks[v.id] = views;
    logs[v.id] = vehicleLogs;
  }

  controller.apply(
    plan: planNotifications(
      reminders: reminders,
      vehicles: vehicles,
      tasksByVehicle: tasks,
      logsByVehicle: logs,
      now: DateTime.now(),
    ),
    tasks: [for (final list in tasks.values) ...list],
    vehicles: vehicles,
  );
});

class NotificationController {
  /// [_openRoute] navigates to an app route when a notification is tapped.
  NotificationController(this._gateway, this._prefs, this._openRoute) {
    _tapSub = _gateway.taps.listen(_openRoute);
    // The app was opened from a notification: navigate once it is built.
    final launch = _gateway.takeLaunchPayload();
    if (launch != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openRoute(launch));
    }
  }

  static const _askedKey = 'notifications_permission_asked';

  final NotificationGateway _gateway;
  final SharedPreferences _prefs;
  final void Function(String route) _openRoute;
  late final StreamSubscription<String> _tapSub;

  /// Task urgencies at the previous [apply]; `null` before the first one.
  Map<int, Urgency>? _previous;

  /// Applies run one after another, never in parallel.
  Future<void> _queue = Future.value();

  void apply({
    required List<PlannedNotification> plan,
    required List<TaskView> tasks,
    required List<Vehicle> vehicles,
  }) {
    final due = newlyDue(_previous, tasks);
    _previous = {for (final v in tasks) v.task.id: v.urgency};
    final names = {for (final v in vehicles) v.id: '${v.brand} ${v.model}'};

    _queue = _queue.then((_) async {
      try {
        if (plan.isNotEmpty || due.isNotEmpty) await _askPermissionOnce();
        await _gateway.replaceScheduled(plan);
        for (final v in due) {
          await _gateway.showNow(
            id: NotificationIds.forDueNow(v.task.id),
            title: v.urgency == Urgency.overdue
                ? 'Overdue: ${v.task.title}'
                : 'Due soon: ${v.task.title}',
            body: '${names[v.task.vehicleId] ?? ''} · ${v.remainingLabel}',
            payload: '/task/${v.task.id}/edit',
          );
        }
      } catch (e) {
        debugPrint('Notification sync failed: $e');
      }
    });
  }

  /// Asks for notifications permission the first time there is something
  /// to notify about; later the user can enable it from the Reminders tab.
  Future<void> _askPermissionOnce() async {
    if (_prefs.getBool(_askedKey) ?? false) return;
    await _prefs.setBool(_askedKey, true);
    await _gateway.requestPermissions();
  }

  static const _exactAskedKey = 'exact_alarms_permission_asked';

  /// After the first reminder: asks for notifications and, once, for exact
  /// alarms (on Android 12+ this opens a system settings screen, so it is
  /// not repeated on every save).
  Future<void> ensureReminderPermissions() async {
    final askExact = !(_prefs.getBool(_exactAskedKey) ?? false);
    await _prefs.setBool(_askedKey, true);
    await _prefs.setBool(_exactAskedKey, true);
    await _gateway.requestPermissions(exactAlarms: askExact);
  }

  /// For reminders the exact time matters, so exact alarms are requested too.
  Future<bool> requestPermissions({bool exactAlarms = false}) =>
      _gateway.requestPermissions(exactAlarms: exactAlarms);

  Future<bool> notificationsEnabled() => _gateway.notificationsEnabled();

  /// Completes when all pending applies are done (used by tests).
  Future<void> get idle => _queue;

  void dispose() => _tapSub.cancel();
}

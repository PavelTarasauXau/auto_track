/// Decides which notifications to schedule and when. Pure logic (no plugin,
/// no database), so it is fully covered by unit tests; the notification
/// service only executes the resulting plan.
library;

import '../core/enums.dart';
import '../core/format.dart';
import '../data/db/database.dart';
import 'task_schedule.dart';
import 'task_view.dart';

/// Maintenance notifications are shown at this hour.
const maintenanceHour = 10;

/// "Update your mileage" notifications are shown at this hour.
const odometerHour = 18;

/// Ranges of notification ids per kind, so ids never collide.
abstract final class NotificationIds {
  static const reminder = 1000000;
  static const task = 2000000;
  static const odometer = 3000000;
  static const dueNow = 4000000;

  static int forReminder(int id) => reminder + id;
  static int taskHeadsUp(int taskId) => task + taskId * 2;
  static int taskDueDay(int taskId) => task + taskId * 2 + 1;
  static int forOdometer(int vehicleId) => odometer + vehicleId;
  static int forDueNow(int taskId) => dueNow + taskId;
}

class PlannedNotification {
  const PlannedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.at,
    required this.channel,
    this.repeat = RepeatRule.none,
    this.payload,
  });

  final int id;
  final String title;
  final String body;

  /// Local time of the (first) notification; always in the future.
  final DateTime at;
  final NotificationChannel channel;
  final RepeatRule repeat;

  /// App route to open when the notification is tapped.
  final String? payload;

  @override
  String toString() => 'PlannedNotification($id, $title, $at, $repeat)';
}

enum NotificationChannel {
  reminders('reminders', 'Reminders', 'Reminders you set for a date and time'),
  maintenance(
    'maintenance',
    'Maintenance',
    'Upcoming and due maintenance tasks',
  ),
  mileage('mileage', 'Mileage updates', 'Requests to update the odometer');

  const NotificationChannel(this.id, this.name, this.description);

  final String id;
  final String name;
  final String description;
}

/// Next time a reminder fires at or after [now]; `null` for a one-time
/// reminder in the past.
DateTime? nextOccurrence(DateTime at, RepeatRule repeat, DateTime now) {
  if (at.isAfter(now)) return at;

  DateTime at0(int y, int m, int d) => DateTime(y, m, d, at.hour, at.minute);

  switch (repeat) {
    case RepeatRule.none:
      return null;
    case RepeatRule.daily:
      var c = at0(now.year, now.month, now.day);
      if (!c.isAfter(now)) c = at0(c.year, c.month, c.day + 1);
      return c;
    case RepeatRule.weekly:
      final shift = (at.weekday - now.weekday) % 7;
      var c = at0(now.year, now.month, now.day + shift);
      if (!c.isAfter(now)) c = at0(c.year, c.month, c.day + 7);
      return c;
    case RepeatRule.monthly:
      // Months without this day (e.g. the 31st) are skipped.
      for (var i = 0; i < 24; i++) {
        final c = at0(now.year, now.month + i, at.day);
        final sameDay = c.day == at.day;
        if (sameDay && c.isAfter(now)) return c;
      }
      return null;
    case RepeatRule.yearly:
      // 29 February fires only in leap years.
      for (var i = 0; i < 8; i++) {
        final c = at0(now.year + i, at.month, at.day);
        if (c.month == at.month && c.isAfter(now)) return c;
      }
      return null;
  }
}

/// All notifications that should be scheduled right now.
List<PlannedNotification> planNotifications({
  required List<Reminder> reminders,
  required List<Vehicle> vehicles,
  required Map<int, List<TaskView>> tasksByVehicle,
  required Map<int, List<OdometerLog>> logsByVehicle,
  required DateTime now,
}) {
  final names = {for (final v in vehicles) v.id: '${v.brand} ${v.model}'};
  final plan = <PlannedNotification>[];

  for (final r in reminders) {
    if (r.isDone) continue;
    final at = nextOccurrence(r.remindAt, r.repeat, now);
    if (at == null) continue;
    final vehicle = names[r.vehicleId];
    plan.add(
      PlannedNotification(
        id: NotificationIds.forReminder(r.id),
        title: r.title,
        body: [?vehicle, ?r.note].join(' · ').ifEmpty('Reminder'),
        at: at,
        channel: NotificationChannel.reminders,
        repeat: r.repeat,
        payload: '/plan',
      ),
    );
  }

  for (final vehicle in vehicles) {
    final views = tasksByVehicle[vehicle.id] ?? const [];
    final logs = logsByVehicle[vehicle.id] ?? const [];
    final daily = averageDailyKm([for (final l in logs) (l.date, l.value)]);
    final name = names[vehicle.id]!;

    for (final v in views) {
      plan.addAll(_taskNotifications(v, name, daily, now));
    }

    final tracksMileage = views.any((v) => v.task.dueOdo != null);
    if (tracksMileage) {
      final lastUpdate = logs.isEmpty
          ? vehicle.createdAt
          : logs.map((l) => l.date).reduce((a, b) => a.isAfter(b) ? a : b);
      plan.add(_odometerNotification(vehicle.id, name, lastUpdate, now));
    }
  }
  return plan;
}

List<PlannedNotification> _taskNotifications(
  TaskView view,
  String vehicleName,
  double? dailyKm,
  DateTime now,
) {
  final task = view.task;
  final result = <PlannedNotification>[];
  final body = '$vehicleName · ${_dueText(task)}';
  final payload = '/task/${task.id}/edit';

  // Heads-up: when the task becomes "due soon".
  final candidates = <DateTime>[
    if (task.dueDate case final due?)
      due.subtract(Duration(days: task.remindBeforeDays)),
    if (view.status.kmLeft case final kmLeft? when dailyKm != null)
      if (kmLeft - task.remindBeforeKm > 0)
        predictDate(kmLeft - task.remindBeforeKm, dailyKm, now),
  ];
  final headsUp = _earliestAt(candidates, maintenanceHour);
  if (headsUp != null && headsUp.isAfter(now)) {
    result.add(
      PlannedNotification(
        id: NotificationIds.taskHeadsUp(task.id),
        title: 'Coming up: ${task.title}',
        body: body,
        at: headsUp,
        channel: NotificationChannel.maintenance,
        payload: payload,
      ),
    );
  }

  // Due day: the date itself, or when the mileage is expected to be reached.
  final expected = view.expectedDate;
  final dueDay = expected == null
      ? null
      : _earliestAt([expected], maintenanceHour);
  if (dueDay != null && dueDay.isAfter(now)) {
    result.add(
      PlannedNotification(
        id: NotificationIds.taskDueDay(task.id),
        title: 'Due today: ${task.title}',
        body: body,
        at: dueDay,
        channel: NotificationChannel.maintenance,
        payload: payload,
      ),
    );
  }
  return result;
}

/// A week after the last odometer update, but at least a day from now so
/// that an ignored request does not repeat every time the app is opened.
PlannedNotification _odometerNotification(
  int vehicleId,
  String vehicleName,
  DateTime lastUpdate,
  DateTime now,
) {
  final weekLater = dateOnly(lastUpdate).add(const Duration(days: 7));
  final tomorrow = dateOnly(now).add(const Duration(days: 1));
  final day = weekLater.isAfter(tomorrow) ? weekLater : tomorrow;
  return PlannedNotification(
    id: NotificationIds.forOdometer(vehicleId),
    title: 'Update the mileage',
    body:
        '$vehicleName: enter the current odometer reading '
        'to keep maintenance reminders accurate',
    at: DateTime(day.year, day.month, day.day, odometerHour),
    channel: NotificationChannel.mileage,
    payload: '/home',
  );
}

DateTime? _earliestAt(List<DateTime> dates, int hour) {
  if (dates.isEmpty) return null;
  final d = dates.reduce((a, b) => a.isBefore(b) ? a : b);
  return DateTime(d.year, d.month, d.day, hour);
}

/// `due at 60,000 km or on 12 Nov 2026`
String _dueText(MaintenanceTask task) {
  final parts = [
    if (task.dueOdo != null) 'at ${formatKm(task.dueOdo!)}',
    if (task.dueDate != null) 'on ${formatDate(task.dueDate!)}',
  ];
  return 'due ${parts.join(' or ')}';
}

/// Tasks that got worse since the previous check and are now due soon or
/// overdue, e.g. right after a new odometer reading. Not reported on the
/// first check after the app starts ([previous] is `null`).
List<TaskView> newlyDue(Map<int, Urgency>? previous, Iterable<TaskView> now) {
  if (previous == null) return const [];
  final result = <TaskView>[];
  for (final v in now) {
    final before = previous[v.task.id];
    final isDue = v.urgency == Urgency.dueSoon || v.urgency == Urgency.overdue;
    // Urgency values are ordered from the most urgent: lower is worse.
    if (isDue && before != null && before.index > v.urgency.index) {
      result.add(v);
    }
  }
  return result;
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

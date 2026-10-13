import '../core/format.dart';
import '../data/db/database.dart';
import 'task_schedule.dart';

/// A maintenance task with its status for the current odometer and date.
class TaskView {
  const TaskView({required this.task, required this.status, this.predicted});

  final MaintenanceTask task;
  final TaskStatus status;

  /// When the mileage limit will be reached at the usual daily mileage;
  /// `null` without a mileage limit or enough odometer history.
  final DateTime? predicted;

  Urgency get urgency => status.urgency;

  /// The date the task is expected: due date or predicted one, whichever
  /// comes first. Used for sorting and notifications.
  DateTime? get expectedDate {
    final due = task.dueDate;
    final p = predicted;
    if (due == null) return p;
    if (p == null) return due;
    return p.isBefore(due) ? p : due;
  }

  /// `in 300 km · in 12 days`, `500 km overdue`, `due today`.
  String get remainingLabel {
    final parts = <String>[];
    final km = status.kmLeft;
    final days = status.daysLeft;
    if (km != null) {
      parts.add(km < 0 ? '${formatKm(-km)} overdue' : 'in ${formatKm(km)}');
    }
    if (days != null) {
      parts.add(switch (days) {
        < -1 => '${-days} days overdue',
        -1 => '1 day overdue',
        0 => 'due today',
        1 => 'tomorrow',
        _ => 'in $days days',
      });
    }
    return parts.isEmpty ? 'No due date' : parts.join(' · ');
  }
}

/// Builds task views sorted by urgency, then by how soon they are due.
List<TaskView> buildTaskViews(
  List<MaintenanceTask> tasks, {
  required int currentOdo,
  required List<OdometerLog> logs,
  required DateTime now,
}) {
  final daily = averageDailyKm([for (final l in logs) (l.date, l.value)]);

  final views = [
    for (final t in tasks)
      () {
        final status = evaluateTask(
          dueOdo: t.dueOdo,
          dueDate: t.dueDate,
          currentOdo: currentOdo,
          now: now,
          remindBeforeKm: t.remindBeforeKm,
          remindBeforeDays: t.remindBeforeDays,
          intervalKm: t.intervalKm,
          intervalDays: t.intervalDays,
        );
        final kmLeft = status.kmLeft;
        return TaskView(
          task: t,
          status: status,
          predicted: kmLeft != null && kmLeft > 0 && daily != null
              ? predictDate(kmLeft, daily, now)
              : null,
        );
      }(),
  ];

  views.sort((a, b) {
    final byUrgency = a.urgency.index.compareTo(b.urgency.index);
    if (byUrgency != 0) return byUrgency;
    return _soonness(a, now).compareTo(_soonness(b, now));
  });
  return views;
}

/// Rough "how soon" score in days for sorting within the same urgency.
double _soonness(TaskView v, DateTime now) {
  final days = v.status.daysLeft?.toDouble();
  final p = v.predicted;
  final predictedDays = p == null
      ? null
      : p.difference(dateOnly(now)).inHours / 24;
  final kmAsDays = v.status.kmLeft == null ? null : v.status.kmLeft! / 50;
  return [
    days,
    predictedDays ?? kmAsDays,
  ].whereType<double>().fold(double.infinity, (a, b) => a < b ? a : b);
}

/// `Every 10,000 km or 12 months`, `Every 2 years`, `One-time`.
String intervalLabel(int? intervalKm, int? intervalDays) {
  final parts = <String>[];
  if (intervalKm != null) parts.add(formatKm(intervalKm));
  if (intervalDays != null) parts.add(daysLabel(intervalDays));
  return parts.isEmpty ? 'One-time' : 'Every ${parts.join(' or ')}';
}

/// `12 months` → `1 year`, `730` → `2 years`, `45` → `45 days`.
String daysLabel(int days) {
  final months = daysToMonths(days);
  if (months == null) return days == 1 ? '1 day' : '$days days';
  if (months % 12 == 0) {
    final years = months ~/ 12;
    return years == 1 ? '1 year' : '$years years';
  }
  return months == 1 ? '1 month' : '$months months';
}

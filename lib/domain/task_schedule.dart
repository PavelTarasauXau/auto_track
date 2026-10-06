/// Pure maintenance scheduling logic (no database or UI), covered by tests.
library;

/// When a task is due next: by mileage, by date, or both.
class Due {
  const Due({this.odo, this.date});

  final int? odo;
  final DateTime? date;
}

/// Next due point of a recurring task.
///
/// Uses the interval only when the matching "last done" value is known;
/// otherwise falls back to the explicitly set [fixedOdo] / [fixedDate]
/// (one-off tasks, or recurring tasks that were never done).
Due computeDue({
  int? intervalKm,
  int? intervalDays,
  int? lastDoneOdo,
  DateTime? lastDoneDate,
  int? fixedOdo,
  DateTime? fixedDate,
}) {
  final odo = (intervalKm != null && lastDoneOdo != null)
      ? lastDoneOdo + intervalKm
      : fixedOdo;
  final date = (intervalDays != null && lastDoneDate != null)
      ? dateOnly(lastDoneDate).add(Duration(days: intervalDays))
      : fixedDate;
  return Due(odo: odo, date: date == null ? null : dateOnly(date));
}

enum Urgency { overdue, dueSoon, ok, unknown }

class TaskStatus {
  const TaskStatus({
    required this.urgency,
    this.kmLeft,
    this.daysLeft,
    this.progress,
  });

  final Urgency urgency;

  /// Negative when overdue.
  final int? kmLeft;
  final int? daysLeft;

  /// Share of the interval already used, 0..1+ (above 1 when overdue).
  final double? progress;
}

/// Status of a task for the given current odometer and date.
/// Whichever limit (km or days) comes first decides.
TaskStatus evaluateTask({
  required int? dueOdo,
  required DateTime? dueDate,
  required int currentOdo,
  required DateTime now,
  int remindBeforeKm = 500,
  int remindBeforeDays = 14,
  int? intervalKm,
  int? intervalDays,
}) {
  final kmLeft = dueOdo == null ? null : dueOdo - currentOdo;
  final daysLeft = dueDate == null
      ? null
      : _daysBetween(dateOnly(now), dateOnly(dueDate));

  final Urgency urgency;
  if (kmLeft == null && daysLeft == null) {
    urgency = Urgency.unknown;
  } else if ((kmLeft != null && kmLeft < 0) ||
      (daysLeft != null && daysLeft < 0)) {
    urgency = Urgency.overdue;
  } else if ((kmLeft != null && kmLeft <= remindBeforeKm) ||
      (daysLeft != null && daysLeft <= remindBeforeDays)) {
    urgency = Urgency.dueSoon;
  } else {
    urgency = Urgency.ok;
  }

  double? progress;
  if (kmLeft != null && intervalKm != null && intervalKm > 0) {
    progress = 1 - kmLeft / intervalKm;
  }
  if (daysLeft != null && intervalDays != null && intervalDays > 0) {
    final byDays = 1 - daysLeft / intervalDays;
    progress = progress == null || byDays > progress ? byDays : progress;
  }

  return TaskStatus(
    urgency: urgency,
    kmLeft: kmLeft,
    daysLeft: daysLeft,
    progress: progress?.clamp(0, 2).toDouble(),
  );
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

// Calendar days; rounding absorbs DST hour shifts.
int _daysBetween(DateTime from, DateTime to) =>
    (to.difference(from).inHours / 24).round();

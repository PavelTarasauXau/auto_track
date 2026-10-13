import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/domain/notification_planner.dart';
import 'package:auto_track/domain/task_schedule.dart';
import 'package:auto_track/domain/task_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Monday 12 October 2026, 14:30.
  final now = DateTime(2026, 10, 12, 14, 30);

  group('nextOccurrence', () {
    test('future time is kept as is', () {
      final at = DateTime(2026, 10, 13, 16);
      for (final r in RepeatRule.values) {
        expect(nextOccurrence(at, r, now), at);
      }
    });

    test('past one-time reminder does not fire', () {
      expect(
        nextOccurrence(DateTime(2026, 10, 12, 9), RepeatRule.none, now),
        isNull,
      );
    });

    test('daily: later today or tomorrow', () {
      final start = DateTime(2026, 1, 1, 16);
      expect(
        nextOccurrence(start, RepeatRule.daily, now),
        DateTime(2026, 10, 12, 16),
      );
      expect(
        nextOccurrence(DateTime(2026, 1, 1, 9), RepeatRule.daily, now),
        DateTime(2026, 10, 13, 9),
      );
    });

    test('weekly keeps the weekday', () {
      // 7 Oct 2026 is a Wednesday.
      final next = nextOccurrence(
        DateTime(2026, 10, 7, 8),
        RepeatRule.weekly,
        now,
      )!;
      expect(next, DateTime(2026, 10, 14, 8));
      expect(next.weekday, DateTime.wednesday);
      // Same weekday, time already passed today → next week.
      expect(
        nextOccurrence(DateTime(2026, 10, 5, 9), RepeatRule.weekly, now),
        DateTime(2026, 10, 19, 9),
      );
    });

    test('monthly skips months without the day', () {
      expect(
        nextOccurrence(DateTime(2026, 1, 31, 9), RepeatRule.monthly, now),
        DateTime(2026, 10, 31, 9),
      );
      final afterOct = DateTime(2026, 11, 1);
      // November has no 31st.
      expect(
        nextOccurrence(DateTime(2026, 1, 31, 9), RepeatRule.monthly, afterOct),
        DateTime(2026, 12, 31, 9),
      );
    });

    test('yearly on 29 February waits for a leap year', () {
      expect(
        nextOccurrence(DateTime(2024, 2, 29, 9), RepeatRule.yearly, now),
        DateTime(2028, 2, 29, 9),
      );
    });
  });

  group('planNotifications', () {
    final car = Vehicle(
      id: 1,
      brand: 'Toyota',
      model: 'Corolla',
      currentOdo: 50000,
      createdAt: DateTime(2026, 1, 1),
    );

    var nextId = 1;
    Reminder reminder(
      DateTime at, {
      RepeatRule repeat = RepeatRule.none,
      bool done = false,
      int? vehicleId,
    }) => Reminder(
      id: nextId++,
      vehicleId: vehicleId,
      title: 'Refuel',
      remindAt: at,
      repeat: repeat,
      isDone: done,
    );

    MaintenanceTask task(String title, {int? dueOdo, DateTime? dueDate}) =>
        MaintenanceTask(
          id: nextId++,
          vehicleId: 1,
          title: title,
          dueOdo: dueOdo,
          dueDate: dueDate,
          remindBeforeKm: 500,
          remindBeforeDays: 14,
          isActive: true,
          createdAt: now,
        );

    OdometerLog log(DateTime date, int value) =>
        OdometerLog(id: nextId++, vehicleId: 1, date: date, value: value);

    List<PlannedNotification> plan({
      List<Reminder> reminders = const [],
      List<MaintenanceTask> tasks = const [],
      List<OdometerLog> logs = const [],
    }) => planNotifications(
      reminders: reminders,
      vehicles: [car],
      tasksByVehicle: {
        1: buildTaskViews(tasks, currentOdo: 50000, logs: logs, now: now),
      },
      logsByVehicle: {1: logs},
      now: now,
    );

    test('reminders: future and repeating ones, not past or done', () {
      final tomorrow = DateTime(2026, 10, 13, 16);
      final result = plan(
        reminders: [
          reminder(tomorrow, vehicleId: 1),
          reminder(DateTime(2026, 10, 1, 9)), // missed one-time
          reminder(DateTime(2026, 10, 1, 9), repeat: RepeatRule.daily),
          reminder(tomorrow, done: true),
        ],
      );

      expect(result.map((n) => n.at), [tomorrow, DateTime(2026, 10, 13, 9)]);
      expect(result.first.body, 'Toyota Corolla');
      expect(result.first.channel, NotificationChannel.reminders);
      expect(result.last.repeat, RepeatRule.daily);
    });

    test('date task: heads-up before the date and on the date', () {
      final t = task('Insurance', dueDate: DateTime(2026, 12, 1));
      final result = plan(tasks: [t]);

      expect(result.map((n) => (n.id, n.at)), [
        (NotificationIds.taskHeadsUp(t.id), DateTime(2026, 11, 17, 10)),
        (NotificationIds.taskDueDay(t.id), DateTime(2026, 12, 1, 10)),
      ]);
      expect(result.first.title, 'Coming up: Insurance');
      expect(result.first.body, 'Toyota Corolla · due on 1 Dec 2026');
      expect(result.first.payload, '/task/${t.id}/edit');
    });

    test('mileage task uses the usual daily mileage', () {
      // 100 km/day; 3000 km left: heads-up at 2500 km → in 25 days.
      final logs = [log(DateTime(2026, 9, 12, 14, 30), 47000), log(now, 50000)];
      final t = task('Engine oil', dueOdo: 53000);
      final result = plan(tasks: [t], logs: logs);

      final taskNotifications = result
          .where((n) => n.channel == NotificationChannel.maintenance)
          .toList();
      expect(taskNotifications.map((n) => n.at), [
        DateTime(2026, 11, 6, 10),
        DateTime(2026, 11, 11, 10),
      ]);
    });

    test('mileage task without history: only the odometer request', () {
      final result = plan(tasks: [task('Engine oil', dueOdo: 53000)]);
      expect(result.single.channel, NotificationChannel.mileage);
      // Last update long ago → tomorrow at 18:00, not today.
      expect(result.single.at, DateTime(2026, 10, 13, odometerHour));
    });

    test('odometer request a week after the last update', () {
      final result = plan(
        tasks: [task('Engine oil', dueOdo: 53000)],
        logs: [log(DateTime(2026, 10, 10, 8), 50000)],
      );
      final mileage = result.singleWhere(
        (n) => n.channel == NotificationChannel.mileage,
      );
      expect(mileage.at, DateTime(2026, 10, 17, odometerHour));
    });

    test('nothing is scheduled for tasks that are already due', () {
      final result = plan(
        tasks: [
          task('Overdue', dueDate: DateTime(2026, 10, 1)),
          task('Soon', dueDate: DateTime(2026, 10, 20)), // heads-up passed
        ],
      );
      // Only the due-day notification of "Soon" is left.
      expect(result.single.title, 'Due today: Soon');
    });

    test('ids are unique', () {
      final result = plan(
        reminders: [
          reminder(DateTime(2026, 10, 13, 9)),
          reminder(DateTime(2026, 10, 14, 9)),
        ],
        tasks: [
          task('A', dueOdo: 60000, dueDate: DateTime(2027, 1, 1)),
          task('B', dueDate: DateTime(2027, 2, 1)),
        ],
        logs: [log(DateTime(2026, 9, 12), 47000), log(now, 50000)],
      );
      expect(result.map((n) => n.id).toSet(), hasLength(result.length));
      expect(result.every((n) => n.at.isAfter(now)), isTrue);
    });
  });

  group('newlyDue', () {
    TaskView view(int id, Urgency urgency) => TaskView(
      task: MaintenanceTask(
        id: id,
        vehicleId: 1,
        title: 'T$id',
        remindBeforeKm: 500,
        remindBeforeDays: 14,
        isActive: true,
        createdAt: now,
      ),
      status: TaskStatus(urgency: urgency),
    );

    test('reports tasks that just became due', () {
      final result = newlyDue(
        {1: Urgency.ok, 2: Urgency.dueSoon, 3: Urgency.ok, 4: Urgency.dueSoon},
        [
          view(1, Urgency.dueSoon), // ok → soon
          view(2, Urgency.dueSoon), // unchanged
          view(3, Urgency.ok), // unchanged
          view(4, Urgency.overdue), // soon → overdue
          view(5, Urgency.overdue), // new task
        ],
      );
      expect(result.map((v) => v.task.id), [1, 4]);
    });

    test('nothing on the first check after start', () {
      expect(newlyDue(null, [view(1, Urgency.overdue)]), isEmpty);
    });
  });
}

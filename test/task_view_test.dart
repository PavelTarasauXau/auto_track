import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/domain/maintenance_templates.dart';
import 'package:auto_track/domain/task_schedule.dart';
import 'package:auto_track/domain/task_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 11, 9);

  group('averageDailyKm', () {
    test('mileage growth over the period', () {
      final daily = averageDailyKm([
        (DateTime(2026, 9, 1), 50000),
        (DateTime(2026, 10, 1), 51500),
      ]);
      expect(daily, closeTo(50, 0.01));
    });

    test('prefers recent readings when they span two weeks', () {
      final daily = averageDailyKm([
        (DateTime(2024, 1, 1), 10000), // old, very different pace
        (DateTime(2026, 8, 1), 40000),
        (DateTime(2026, 10, 1), 46100),
      ]);
      expect(daily, closeTo(100, 0.01));
    });

    test('null without enough data', () {
      expect(averageDailyKm([(DateTime(2026, 10, 1), 50000)]), isNull);
      expect(
        averageDailyKm([
          (DateTime(2026, 10, 1), 50000),
          (DateTime(2026, 10, 3), 50200), // only 2 days
        ]),
        isNull,
      );
      expect(
        averageDailyKm([
          (DateTime(2026, 9, 1), 50000),
          (DateTime(2026, 10, 1), 50000), // car not driven
        ]),
        isNull,
      );
    });
  });

  test('predictDate', () {
    expect(predictDate(500, 50, now), DateTime(2026, 10, 21));
  });

  test('months and days conversion', () {
    expect(monthsToDays(12), 365);
    expect(monthsToDays(24), 730);
    expect(monthsToDays(6), 183);
    expect(daysToMonths(365), 12);
    expect(daysToMonths(183), 6);
    expect(daysToMonths(45), isNull);
    for (final t in maintenanceTemplates) {
      if (t.intervalMonths != null) {
        expect(daysToMonths(t.intervalDays!), t.intervalMonths);
      }
    }
  });

  test('interval labels', () {
    expect(intervalLabel(10000, 365), 'Every 10,000 km or 1 year');
    expect(intervalLabel(null, 730), 'Every 2 years');
    expect(intervalLabel(15000, 183), 'Every 15,000 km or 6 months');
    expect(intervalLabel(null, 45), 'Every 45 days');
    expect(intervalLabel(null, null), 'One-time');
  });

  group('buildTaskViews', () {
    var nextId = 1;
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

    test('sorts by urgency, then by how soon', () {
      final views = buildTaskViews(
        [
          task('Far', dueOdo: 70000),
          task('Overdue', dueOdo: 49000),
          task('Soon by km', dueOdo: 50400),
          task('Unknown'),
          task('Soon by date', dueDate: DateTime(2026, 10, 13)),
          task('Near', dueOdo: 55000),
        ],
        currentOdo: 50000,
        logs: const [],
        now: now,
      );
      expect(views.map((v) => v.task.title), [
        'Overdue',
        'Soon by date', // 2 days
        'Soon by km', // 400 km ≈ 8 days at the fallback pace
        'Near',
        'Far',
        'Unknown',
      ]);
    });

    test('predicts the date from odometer history', () {
      final views = buildTaskViews(
        [task('Oil', dueOdo: 51000)],
        currentOdo: 50000,
        logs: [log(DateTime(2026, 9, 11), 47000), log(now, 50000)],
        now: now,
      );
      // 3000 km in 30 days = 100 km/day → 1000 km in 10 days.
      expect(views.single.predicted, DateTime(2026, 10, 21));
      expect(views.single.expectedDate, DateTime(2026, 10, 21));
    });

    test('remaining labels', () {
      String label({int? dueOdo, DateTime? dueDate}) => buildTaskViews(
        [task('T', dueOdo: dueOdo, dueDate: dueDate)],
        currentOdo: 50000,
        logs: const [],
        now: now,
      ).single.remainingLabel;

      expect(label(dueOdo: 50300), 'in 300 km');
      expect(label(dueOdo: 49500), '500 km overdue');
      expect(label(dueDate: DateTime(2026, 10, 11)), 'due today');
      expect(label(dueDate: DateTime(2026, 10, 12)), 'tomorrow');
      expect(label(dueDate: DateTime(2026, 10, 8)), '3 days overdue');
      expect(
        label(dueOdo: 52000, dueDate: DateTime(2026, 11, 10)),
        'in 2,000 km · in 30 days',
      );
      expect(label(), 'No due date');
    });
  });

  group('healthScore', () {
    TaskView view(Urgency urgency, {double? progress}) => TaskView(
      task: MaintenanceTask(
        id: 1,
        vehicleId: 1,
        title: 'T',
        remindBeforeKm: 500,
        remindBeforeDays: 14,
        isActive: true,
        createdAt: now,
      ),
      status: TaskStatus(urgency: urgency, progress: progress),
    );

    test('average share of intervals left; overdue counts as zero', () {
      expect(
        healthScore([
          view(Urgency.ok, progress: 0.2), // 80 % left
          view(Urgency.dueSoon, progress: 0.9), // 10 % left
          view(Urgency.overdue, progress: 1.3), // 0
        ]),
        30,
      );
    });

    test('unknown tasks are ignored; no data gives null', () {
      expect(
        healthScore([view(Urgency.ok, progress: 0.5), view(Urgency.unknown)]),
        50,
      );
      expect(healthScore([view(Urgency.unknown)]), isNull);
      expect(healthScore(const []), isNull);
    });
  });
}

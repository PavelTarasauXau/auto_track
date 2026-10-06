import 'package:auto_track/domain/task_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('computeDue', () {
    test('adds intervals to the last completion', () {
      final due = computeDue(
        intervalKm: 10000,
        intervalDays: 365,
        lastDoneOdo: 50000,
        lastDoneDate: DateTime(2026, 1, 10, 15, 30),
      );
      expect(due.odo, 60000);
      expect(due.date, DateTime(2027, 1, 10));
    });

    test('falls back to fixed values when never done', () {
      final due = computeDue(
        intervalKm: 10000,
        fixedOdo: 85000,
        fixedDate: DateTime(2026, 5, 1),
      );
      expect(due.odo, 85000);
      expect(due.date, DateTime(2026, 5, 1));
    });

    test('has no due point without data', () {
      final due = computeDue(intervalKm: 10000);
      expect(due.odo, isNull);
      expect(due.date, isNull);
    });
  });

  group('evaluateTask', () {
    final now = DateTime(2026, 10, 6, 12);

    TaskStatus eval({int? dueOdo, DateTime? dueDate, int odo = 50000}) =>
        evaluateTask(
          dueOdo: dueOdo,
          dueDate: dueDate,
          currentOdo: odo,
          now: now,
          intervalKm: 10000,
          intervalDays: 365,
        );

    test('ok when far from both limits', () {
      final s = eval(dueOdo: 58000, dueDate: DateTime(2027, 3, 1));
      expect(s.urgency, Urgency.ok);
      expect(s.kmLeft, 8000);
    });

    test('due soon by mileage', () {
      final s = eval(dueOdo: 50300, dueDate: DateTime(2027, 3, 1));
      expect(s.urgency, Urgency.dueSoon);
      expect(s.kmLeft, 300);
    });

    test('due soon by date', () {
      final s = eval(dueOdo: 58000, dueDate: DateTime(2026, 10, 16));
      expect(s.urgency, Urgency.dueSoon);
      expect(s.daysLeft, 10);
    });

    test('overdue by date even if mileage is fine', () {
      final s = eval(dueOdo: 58000, dueDate: DateTime(2026, 10, 5));
      expect(s.urgency, Urgency.overdue);
      expect(s.daysLeft, -1);
    });

    test('overdue by mileage', () {
      final s = eval(dueOdo: 49000);
      expect(s.urgency, Urgency.overdue);
      expect(s.kmLeft, -1000);
      expect(s.progress, closeTo(1.1, 0.001));
    });

    test('due today is not overdue yet', () {
      expect(eval(dueDate: DateTime(2026, 10, 6)).urgency, Urgency.dueSoon);
    });

    test('unknown without due point', () {
      expect(eval().urgency, Urgency.unknown);
    });
  });
}

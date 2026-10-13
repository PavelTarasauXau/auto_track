import 'package:auto_track/core/enums.dart';
import 'package:auto_track/data/db/database.dart';
import 'package:auto_track/domain/stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 13);
  var nextId = 1;

  ServiceRecord record(
    DateTime date,
    int odo,
    double? cost, {
    RecordType type = RecordType.service,
  }) => ServiceRecord(
    id: nextId++,
    vehicleId: 1,
    type: type,
    date: date,
    odometer: odo,
    title: type.label,
    cost: cost,
    createdAt: date,
  );

  (ServiceRecord, FuelDetail) fill(
    DateTime date,
    int odo,
    double liters, {
    bool full = true,
    double price = 1.5,
  }) {
    final r = record(date, odo, liters * price, type: RecordType.fuel);
    return (
      r,
      FuelDetail(
        recordId: r.id,
        liters: liters,
        pricePerLiter: price,
        fullTank: full,
      ),
    );
  }

  group('costStats', () {
    final records = [
      record(DateTime(2025, 12, 20), 40000, 300), // before this year
      record(DateTime(2026, 2, 10), 42000, 100),
      record(DateTime(2026, 2, 25), 43000, 50, type: RecordType.wash),
      record(DateTime(2026, 9, 1), 50000, 200, type: RecordType.repair),
      record(DateTime(2026, 9, 5), 50100, null), // no cost
    ];
    List<(DateTime, int)> readings() => [
      for (final r in records) (r.date, r.odometer),
      (DateTime(2026, 10, 10), 51000),
    ];

    test('totals and categories of the period', () {
      final s = costStats(records, readings(), from: DateTime(2026), now: now);
      expect(s.total, 350);
      expect(s.byType, {
        RecordType.repair: 200,
        RecordType.service: 100,
        RecordType.wash: 50,
      });
      expect(s.byType.keys.first, RecordType.repair); // largest first
    });

    test('distance counts from the last reading before the period', () {
      final s = costStats(records, readings(), from: DateTime(2026), now: now);
      // 40,000 at the end of 2025 → 51,000 now.
      expect(s.kmDriven, 11000);
      expect(s.costPerKm, closeTo(350 / 11000, 1e-9));
    });

    test('monthly chart covers the period month by month', () {
      final s = costStats(records, readings(), from: DateTime(2026), now: now);
      expect(s.monthly.map((m) => m.month.month), [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, //
      ]);
      expect(s.monthly[1].value, 150); // February
      expect(s.monthly[0].value, 0);
    });

    test('all time is limited to the last 12 months in the chart', () {
      final s = costStats(records, readings(), from: null, now: now);
      expect(s.total, 650);
      expect(s.monthly, hasLength(11)); // Dec 2025 … Oct 2026
      expect(s.kmDriven, 11000);
      expect(s.costPerKmTrend.last.value, closeTo(650 / 11000, 1e-9));
    });

    test('no odometer data gives no distance', () {
      final s = costStats(const [], const [], from: null, now: now);
      expect(s.kmDriven, isNull);
      expect(s.costPerKm, isNull);
      expect(s.total, 0);
    });
  });

  group('fuelStats', () {
    test('full tank to full tank consumption', () {
      final fills = [
        fill(DateTime(2026, 9, 1), 50000, 45), // first full: baseline
        fill(DateTime(2026, 9, 10), 50300, 20, full: false),
        fill(DateTime(2026, 9, 20), 50600, 22), // 42 L for 600 km
        fill(DateTime(2026, 10, 1), 51000, 30), // 30 L for 400 km
      ];
      final s = fuelStats(fills, from: null);

      expect(s.avgConsumption, closeTo(72 / 1000 * 100, 1e-9)); // 7.2
      expect(s.fillUps, 4);
      expect(s.liters, 117);
      expect(s.avgPricePerLiter, closeTo(1.5, 1e-9));
      expect(s.avgFillUpCost, closeTo(117 * 1.5 / 4, 1e-9));
    });

    test('period counts segments that end in it', () {
      final fills = [
        fill(DateTime(2026, 9, 1), 50000, 45),
        fill(DateTime(2026, 9, 20), 50600, 42),
        fill(DateTime(2026, 10, 1), 51000, 30),
      ];
      final s = fuelStats(fills, from: DateTime(2026, 10));
      expect(s.avgConsumption, closeTo(7.5, 1e-9)); // 30 L / 400 km
      expect(s.fillUps, 1);
    });

    test('no consumption without two full tanks', () {
      final s = fuelStats([
        fill(DateTime(2026, 9, 1), 50000, 45, full: false),
        fill(DateTime(2026, 9, 20), 50600, 42),
      ], from: null);
      expect(s.avgConsumption, isNull);
      expect(fuelStats(const [], from: null).avgFillUpCost, isNull);
    });
  });
}

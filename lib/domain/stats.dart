/// Spending and fuel statistics. Pure functions, covered by unit tests.
library;

import 'dart:math';

import '../core/enums.dart';
import '../data/db/database.dart';

enum StatsPeriod {
  month('Month'),
  year('Year'),
  all('All time');

  const StatsPeriod(this.label);

  final String label;

  /// Start of the period, or `null` for all time.
  DateTime? from(DateTime now) => switch (this) {
    StatsPeriod.month => DateTime(now.year, now.month),
    StatsPeriod.year => DateTime(now.year),
    StatsPeriod.all => null,
  };
}

class MonthValue {
  const MonthValue(this.month, this.value);

  /// First day of the month.
  final DateTime month;
  final double value;
}

class CostStats {
  const CostStats({
    required this.total,
    required this.byType,
    required this.monthly,
    required this.costPerKmTrend,
    this.kmDriven,
  });

  final double total;

  /// Only types with spending, largest first.
  final Map<RecordType, double> byType;

  /// Spending per month for the chart (at most the last 12 months).
  final List<MonthValue> monthly;

  /// Cost of 1 km accumulated from the period start, per month.
  final List<MonthValue> costPerKmTrend;

  /// Distance driven in the period; `null` without odometer data.
  final int? kmDriven;

  double? get costPerKm =>
      kmDriven == null || kmDriven! <= 0 ? null : total / kmDriven!;
}

class FuelStats {
  const FuelStats({
    required this.fillUps,
    required this.liters,
    this.avgConsumption,
    this.avgFillUpCost,
    this.avgPricePerLiter,
  });

  final int fillUps;
  final double liters;

  /// Liters per 100 km by the full-tank method; `null` without two full
  /// tanks to compare.
  final double? avgConsumption;
  final double? avgFillUpCost;
  final double? avgPricePerLiter;
}

/// Spending in the period starting at [from] (all time when `null`).
///
/// [readings] are odometer values `(date, km)` from all sources (odometer
/// log and records); they give the distance driven.
CostStats costStats(
  List<ServiceRecord> records,
  List<(DateTime, int)> readings, {
  required DateTime? from,
  required DateTime now,
}) {
  final inPeriod = [
    for (final r in records)
      if (from == null || !r.date.isBefore(from)) r,
  ];

  var total = 0.0;
  final byType = <RecordType, double>{};
  final byMonth = <DateTime, double>{};
  for (final r in inPeriod) {
    final cost = r.cost ?? 0;
    if (cost <= 0) continue;
    total += cost;
    byType[r.type] = (byType[r.type] ?? 0) + cost;
    final m = DateTime(r.date.year, r.date.month);
    byMonth[m] = (byMonth[m] ?? 0) + cost;
  }

  // Chart months: from the period start (or the first record) to now,
  // at most the last 12.
  final firstMonth =
      from ?? _firstMonth(inPeriod) ?? DateTime(now.year, now.month);
  final months = _monthsBetween(firstMonth, DateTime(now.year, now.month));
  final chartMonths = months.length > 12
      ? months.sublist(months.length - 12)
      : months;

  // Odometer: value at the period start (last reading before it, or the
  // first one inside) and the latest reading.
  final sorted = [...readings]..sort((a, b) => a.$1.compareTo(b.$1));
  int? startOdo;
  for (final (date, km) in sorted) {
    if (from != null && date.isBefore(from)) {
      startOdo = km;
    } else {
      startOdo ??= km;
      break;
    }
  }
  final endOdo = sorted.isEmpty ? null : sorted.map((r) => r.$2).reduce(max);
  final kmDriven = startOdo == null || endOdo == null
      ? null
      : endOdo - startOdo;

  // Cumulative cost per km at the end of each chart month.
  final trend = <MonthValue>[];
  if (startOdo != null) {
    var cumulative = 0.0;
    for (final m in months) {
      cumulative += byMonth[m] ?? 0;
      final monthEnd = DateTime(m.year, m.month + 1);
      final odo = sorted
          .where((r) => r.$1.isBefore(monthEnd))
          .map((r) => r.$2)
          .fold<int?>(null, (a, b) => a == null ? b : max(a, b));
      final km = odo == null ? 0 : odo - startOdo;
      if (km > 0 && chartMonths.contains(m)) {
        trend.add(MonthValue(m, cumulative / km));
      }
    }
  }

  final sortedTypes = byType.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return CostStats(
    total: total,
    byType: {for (final e in sortedTypes) e.key: e.value},
    monthly: [for (final m in chartMonths) MonthValue(m, byMonth[m] ?? 0)],
    costPerKmTrend: trend,
    kmDriven: kmDriven,
  );
}

/// Fuel statistics for fill-ups in the period starting at [from].
FuelStats fuelStats(
  List<(ServiceRecord, FuelDetail)> fills, {
  required DateTime? from,
}) {
  bool inPeriod(ServiceRecord r) => from == null || !r.date.isBefore(from);

  final period = fills.where((f) => inPeriod(f.$1)).toList();
  final liters = period.fold<double>(0, (s, f) => s + f.$2.liters);
  final costs = [
    for (final f in period) f.$1.cost ?? f.$2.liters * f.$2.pricePerLiter,
  ];
  final spent = costs.fold<double>(0, (a, b) => a + b);

  // Full tank to full tank: the liters of all fill-ups after a full tank
  // up to (and including) the next full tank were burnt over that
  // distance. Segments ending in the period are counted.
  final byOdo = [...fills]
    ..sort((a, b) => a.$1.odometer.compareTo(b.$1.odometer));
  var segLiters = 0.0;
  var totalLiters = 0.0;
  var totalKm = 0;
  int? lastFullOdo;
  for (final (record, fuel) in byOdo) {
    if (lastFullOdo != null) segLiters += fuel.liters;
    if (!fuel.fullTank) continue;
    if (lastFullOdo != null &&
        record.odometer > lastFullOdo &&
        inPeriod(record)) {
      totalLiters += segLiters;
      totalKm += record.odometer - lastFullOdo;
    }
    lastFullOdo = record.odometer;
    segLiters = 0;
  }

  return FuelStats(
    fillUps: period.length,
    liters: liters,
    avgConsumption: totalKm > 0 ? totalLiters / totalKm * 100 : null,
    avgFillUpCost: period.isEmpty ? null : spent / period.length,
    avgPricePerLiter: liters > 0 ? spent / liters : null,
  );
}

DateTime? _firstMonth(List<ServiceRecord> records) {
  if (records.isEmpty) return null;
  final first = records
      .map((r) => r.date)
      .reduce((a, b) => a.isBefore(b) ? a : b);
  return DateTime(first.year, first.month);
}

List<DateTime> _monthsBetween(DateTime first, DateTime last) => [
  for (var m = first; !m.isAfter(last); m = DateTime(m.year, m.month + 1)) m,
];

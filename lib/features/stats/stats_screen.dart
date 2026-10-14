import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../domain/stats.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import '../../widgets/record_type_icon.dart';
import '../../widgets/ui.dart';

final statsPeriodProvider = NotifierProvider<StatsPeriodNotifier, StatsPeriod>(
  StatsPeriodNotifier.new,
);

class StatsPeriodNotifier extends Notifier<StatsPeriod> {
  @override
  StatsPeriod build() => StatsPeriod.year;

  void set(StatsPeriod period) => state = period;
}

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(currentVehicleProvider).value;
    final period = ref.watch(statsPeriodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: vehicle == null
          ? const PlaceholderView(
              icon: Icons.bar_chart,
              title: 'No vehicle',
              subtitle: 'Add a vehicle on the Home tab first',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                SegmentedButton<StatsPeriod>(
                  segments: [
                    for (final p in StatsPeriod.values)
                      ButtonSegment(value: p, label: Text(p.label)),
                  ],
                  selected: {period},
                  onSelectionChanged: (s) =>
                      ref.read(statsPeriodProvider.notifier).set(s.first),
                ),
                const SizedBox(height: 16),
                _StatsBody(vehicle: vehicle, period: period),
              ],
            ),
    );
  }
}

class _StatsBody extends ConsumerWidget {
  const _StatsBody({required this.vehicle, required this.period});

  final Vehicle vehicle;
  final StatsPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(allRecordsProvider(vehicle.id)).value;
    final fills = ref.watch(fuelRecordsProvider(vehicle.id)).value;
    final logs = ref.watch(odometerLogProvider(vehicle.id)).value;
    if (records == null || fills == null || logs == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 64),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 48),
        child: PlaceholderView(
          icon: Icons.bar_chart,
          title: 'No data yet',
          subtitle: 'Statistics appear once you log refuels and services',
        ),
      );
    }

    final now = DateTime.now();
    final from = period.from(now);
    final readings = [
      for (final l in logs) (l.date, l.value),
      for (final r in records) (r.date, r.odometer),
    ];
    final cost = costStats(records, readings, from: from, now: now);
    final fuel = fuelStats(fills, from: from);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MetricsGrid(cost: cost, fuel: fuel),
        const SizedBox(height: 16),
        if (cost.byType.isNotEmpty)
          _ChartCard(
            title: 'Spending by category',
            child: _CategoryPie(byType: cost.byType, total: cost.total),
          ),
        if (cost.monthly.length > 1)
          _ChartCard(
            title: 'Spending by month',
            child: _MonthlyBars(months: cost.monthly),
          ),
        if (cost.costPerKmTrend.length > 1)
          _ChartCard(
            title: 'Cost of 1 km',
            subtitle: 'All spending divided by distance driven',
            child: _CostPerKmLine(points: cost.costPerKmTrend),
          ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.cost, required this.fuel});

  final CostStats cost;
  final FuelStats fuel;

  @override
  Widget build(BuildContext context) {
    final km = cost.kmDriven;
    final perKm = cost.costPerKm;
    final consumption = fuel.avgConsumption;
    final fillUp = fuel.avgFillUpCost;
    final price = fuel.avgPricePerLiter;

    final metrics = [
      (
        Icons.payments_outlined,
        AppColors.cyan,
        'Total spent',
        formatMoney(cost.total),
      ),
      (
        Icons.route_outlined,
        AppColors.violet,
        'Distance',
        km == null ? '—' : formatKm(km),
      ),
      (
        Icons.speed,
        AppColors.ok,
        'Cost of 1 km',
        perKm == null ? '—' : formatMoney(perKm),
      ),
      (
        Icons.local_gas_station_outlined,
        AppColors.soon,
        'Fuel consumption',
        consumption == null ? '—' : '${consumption.toStringAsFixed(1)} L/100km',
      ),
      (
        Icons.receipt_outlined,
        const Color(0xFF2DD4BF),
        'Average refuel',
        fillUp == null ? '—' : formatMoney(fillUp),
      ),
      (
        Icons.water_drop_outlined,
        const Color(0xFFA78BFA),
        'Fuel bought',
        fuel.fillUps == 0
            ? '—'
            : '${formatDecimal(fuel.liters)} L'
                  '${price == null ? '' : ' · ${formatMoney(price)}/L'}',
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        const spacing = 12.0;
        final width = (c.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final (icon, color, label, value) in metrics)
              SizedBox(
                width: width,
                child: _Metric(
                  icon: icon,
                  color: color,
                  label: label,
                  value: value,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlowIcon(icon, color: color, size: 36),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontFamily: displayFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, this.subtitle, required this.child});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: displayFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              if (subtitle != null)
                Text(subtitle!, style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPie extends StatelessWidget {
  const _CategoryPie({required this.byType, required this.total});

  final Map<RecordType, double> byType;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 48,
                  sectionsSpace: 3,
                  sections: [
                    for (final MapEntry(key: type, value: v) in byType.entries)
                      PieChartSectionData(
                        value: v,
                        color: RecordTypeIcon.colorOf(type),
                        radius: 22,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatMoney(total),
                    style: const TextStyle(
                      fontFamily: displayFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text('total', style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final MapEntry(key: type, value: v) in byType.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: RecordTypeIcon.colorOf(type),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(type.label)),
                      Text(
                        '${(v / total * 100).round()}%',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

final _monthLabel = DateFormat('MMM', 'en_US');

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.months});

  final List<MonthValue> months;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: _titles(
            context,
            bottom: (v) => _monthLabel.format(months[v.toInt()].month),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                formatMoney(rod.toY),
                TextStyle(color: scheme.onInverseSurface),
              ),
              getTooltipColor: (_) => scheme.inverseSurface,
            ),
          ),
          barGroups: [
            for (final (i, m) in months.indexed)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: m.value,
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppColors.violet, AppColors.cyan],
                    ),
                    width: 14,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CostPerKmLine extends StatelessWidget {
  const _CostPerKmLine({required this.points});

  final List<MonthValue> points;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: _titles(
            context,
            bottom: (v) => _monthLabel.format(points[v.toInt()].month),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    formatMoney(s.y),
                    TextStyle(color: scheme.onInverseSurface),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (final (i, p) in points.indexed)
                  FlSpot(i.toDouble(), p.value),
              ],
              isCurved: true,
              preventCurveOverShooting: true,
              gradient: AppColors.accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.cyan.withValues(alpha: 0.25),
                    AppColors.cyan.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Month labels at the bottom, values on the left, nothing else.
FlTitlesData _titles(
  BuildContext context, {
  required String Function(double value) bottom,
}) {
  final style = Theme.of(context).textTheme.bodySmall;
  return FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 44,
        getTitlesWidget: (v, meta) => SideTitleWidget(
          meta: meta,
          child: Text(
            NumberFormat.compact(locale: 'en').format(v),
            style: style,
          ),
        ),
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (v, meta) => v != v.roundToDouble()
            ? const SizedBox.shrink()
            : SideTitleWidget(
                meta: meta,
                child: Text(bottom(v), style: style),
              ),
      ),
    ),
  );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import 'history_controller.dart';
import 'record_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => ref.read(historyQueryProvider.notifier).setSearch(text),
    );
  }

  void _closeSearch() {
    _debounce?.cancel();
    _searchController.clear();
    ref.read(historyQueryProvider.notifier).setSearch('');
    setState(() => _searching = false);
  }

  /// Loads the next page when the list is scrolled close to the end.
  bool _onScroll(ScrollNotification n, List<ServiceRecord> records) {
    final query = ref.read(historyQueryProvider);
    final hasMore = records.length >= query.limit;
    if (hasMore && n.metrics.extentAfter < 500) {
      ref.read(historyQueryProvider.notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ref.watch(currentVehicleProvider).value;
    final records = ref.watch(historyRecordsProvider);
    final query = ref.watch(historyQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search title, station, parts…',
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('History'),
        actions: [
          if (vehicle != null)
            IconButton(
              tooltip: _searching ? 'Close search' : 'Search',
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: _searching
                  ? _closeSearch
                  : () => setState(() => _searching = true),
            ),
        ],
        bottom: vehicle == null
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: _FilterBar(query: query),
              ),
      ),
      floatingActionButton: vehicle == null
          ? null
          : FloatingActionButton(
              tooltip: 'Add record',
              onPressed: () => context.push(Routes.newRecord),
              child: const Icon(Icons.add),
            ),
      body: vehicle == null
          ? const PlaceholderView(
              icon: Icons.history,
              title: 'No vehicle',
              subtitle: 'Add a vehicle on the Home tab first',
            )
          : records.when(
              skipLoadingOnReload: true,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) {
                if (list.isEmpty) {
                  return query.isFiltered
                      ? const PlaceholderView(
                          icon: Icons.search_off,
                          title: 'Nothing found',
                          subtitle: 'Try other filters or search words',
                        )
                      : const PlaceholderView(
                          icon: Icons.history,
                          title: 'No records yet',
                          subtitle:
                              'Log refuels, services and repairs '
                              'with the + button',
                        );
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) => _onScroll(n, list),
                  child: _RecordList(records: list),
                );
              },
            ),
    );
  }
}

/// Period menu and type chips under the app bar.
class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.query});

  final HistoryQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(historyQueryProvider.notifier);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          PopupMenuButton<HistoryPeriod>(
            initialValue: query.period,
            onSelected: controller.setPeriod,
            itemBuilder: (_) => [
              for (final p in HistoryPeriod.values)
                PopupMenuItem(value: p, child: Text(p.label)),
            ],
            child: IgnorePointer(
              child: FilterChip(
                avatar: const Icon(Icons.date_range, size: 18),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(query.period.label),
                    const Icon(Icons.arrow_drop_down, size: 18),
                  ],
                ),
                selected: query.period != HistoryPeriod.all,
                showCheckmark: false,
                onSelected: (_) {},
              ),
            ),
          ),
          const SizedBox(width: 8),
          for (final type in RecordType.values) ...[
            FilterChip(
              avatar: Icon(type.icon, size: 18),
              label: Text(type.label),
              selected: query.types.contains(type),
              showCheckmark: false,
              onSelected: (_) => controller.toggleType(type),
            ),
            const SizedBox(width: 8),
          ],
          if (query.types.isNotEmpty)
            ActionChip(
              avatar: const Icon(Icons.clear, size: 18),
              label: const Text('Clear'),
              onPressed: controller.clearTypes,
            ),
        ],
      ),
    );
  }
}

/// Records grouped by month with the month total in the header.
class _RecordList extends StatelessWidget {
  const _RecordList({required this.records});

  final List<ServiceRecord> records;

  @override
  Widget build(BuildContext context) {
    final rows = <Object>[]; // DateTime (month header) or ServiceRecord
    final totals = <DateTime, double>{};
    for (final r in records) {
      final month = DateTime(r.date.year, r.date.month);
      if (rows.isEmpty || !totals.containsKey(month)) rows.add(month);
      totals[month] = (totals[month] ?? 0) + (r.cost ?? 0);
      rows.add(r);
    }

    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final row = rows[i];
        if (row is ServiceRecord) return RecordTile(record: row);

        final month = row as DateTime;
        final total = totals[month]!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatMonth(month),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (total > 0)
                Text(
                  formatMoney(total),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

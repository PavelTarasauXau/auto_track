import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../data/db/database.dart';
import '../../data/repositories/record_models.dart';
import '../../providers.dart';

enum HistoryPeriod {
  all('All time'),
  month('This month'),
  year('This year');

  const HistoryPeriod(this.label);

  final String label;

  DateTime? get from {
    final now = DateTime.now();
    return switch (this) {
      HistoryPeriod.all => null,
      HistoryPeriod.month => DateTime(now.year, now.month),
      HistoryPeriod.year => DateTime(now.year),
    };
  }
}

class HistoryQuery {
  const HistoryQuery({
    this.types = const {},
    this.period = HistoryPeriod.all,
    this.search = '',
    this.limit = HistoryController.pageSize,
  });

  final Set<RecordType> types;
  final HistoryPeriod period;
  final String search;

  /// Grows by [HistoryController.pageSize] as the user scrolls.
  final int limit;

  bool get isFiltered =>
      types.isNotEmpty || period != HistoryPeriod.all || search.isNotEmpty;

  HistoryQuery copyWith({
    Set<RecordType>? types,
    HistoryPeriod? period,
    String? search,
    int? limit,
  }) => HistoryQuery(
    types: types ?? this.types,
    period: period ?? this.period,
    search: search ?? this.search,
    limit: limit ?? this.limit,
  );
}

/// Filters and page size of the history list.
class HistoryController extends Notifier<HistoryQuery> {
  static const pageSize = 30;

  @override
  HistoryQuery build() {
    // Start over when another vehicle is selected.
    ref.watch(selectedVehicleIdProvider);
    return const HistoryQuery();
  }

  // Changing a filter resets the list to the first page.
  void toggleType(RecordType type) {
    final types = {...state.types};
    if (!types.remove(type)) types.add(type);
    state = state.copyWith(types: types, limit: pageSize);
  }

  void clearTypes() => state = state.copyWith(types: {}, limit: pageSize);

  void setPeriod(HistoryPeriod period) =>
      state = state.copyWith(period: period, limit: pageSize);

  void setSearch(String search) =>
      state = state.copyWith(search: search.trim(), limit: pageSize);

  void loadMore() => state = state.copyWith(limit: state.limit + pageSize);
}

final historyQueryProvider = NotifierProvider<HistoryController, HistoryQuery>(
  HistoryController.new,
);

/// Records of the current vehicle matching [historyQueryProvider].
final historyRecordsProvider = StreamProvider<List<ServiceRecord>>((ref) {
  final vehicle = ref.watch(currentVehicleProvider).value;
  if (vehicle == null) return Stream.value(const []);
  final query = ref.watch(historyQueryProvider);
  return ref
      .watch(recordRepositoryProvider)
      .watchRecords(
        vehicle.id,
        filter: RecordFilter(
          types: query.types,
          from: query.period.from,
          query: query.search,
        ),
        limit: query.limit,
      );
});

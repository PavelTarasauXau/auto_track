import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/record_models.dart';

final _date = DateFormat('yyyy-MM-dd', 'en_US');

/// History of a vehicle as CSV. Starts with a byte order mark so that
/// Excel opens non-Latin text (e.g. Cyrillic) correctly.
String buildRecordsCsv(List<RecordDetails> records) {
  final rows = <List<Object?>>[
    [
      'Date',
      'Mileage (km)',
      'Type',
      'Title',
      'Station',
      'Cost',
      'Liters',
      'Price per liter',
      'Full tank',
      'Works & parts',
      'Completed maintenance',
      'Note',
    ],
    for (final d in records)
      [
        _date.format(d.record.date),
        d.record.odometer,
        d.record.type.label,
        d.record.title,
        d.record.station ?? '',
        d.record.cost?.toStringAsFixed(2) ?? '',
        d.fuel?.liters ?? '',
        d.fuel?.pricePerLiter ?? '',
        d.fuel == null ? '' : (d.fuel!.fullTank ? 'yes' : 'no'),
        d.items
            .map(
              (i) => [
                i.name,
                if (i.partNumber != null) '(${i.partNumber})',
                if (i.cost != null) i.cost!.toStringAsFixed(2),
              ].join(' '),
            )
            .join('; '),
        d.completedTasks.map((t) => t.title).join('; '),
        d.record.note ?? '',
      ],
  ];
  return '\uFEFF${Csv().encode(rows)}';
}

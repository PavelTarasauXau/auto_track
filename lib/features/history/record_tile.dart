import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../widgets/record_type_icon.dart';

/// One record in a list: type icon, title, date and mileage, cost.
class RecordTile extends StatelessWidget {
  const RecordTile({super.key, required this.record});

  final ServiceRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = [
      formatDate(record.date),
      formatKm(record.odometer),
      ?record.station,
    ].join(' · ');

    return ListTile(
      leading: RecordTypeIcon(record.type),
      title: Text(record.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: record.cost == null
          ? null
          : Text(formatMoney(record.cost!), style: theme.textTheme.titleSmall),
      onTap: () => context.push(Routes.record(record.id)),
    );
  }
}

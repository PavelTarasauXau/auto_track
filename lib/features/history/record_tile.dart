import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../widgets/record_type_icon.dart';

/// One record in a list: type icon, title, date and mileage, cost.
class RecordTile extends StatelessWidget {
  const RecordTile({super.key, required this.record});

  final ServiceRecord record;

  @override
  Widget build(BuildContext context) {
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
          : Text(
              formatMoney(record.cost!),
              style: const TextStyle(
                fontFamily: displayFont,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.text,
              ),
            ),
      onTap: () => context.push(Routes.record(record.id)),
    );
  }
}

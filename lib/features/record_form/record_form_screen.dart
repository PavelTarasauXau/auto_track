import 'package:flutter/material.dart';

import '../../widgets/placeholder_view.dart';

class RecordFormScreen extends StatelessWidget {
  const RecordFormScreen({super.key, this.recordId, this.initialType});

  /// `null` when creating a new record.
  final int? recordId;

  /// Preselected record type for a new record, e.g. `fuel`.
  final String? initialType;

  @override
  Widget build(BuildContext context) {
    final isNew = recordId == null;
    return Scaffold(
      appBar: AppBar(title: Text(isNew ? 'New record' : 'Edit record')),
      body: PlaceholderView(
        icon: Icons.edit_note,
        title: isNew ? 'New record' : 'Record #$recordId',
        subtitle: initialType != null ? 'Type: $initialType' : null,
      ),
    );
  }
}

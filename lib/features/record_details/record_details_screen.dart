import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../widgets/placeholder_view.dart';

class RecordDetailsScreen extends StatelessWidget {
  const RecordDetailsScreen({super.key, required this.recordId});

  final int recordId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () => context.push(Routes.editRecord(recordId)),
          ),
        ],
      ),
      body: PlaceholderView(
        icon: Icons.receipt_long,
        title: 'Record #$recordId',
        subtitle: 'Full details and receipt gallery',
      ),
    );
  }
}

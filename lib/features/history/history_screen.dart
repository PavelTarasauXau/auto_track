import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../widgets/placeholder_view.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: PlaceholderView(
        icon: Icons.history,
        title: 'Service history',
        subtitle: 'All records with filters by type and period',
        actions: [
          OutlinedButton(
            onPressed: () => context.push(Routes.record(1)),
            child: const Text('Open sample record'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add record',
        onPressed: () => context.push(Routes.newRecord),
        child: const Icon(Icons.add),
      ),
    );
  }
}

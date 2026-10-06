import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../widgets/placeholder_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoTrack'),
        actions: [
          IconButton(
            tooltip: 'Garage',
            icon: const Icon(Icons.garage_outlined),
            onPressed: () => context.push(Routes.garage),
          ),
          IconButton(
            tooltip: 'Export & backup',
            icon: const Icon(Icons.settings_backup_restore),
            onPressed: () => context.push(Routes.data),
          ),
        ],
      ),
      body: PlaceholderView(
        icon: Icons.directions_car,
        title: 'Dashboard',
        subtitle: 'Current vehicle, odometer and upcoming maintenance',
        actions: [
          FilledButton.icon(
            icon: const Icon(Icons.local_gas_station),
            label: const Text('Refuel'),
            onPressed: () => context.push('${Routes.newRecord}?type=fuel'),
          ),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.build),
            label: const Text('Log service'),
            onPressed: () => context.push('${Routes.newRecord}?type=service'),
          ),
        ],
      ),
    );
  }
}

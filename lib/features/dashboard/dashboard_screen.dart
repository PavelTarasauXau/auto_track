import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import '../../widgets/vehicle_avatar.dart';
import '../garage/odometer_dialog.dart';
import '../garage/vehicle_text.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentVehicleProvider);
    final vehicle = current.value;

    return Scaffold(
      appBar: AppBar(
        title: vehicle == null
            ? const Text('AutoTrack')
            : _VehicleSwitcher(vehicle: vehicle),
        actions: [
          IconButton(
            tooltip: 'Export & backup',
            icon: const Icon(Icons.settings_backup_restore),
            onPressed: () => context.push(Routes.data),
          ),
        ],
      ),
      body: current.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (vehicle) => vehicle == null
            ? PlaceholderView(
                icon: Icons.directions_car,
                title: 'Welcome to AutoTrack',
                subtitle:
                    'Add your vehicle to track its maintenance, '
                    'service history and documents',
                actions: [
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add vehicle'),
                    onPressed: () => context.push(Routes.newVehicle),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _VehicleCard(vehicle: vehicle),
                  const SizedBox(height: 16),
                  const _QuickActions(),
                ],
              ),
      ),
    );
  }
}

/// App bar title: current vehicle name, opens the garage on tap.
class _VehicleSwitcher extends StatelessWidget {
  const _VehicleSwitcher({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.push(Routes.garage),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(vehicle.displayName, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class _VehicleCard extends ConsumerWidget {
  const _VehicleCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lastUpdate = ref
        .watch(odometerLogProvider(vehicle.id))
        .value
        ?.lastOrNull;

    return Card.filled(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                VehicleAvatar(photoFileName: vehicle.photoFileName, size: 72),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.displayName,
                        style: theme.textTheme.titleLarge,
                      ),
                      if (vehicle.details.isNotEmpty)
                        Text(
                          vehicle.details,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit vehicle',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => context.push(Routes.editVehicle(vehicle.id)),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              children: [
                Icon(Icons.speed, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatKm(vehicle.currentOdo),
                        style: theme.textTheme.headlineSmall,
                      ),
                      if (lastUpdate != null)
                        Text(
                          'Updated ${formatDate(lastUpdate.date)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => showOdometerDialog(context, ref, vehicle),
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            icon: const Icon(Icons.local_gas_station),
            label: const Text('Refuel'),
            onPressed: () => context.push('${Routes.newRecord}?type=fuel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.tonalIcon(
            icon: const Icon(Icons.build),
            label: const Text('Log service'),
            onPressed: () => context.push('${Routes.newRecord}?type=service'),
          ),
        ),
      ],
    );
  }
}

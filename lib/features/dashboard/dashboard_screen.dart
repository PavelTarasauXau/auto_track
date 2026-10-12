import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../domain/task_schedule.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import '../../widgets/vehicle_avatar.dart';
import '../garage/odometer_dialog.dart';
import '../garage/vehicle_text.dart';
import '../history/record_tile.dart';
import '../plan/task_tile.dart';
import '../plan/templates_sheet.dart';

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
                  const SizedBox(height: 24),
                  _Maintenance(vehicle: vehicle),
                  const SizedBox(height: 24),
                  _RecentRecords(vehicleId: vehicle.id),
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

class _RecentRecords extends ConsumerWidget {
  const _RecentRecords({required this.vehicleId});

  final int vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recentRecordsProvider(vehicleId)).value ?? [];
    if (records.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent records',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => context.go(Routes.history),
              child: const Text('See all'),
            ),
          ],
        ),
        Card.outlined(
          child: Column(
            children: [for (final r in records) RecordTile(record: r)],
          ),
        ),
      ],
    );
  }
}

/// Tasks that need attention; when all is fine, the next upcoming ones.
class _Maintenance extends ConsumerWidget {
  const _Maintenance({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final views = ref.watch(taskViewsProvider(vehicle.id)).value;
    if (views == null) return const SizedBox.shrink();

    final urgent = views
        .where(
          (v) => v.urgency == Urgency.overdue || v.urgency == Urgency.dueSoon,
        )
        .toList();
    final shown = urgent.isNotEmpty
        ? urgent
        : views.where((v) => v.urgency == Urgency.ok).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Maintenance', style: theme.textTheme.titleMedium),
            ),
            if (views.isNotEmpty)
              TextButton(
                onPressed: () => context.go(Routes.plan),
                child: const Text('See plan'),
              ),
          ],
        ),
        if (views.isEmpty)
          Card.outlined(
            child: ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Set up a maintenance plan'),
              subtitle: const Text(
                'Get reminded about oil, filters, insurance…',
              ),
              onTap: () => showTemplatesSheet(context, vehicle),
            ),
          )
        else ...[
          if (urgent.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Urgency.ok.color(theme.colorScheme),
                  ),
                  const SizedBox(width: 8),
                  const Text('All good. Coming up next:'),
                ],
              ),
            ),
          for (final v in shown) ...[
            TaskTile(view: v, compact: true),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

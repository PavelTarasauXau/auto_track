import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/placeholder_view.dart';
import '../../widgets/vehicle_avatar.dart';
import 'vehicle_text.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final currentId = ref.watch(currentVehicleProvider).value?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Garage')),
      body: vehicles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => list.isEmpty
            ? PlaceholderView(
                icon: Icons.garage_outlined,
                title: 'Your garage is empty',
                subtitle: 'Add a vehicle to start tracking its maintenance',
                actions: [
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add vehicle'),
                    onPressed: () => context.push(Routes.newVehicle),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _VehicleCard(
                  vehicle: list[i],
                  isCurrent: list[i].id == currentId,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add vehicle'),
        onPressed: () => context.push(Routes.newVehicle),
      ),
    );
  }
}

class _VehicleCard extends ConsumerWidget {
  const _VehicleCard({required this.vehicle, required this.isCurrent});

  final Vehicle vehicle;
  final bool isCurrent;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await confirm(
      context,
      title: 'Delete ${vehicle.displayName}?',
      message:
          'All records, maintenance tasks, reminders and photos of this '
          'vehicle will be deleted. This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (ok) await ref.read(vehicleRepositoryProvider).delete(vehicle.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card.filled(
      color: isCurrent
          ? scheme.secondaryContainer
          : scheme.surfaceContainerHighest,
      child: InkWell(
        onTap: () {
          ref.read(selectedVehicleIdProvider.notifier).select(vehicle.id);
          context.pop();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              VehicleAvatar(photoFileName: vehicle.photoFileName, size: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.displayName,
                      style: theme.textTheme.titleMedium,
                    ),
                    if (vehicle.details.isNotEmpty)
                      Text(
                        vehicle.details,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      formatKm(vehicle.currentOdo),
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.check_circle, color: scheme.primary),
                ),
              PopupMenuButton<String>(
                onSelected: (action) => switch (action) {
                  'edit' => context.push(Routes.editVehicle(vehicle.id)),
                  'delete' => _delete(context, ref),
                  _ => null,
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

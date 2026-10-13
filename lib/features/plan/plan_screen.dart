import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import 'reminders_tab.dart';
import 'task_tile.dart';
import 'templates_sheet.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(currentVehicleProvider).value;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plan'),
          actions: [
            if (vehicle != null)
              IconButton(
                tooltip: 'Add from templates',
                icon: const Icon(Icons.playlist_add),
                onPressed: () => showTemplatesSheet(context, vehicle),
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Maintenance'),
              Tab(text: 'Reminders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            vehicle == null
                ? const PlaceholderView(
                    icon: Icons.build_circle_outlined,
                    title: 'No vehicle',
                    subtitle: 'Add a vehicle on the Home tab first',
                  )
                : _MaintenanceTab(vehicle: vehicle),
            RemindersTab(vehicle: vehicle),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceTab extends ConsumerWidget {
  const _MaintenanceTab({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = ref.watch(taskViewsProvider(vehicle.id));
    final completed = ref.watch(completedTasksProvider(vehicle.id)).value ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
        onPressed: () => context.push(Routes.newTask),
      ),
      body: views.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty && completed.isEmpty) {
            return PlaceholderView(
              icon: Icons.build_circle_outlined,
              title: 'No maintenance plan yet',
              subtitle:
                  'Add typical tasks like oil change or insurance, '
                  'or create your own',
              actions: [
                FilledButton.icon(
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Add from templates'),
                  onPressed: () => showTemplatesSheet(context, vehicle),
                ),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              for (final v in list) ...[
                TaskTile(view: v),
                const SizedBox(height: 8),
              ],
              if (completed.isNotEmpty) _CompletedTasks(tasks: completed),
            ],
          );
        },
      ),
    );
  }
}

/// Finished one-off tasks, collapsed by default; can be restored.
class _CompletedTasks extends ConsumerWidget {
  const _CompletedTasks({required this.tasks});

  final List<MaintenanceTask> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text('Completed (${tasks.length})'),
      children: [
        for (final t in tasks)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.task_alt),
            title: Text(t.title),
            subtitle: t.lastDoneDate == null
                ? null
                : Text(
                    [
                      formatDate(t.lastDoneDate!),
                      if (t.lastDoneOdo != null) formatKm(t.lastDoneOdo!),
                    ].join(' · '),
                  ),
            trailing: TextButton(
              onPressed: () =>
                  ref.read(taskRepositoryProvider).setActive(t.id, true),
              child: const Text('Restore'),
            ),
          ),
      ],
    );
  }
}

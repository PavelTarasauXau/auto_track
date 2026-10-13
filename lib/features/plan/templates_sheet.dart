import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/maintenance_templates.dart';
import '../../domain/task_view.dart';
import '../../providers.dart';

/// Lets the user add typical maintenance tasks in one go. Intervals start
/// from the current mileage and today; each task can be edited later.
Future<void> showTemplatesSheet(BuildContext context, Vehicle vehicle) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, controller) =>
          _TemplatesSheet(vehicle: vehicle, scrollController: controller),
    ),
  );
}

class _TemplatesSheet extends ConsumerStatefulWidget {
  const _TemplatesSheet({
    required this.vehicle,
    required this.scrollController,
  });

  final Vehicle vehicle;
  final ScrollController scrollController;

  @override
  ConsumerState<_TemplatesSheet> createState() => _TemplatesSheetState();
}

class _TemplatesSheetState extends ConsumerState<_TemplatesSheet> {
  late final Set<MaintenanceTemplate> _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Skip templates that are already in the plan.
    final existing = {
      for (final t
          in ref.read(activeTasksProvider(widget.vehicle.id)).value ?? [])
        t.title.toLowerCase(),
    };
    _selected = {
      for (final t in maintenanceTemplates)
        if (t.common && !existing.contains(t.title.toLowerCase())) t,
    };
  }

  Future<void> _add() async {
    setState(() => _saving = true);
    final repo = ref.read(taskRepositoryProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final t in maintenanceTemplates.where(_selected.contains)) {
      await repo.save(
        TaskDraft(
          vehicleId: widget.vehicle.id,
          title: t.title,
          intervalKm: t.intervalKm,
          intervalDays: t.intervalDays,
          lastDoneOdo: t.intervalKm == null ? null : widget.vehicle.currentOdo,
          lastDoneDate: t.intervalDays == null ? null : today,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Typical maintenance', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Intervals start from the current mileage and today. '
                'Edit a task later to set when it was really done.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            children: [
              for (final t in maintenanceTemplates)
                CheckboxListTile(
                  value: _selected.contains(t),
                  title: Text(t.title),
                  subtitle: Text(intervalLabel(t.intervalKm, t.intervalDays)),
                  onChanged: (v) => setState(
                    () => v == true ? _selected.add(t) : _selected.remove(t),
                  ),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selected.isEmpty || _saving ? null : _add,
                child: Text('Add ${_selected.length} tasks'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

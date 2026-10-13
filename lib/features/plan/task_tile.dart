import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../domain/task_schedule.dart';
import '../../domain/task_view.dart';
import '../../providers.dart';
import '../../widgets/confirm_dialog.dart';
import 'mark_done_dialog.dart';

/// Colors and labels of task urgency, shared by the plan and the dashboard.
extension UrgencyStyle on Urgency {
  String get label => switch (this) {
    Urgency.overdue => 'Overdue',
    Urgency.dueSoon => 'Due soon',
    Urgency.ok => 'OK',
    Urgency.unknown => 'No data',
  };

  Color color(ColorScheme scheme) => switch (this) {
    Urgency.overdue => scheme.error,
    Urgency.dueSoon => Colors.orange.shade700,
    Urgency.ok => Colors.green.shade600,
    Urgency.unknown => scheme.outline,
  };

  IconData get icon => switch (this) {
    Urgency.overdue => Icons.error,
    Urgency.dueSoon => Icons.schedule,
    Urgency.ok => Icons.check_circle,
    Urgency.unknown => Icons.help_outline,
  };
}

/// A maintenance task with status, remaining km/days and progress.
class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.view, this.compact = false});

  final TaskView view;

  /// Dashboard variant: no progress bar and no menu.
  final bool compact;

  Future<void> _onAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final task = view.task;
    switch (action) {
      case 'done':
        await showMarkDoneDialog(context, ref, task);
      case 'log':
        await context.push('${Routes.newRecord}?type=service&task=${task.id}');
      case 'edit':
        await context.push(Routes.editTask(task.id));
      case 'delete':
        final ok = await confirm(
          context,
          title: 'Delete "${task.title}"?',
          message: 'The task is removed from the plan. Records stay.',
          confirmLabel: 'Delete',
          destructive: true,
        );
        if (ok) await ref.read(taskRepositoryProvider).delete(task.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final task = view.task;
    final color = view.urgency.color(scheme);
    final progress = view.status.progress;
    final predicted = view.predicted;

    final details = [
      intervalLabel(task.intervalKm, task.intervalDays),
      if (task.lastDoneDate != null) 'last ${formatDate(task.lastDoneDate!)}',
    ].join(' · ');

    return Card.outlined(
      child: InkWell(
        onTap: () => context.push(Routes.editTask(task.id)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, compact ? 16 : 4, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(view.urgency.icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title, style: theme.textTheme.titleMedium),
                        Text(
                          view.remainingLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (predicted != null && !compact)
                          Text(
                            '≈ ${formatDate(predicted)} at your usual mileage',
                            style: theme.textTheme.bodySmall,
                          ),
                        if (!compact)
                          Text(
                            details,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!compact)
                    PopupMenuButton<String>(
                      tooltip: 'Task actions',
                      onSelected: (a) => _onAction(context, ref, a),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'done', child: Text('Mark done')),
                        PopupMenuItem(value: 'log', child: Text('Log service')),
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                ],
              ),
              if (progress != null && !compact)
                Padding(
                  padding: const EdgeInsets.fromLTRB(34, 8, 12, 0),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1).toDouble(),
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

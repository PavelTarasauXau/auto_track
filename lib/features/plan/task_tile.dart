import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme.dart';
import '../../domain/task_schedule.dart';
import '../../domain/task_view.dart';
import '../../providers.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/ui.dart';
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
    Urgency.overdue => AppColors.overdue,
    Urgency.dueSoon => AppColors.soon,
    Urgency.ok => AppColors.ok,
    Urgency.unknown => AppColors.textMuted,
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
    final task = view.task;
    final color = view.urgency.color(theme.colorScheme);
    final progress = view.status.progress;
    final predicted = view.predicted;

    final details = [
      intervalLabel(task.intervalKm, task.intervalDays),
      if (task.lastDoneDate != null) 'last ${formatDate(task.lastDoneDate!)}',
    ].join(' · ');

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: view.urgency == Urgency.ok || view.urgency == Urgency.unknown
              ? AppColors.outline
              : color.withValues(alpha: 0.45),
        ),
      ),
      child: InkWell(
        onTap: () => context.push(Routes.editTask(task.id)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14, 14, compact ? 16 : 4, 14),
          child: Row(
            children: [
              // Share of the interval used, in the status color.
              ProgressRing(
                value: progress ?? (view.urgency == Urgency.overdue ? 1 : 0),
                size: 52,
                stroke: 5,
                color: color,
                child: progress == null
                    ? Icon(view.urgency.icon, color: color, size: 20)
                    : Text(
                        '${(progress.clamp(0, 1) * 100).round()}%',
                        style: TextStyle(
                          fontFamily: displayFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: color,
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      view.remainingLabel,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
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
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              if (compact)
                const Icon(Icons.chevron_right, color: AppColors.textMuted)
              else
                PopupMenuButton<String>(
                  tooltip: 'Task actions',
                  icon: const Icon(Icons.more_vert, color: AppColors.textMuted),
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
        ),
      ),
    );
  }
}

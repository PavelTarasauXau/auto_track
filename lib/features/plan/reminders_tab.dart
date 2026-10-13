import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../data/db/database.dart';
import '../../domain/notification_planner.dart';
import '../../notifications.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import 'reminder_sheet.dart';

/// Reminders of the current vehicle plus general ones.
final remindersProvider = StreamProvider.family<List<Reminder>, int?>(
  (ref, vehicleId) =>
      ref.watch(reminderRepositoryProvider).watchForVehicle(vehicleId),
);

class RemindersTab extends ConsumerWidget {
  const RemindersTab({super.key, this.vehicle});

  final Vehicle? vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersProvider(vehicle?.id));
    final now = DateTime.now();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_alert_outlined),
        label: const Text('Add reminder'),
        onPressed: () => showReminderSheet(context, vehicle: vehicle),
      ),
      body: reminders.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          final upcoming = list.where((r) => !r.isDone).toList()
            ..sort((a, b) => _sortKey(a, now).compareTo(_sortKey(b, now)));
          final done = list.where((r) => r.isDone).toList();

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              const _PermissionBanner(),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: PlaceholderView(
                    icon: Icons.notifications_outlined,
                    title: 'No reminders',
                    subtitle:
                        'Get a notification at a set time, e.g. '
                        '"Refuel tomorrow at 16:00"',
                  ),
                ),
              for (final r in upcoming)
                _ReminderTile(reminder: r, vehicle: vehicle, now: now),
              if (done.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text('Done'),
                ),
                for (final r in done)
                  _ReminderTile(reminder: r, vehicle: vehicle, now: now),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Upcoming first by their next time; missed one-time reminders last.
  static DateTime _sortKey(Reminder r, DateTime now) =>
      nextOccurrence(r.remindAt, r.repeat, now) ?? DateTime(9999);
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({
    required this.reminder,
    required this.vehicle,
    required this.now,
  });

  final Reminder reminder;
  final Vehicle? vehicle;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final next = reminder.isDone
        ? reminder.remindAt
        : nextOccurrence(reminder.remindAt, reminder.repeat, now);
    final missed = next == null;
    final subtitle = [
      formatWhen(next ?? reminder.remindAt, now),
      if (missed) 'missed',
      if (reminder.repeat != RepeatRule.none) reminder.repeat.label,
      if (reminder.vehicleId == null) 'all vehicles',
    ].join(' · ');

    return ListTile(
      leading: Checkbox(
        value: reminder.isDone,
        onChanged: (v) => ref
            .read(reminderRepositoryProvider)
            .setDone(reminder.id, v ?? false),
      ),
      title: Text(
        reminder.title,
        style: reminder.isDone
            ? const TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      subtitle: Text(
        subtitle,
        style: missed && !reminder.isDone
            ? TextStyle(color: theme.colorScheme.error)
            : null,
      ),
      trailing: reminder.repeat == RepeatRule.none
          ? null
          : const Icon(Icons.repeat, size: 20),
      onTap: () =>
          showReminderSheet(context, vehicle: vehicle, reminder: reminder),
    );
  }
}

/// Shown when notifications are disabled for the app.
class _PermissionBanner extends ConsumerStatefulWidget {
  const _PermissionBanner();

  @override
  ConsumerState<_PermissionBanner> createState() => _PermissionBannerState();
}

class _PermissionBannerState extends ConsumerState<_PermissionBanner> {
  bool? _enabled;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final enabled = await ref
        .read(notificationControllerProvider)
        .notificationsEnabled();
    if (mounted) setState(() => _enabled = enabled);
  }

  Future<void> _enable() async {
    await ref
        .read(notificationControllerProvider)
        .requestPermissions(exactAlarms: true);
    await _check();
  }

  @override
  Widget build(BuildContext context) {
    if (_enabled ?? true) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Card.filled(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      color: scheme.errorContainer,
      child: ListTile(
        leading: Icon(
          Icons.notifications_off_outlined,
          color: scheme.onErrorContainer,
        ),
        title: Text(
          'Notifications are off',
          style: TextStyle(color: scheme.onErrorContainer),
        ),
        subtitle: Text(
          'Reminders and maintenance alerts will not be shown',
          style: TextStyle(color: scheme.onErrorContainer),
        ),
        trailing: TextButton(onPressed: _enable, child: const Text('Enable')),
      ),
    );
  }
}

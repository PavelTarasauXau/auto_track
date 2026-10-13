import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../notifications.dart';
import '../../providers.dart';
import '../garage/vehicle_text.dart';

/// `Today, 16:00`, `Tomorrow, 09:00`, `14 Nov 2026, 09:00`.
String formatWhen(DateTime at, DateTime now) {
  final day = DateTime(at.year, at.month, at.day);
  final today = DateTime(now.year, now.month, now.day);
  final time =
      '${at.hour.toString().padLeft(2, '0')}:'
      '${at.minute.toString().padLeft(2, '0')}';
  final diff = (day.difference(today).inHours / 24).round();
  return switch (diff) {
    0 => 'Today, $time',
    1 => 'Tomorrow, $time',
    -1 => 'Yesterday, $time',
    _ => formatDateTime(at),
  };
}

/// Creates or edits a reminder; [vehicle] is the current vehicle (the
/// reminder can be linked to it or be general).
Future<void> showReminderSheet(
  BuildContext context, {
  Vehicle? vehicle,
  Reminder? reminder,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReminderSheet(vehicle: vehicle, reminder: reminder),
  );
}

class _ReminderSheet extends ConsumerStatefulWidget {
  const _ReminderSheet({this.vehicle, this.reminder});

  final Vehicle? vehicle;
  final Reminder? reminder;

  @override
  ConsumerState<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends ConsumerState<_ReminderSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.reminder?.title);
  late final _note = TextEditingController(text: widget.reminder?.note);
  late DateTime _at = widget.reminder?.remindAt ?? _tomorrowAt(9);
  late RepeatRule _repeat = widget.reminder?.repeat ?? RepeatRule.none;
  late bool _forVehicle = widget.reminder == null
      ? widget.vehicle != null
      : widget.reminder!.vehicleId != null;
  String? _timeError;
  bool _saving = false;

  bool get _isNew => widget.reminder == null;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  static DateTime _tomorrowAt(int hour) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, hour);
  }

  void _setAt(DateTime at) => setState(() {
    _at = at;
    _timeError = null;
  });

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _at.isBefore(now) ? now : _at,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      _setAt(
        DateTime(picked.year, picked.month, picked.day, _at.hour, _at.minute),
      );
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_at),
    );
    if (picked != null) {
      _setAt(
        DateTime(_at.year, _at.month, _at.day, picked.hour, picked.minute),
      );
    }
  }

  Future<void> _save() async {
    final validForm = _formKey.currentState!.validate();
    final inPast = _repeat == RepeatRule.none && !_at.isAfter(DateTime.now());
    setState(() => _timeError = inPast ? 'Pick a time in the future' : null);
    if (!validForm || inPast) return;

    setState(() => _saving = true);
    final note = _note.text.trim();
    await ref
        .read(reminderRepositoryProvider)
        .save(
          id: widget.reminder?.id,
          vehicleId: _forVehicle
              ? (widget.reminder?.vehicleId ?? widget.vehicle?.id)
              : null,
          title: _title.text,
          note: note.isEmpty ? null : note,
          remindAt: _at,
          repeat: _repeat,
        );
    // Reminders are about exact times, so ask for exact alarms as well.
    await ref.read(notificationControllerProvider).ensureReminderPermissions();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await ref.read(reminderRepositoryProvider).delete(widget.reminder!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final vehicle = widget.vehicle;
    final presets = <String, DateTime>{
      'In 1 hour': DateTime(
        now.year,
        now.month,
        now.day,
        now.hour + 1,
        now.minute,
      ),
      'Tomorrow 9:00': _tomorrowAt(9),
      'Tomorrow 18:00': _tomorrowAt(18),
      'In a week': DateTime(now.year, now.month, now.day + 7, 9),
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Actions at the top stay visible above the keyboard.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isNew ? 'New reminder' : 'Edit reminder',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  if (!_isNew)
                    IconButton(
                      tooltip: 'Delete',
                      color: theme.colorScheme.error,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _delete,
                    ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _title,
                autofocus: _isNew,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Remind me to *',
                  hintText: 'e.g. Refuel before the trip',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final MapEntry(key: label, value: at) in presets.entries)
                    ActionChip(label: Text(label), onPressed: () => _setAt(at)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          errorText: _timeError,
                        ),
                        child: Text(formatDate(_at)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _pickTime,
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Time'),
                        child: Text(
                          TimeOfDay.fromDateTime(_at).format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RepeatRule>(
                initialValue: _repeat,
                decoration: const InputDecoration(labelText: 'Repeat'),
                items: [
                  for (final r in RepeatRule.values)
                    DropdownMenuItem(value: r, child: Text(r.label)),
                ],
                onChanged: (r) => setState(() {
                  _repeat = r ?? RepeatRule.none;
                  _timeError = null;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _note,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              if (vehicle != null)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Only for ${vehicle.displayName}'),
                  subtitle: const Text('Otherwise shown for every vehicle'),
                  value: _forVehicle,
                  onChanged: (v) => setState(() => _forVehicle = v),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

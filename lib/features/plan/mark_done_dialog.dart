import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../providers.dart';

/// Marks a task as done without creating a record: asks for the mileage and
/// date, reschedules the task and raises the odometer if needed.
Future<void> showMarkDoneDialog(
  BuildContext context,
  WidgetRef ref,
  MaintenanceTask task,
) async {
  final vehicle = await ref
      .read(vehicleRepositoryProvider)
      .getById(task.vehicleId);
  if (vehicle == null || !context.mounted) return;

  final result = await showDialog<(int, DateTime)>(
    context: context,
    builder: (_) => _MarkDoneDialog(task: task, currentOdo: vehicle.currentOdo),
  );
  if (result == null) return;

  final (odo, date) = result;
  await ref
      .read(recordRepositoryProvider)
      .completeTask(task.id, odo: odo, date: date);
  if (odo > vehicle.currentOdo) {
    await ref
        .read(vehicleRepositoryProvider)
        .updateOdometer(vehicle.id, odo, date: date);
  }
}

class _MarkDoneDialog extends StatefulWidget {
  const _MarkDoneDialog({required this.task, required this.currentOdo});

  final MaintenanceTask task;
  final int currentOdo;

  @override
  State<_MarkDoneDialog> createState() => _MarkDoneDialogState();
}

class _MarkDoneDialogState extends State<_MarkDoneDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _odometer = TextEditingController(text: '${widget.currentOdo}');
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _odometer.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final d = DateTime(_date.year, _date.month, _date.day);
      Navigator.pop(context, (parseInt(_odometer.text)!, d));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mark "${widget.task.title}" done'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _odometer,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Mileage',
                suffixText: 'km',
              ),
              validator: (v) => parseInt(v ?? '') == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today, size: 20),
                ),
                child: Text(formatDate(_date)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Done')),
      ],
    );
  }
}

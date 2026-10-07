import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../widgets/confirm_dialog.dart';

/// Asks for a new odometer reading and saves it.
Future<void> showOdometerDialog(
  BuildContext context,
  WidgetRef ref,
  Vehicle vehicle,
) async {
  final value = await showDialog<int>(
    context: context,
    builder: (_) => _OdometerDialog(current: vehicle.currentOdo),
  );
  if (value == null || value == vehicle.currentOdo || !context.mounted) return;

  if (value < vehicle.currentOdo) {
    final ok = await confirm(
      context,
      title: 'Lower reading',
      message:
          'The new reading (${formatKm(value)}) is lower than the current one '
          '(${formatKm(vehicle.currentOdo)}). Save it anyway?',
      confirmLabel: 'Save',
    );
    if (!ok) return;
  }
  await ref.read(vehicleRepositoryProvider).updateOdometer(vehicle.id, value);
}

class _OdometerDialog extends StatefulWidget {
  const _OdometerDialog({required this.current});

  final int current;

  @override
  State<_OdometerDialog> createState() => _OdometerDialogState();
}

class _OdometerDialogState extends State<_OdometerDialog> {
  late final _controller = TextEditingController(text: '${widget.current}');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, parseInt(_controller.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update odometer'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Current mileage',
            suffixText: 'km',
          ),
          validator: (v) =>
              parseInt(v ?? '') == null ? 'Enter the mileage' : null,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}

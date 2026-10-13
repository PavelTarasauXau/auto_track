import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/task_schedule.dart';
import '../../providers.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/placeholder_view.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.taskId});

  /// `null` when creating a new task.
  final int? taskId;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _note = TextEditingController();
  final _intervalKm = TextEditingController();
  final _intervalMonths = TextEditingController();
  final _intervalDays = TextEditingController();
  final _lastDoneOdo = TextEditingController();
  final _dueOdo = TextEditingController();
  final _remindKm = TextEditingController(text: '500');
  final _remindDays = TextEditingController(text: '14');

  bool _recurring = true;

  /// Intervals that are not whole months (e.g. 45 days) are edited in days.
  bool _intervalInDays = false;
  DateTime? _lastDoneDate;
  DateTime? _dueDate;

  MaintenanceTask? _existing;
  int? _vehicleId;
  bool _loading = true;
  bool _saving = false;

  bool get _isNew => widget.taskId == null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.taskId;
    if (id == null) {
      await ref.read(vehiclesProvider.future);
      final vehicle = ref.read(currentVehicleProvider).value;
      _vehicleId = vehicle?.id;
      // A new recurring task counts from now by default.
      if (vehicle != null) _lastDoneOdo.text = '${vehicle.currentOdo}';
      _lastDoneDate = dateOnly(DateTime.now());
    } else {
      final t = await ref.read(taskRepositoryProvider).getById(id);
      if (t != null) _fill(t);
    }
    if (mounted) setState(() => _loading = false);
  }

  void _fill(MaintenanceTask t) {
    _existing = t;
    _vehicleId = t.vehicleId;
    _title.text = t.title;
    _note.text = t.note ?? '';
    _recurring = t.intervalKm != null || t.intervalDays != null;
    _intervalKm.text = t.intervalKm?.toString() ?? '';
    if (t.intervalDays case final days?) {
      final months = daysToMonths(days);
      _intervalInDays = months == null;
      _intervalMonths.text = months?.toString() ?? '';
      _intervalDays.text = months == null ? '$days' : '';
    }
    _lastDoneOdo.text = t.lastDoneOdo?.toString() ?? '';
    _lastDoneDate = t.lastDoneDate;
    _dueOdo.text = t.dueOdo?.toString() ?? '';
    _dueDate = t.dueDate;
    _remindKm.text = '${t.remindBeforeKm}';
    _remindDays.text = '${t.remindBeforeDays}';
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _note,
      _intervalKm,
      _intervalMonths,
      _intervalDays,
      _lastDoneOdo,
      _dueOdo,
      _remindKm,
      _remindDays,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  int? get _intervalDaysValue {
    if (_intervalInDays) return parseInt(_intervalDays.text);
    final months = parseInt(_intervalMonths.text);
    return months == null ? null : monthsToDays(months);
  }

  Future<DateTime?> _pickDate(DateTime? initial, {bool future = false}) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(1990),
      lastDate: future ? DateTime(now.year + 20) : now,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    // The date is not a form field; its error is shown by _dateField.
    if (_recurring && _intervalDaysValue != null && _lastDoneDate == null) {
      return;
    }
    setState(() => _saving = true);

    final intervalKm = _recurring ? parseInt(_intervalKm.text) : null;
    final intervalDays = _recurring ? _intervalDaysValue : null;
    final note = _note.text.trim();

    await ref
        .read(taskRepositoryProvider)
        .save(
          TaskDraft(
            id: widget.taskId,
            vehicleId: _vehicleId!,
            title: _title.text,
            intervalKm: intervalKm,
            intervalDays: intervalDays,
            lastDoneOdo: _recurring && intervalKm != null
                ? parseInt(_lastDoneOdo.text)
                : _existing?.lastDoneOdo,
            lastDoneDate: _recurring && intervalDays != null
                ? _lastDoneDate
                : _existing?.lastDoneDate,
            fixedDueOdo: _recurring ? null : parseInt(_dueOdo.text),
            fixedDueDate: _recurring ? null : _dueDate,
            remindBeforeKm: parseInt(_remindKm.text) ?? 500,
            remindBeforeDays: parseInt(_remindDays.text) ?? 14,
            note: note.isEmpty ? null : note,
          ),
        );
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final ok = await confirm(
      context,
      title: 'Delete task?',
      message: 'The task is removed from the plan. Records stay.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    await ref.read(taskRepositoryProvider).delete(widget.taskId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_vehicleId == null) {
      body = const PlaceholderView(
        icon: Icons.directions_car,
        title: 'No vehicle',
        subtitle: 'Add a vehicle in the garage first',
      );
    } else {
      body = Form(key: _formKey, child: _fields(context));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New task' : 'Edit task'),
        actions: [
          if (!_isNew && !_loading)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(
            onPressed: _loading || _saving || _vehicleId == null ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _fields(BuildContext context) {
    const gap = SizedBox(height: 16);
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        TextFormField(
          controller: _title,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Task *',
            hintText: 'e.g. Engine oil & filter',
          ),
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
        gap,
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              icon: Icon(Icons.repeat),
              label: Text('Recurring'),
            ),
            ButtonSegment(
              value: false,
              icon: Icon(Icons.looks_one_outlined),
              label: Text('One-time'),
            ),
          ],
          selected: {_recurring},
          onSelectionChanged: (s) => setState(() => _recurring = s.first),
        ),
        const SizedBox(height: 24),
        if (_recurring) ..._recurringFields(textTheme) else ..._oneTimeFields(),
        const SizedBox(height: 24),
        Text('Remind me before', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _numberField(_remindKm, 'Kilometers', suffix: 'km'),
            ),
            const SizedBox(width: 16),
            Expanded(child: _numberField(_remindDays, 'Days', suffix: 'days')),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _note,
          textCapitalization: TextCapitalization.sentences,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Note',
            hintText: 'e.g. 5W-30, 4.2 L',
          ),
        ),
      ],
    );
  }

  List<Widget> _recurringFields(TextTheme textTheme) {
    final hasKm = parseInt(_intervalKm.text) != null;
    final hasDays = _intervalDaysValue != null;
    return [
      Text('Repeat every', style: textTheme.titleMedium),
      const SizedBox(height: 4),
      Text(
        'Whichever comes first. Fill in one or both.',
        style: textTheme.bodySmall,
      ),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _numberField(
              _intervalKm,
              'Kilometers',
              suffix: 'km',
              validator: (_) => hasKm || hasDays ? null : 'Set an interval',
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _intervalInDays
                ? _numberField(
                    _intervalDays,
                    'Days',
                    suffix: 'days',
                    onChanged: (_) => setState(() {}),
                  )
                : _numberField(
                    _intervalMonths,
                    'Months',
                    suffix: 'mo',
                    onChanged: (_) => setState(() {}),
                  ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      Text('Last done', style: textTheme.titleMedium),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _numberField(
              _lastDoneOdo,
              'Mileage',
              suffix: 'km',
              validator: (v) => hasKm && parseInt(v ?? '') == null
                  ? 'Required for km interval'
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _dateField(
              label: 'Date',
              value: _lastDoneDate,
              error: hasDays && _lastDoneDate == null
                  ? 'Required for time interval'
                  : null,
              onTap: () async {
                final d = await _pickDate(_lastDoneDate);
                if (d != null) setState(() => _lastDoneDate = d);
              },
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _oneTimeFields() {
    final hasOdo = parseInt(_dueOdo.text) != null;
    return [
      Text('Due', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 12),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _numberField(
              _dueOdo,
              'At mileage',
              suffix: 'km',
              validator: (_) =>
                  hasOdo || _dueDate != null ? null : 'Set mileage or date',
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _dateField(
              label: 'By date',
              value: _dueDate,
              onTap: () async {
                final d = await _pickDate(_dueDate, future: true);
                if (d != null) setState(() => _dueDate = d);
              },
              onClear: _dueDate == null
                  ? null
                  : () => setState(() => _dueDate = null),
            ),
          ),
        ],
      ),
    ];
  }

  Widget _numberField(
    TextEditingController controller,
    String label, {
    String? suffix,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(labelText: label, suffixText: suffix),
    validator: validator,
    onChanged: onChanged,
  );

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    VoidCallback? onClear,
    String? error,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(4),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        errorText: error,
        suffixIcon: onClear == null
            ? const Icon(Icons.calendar_today, size: 20)
            : IconButton(
                tooltip: 'Clear date',
                icon: const Icon(Icons.close, size: 20),
                onPressed: onClear,
              ),
      ),
      child: Text(value == null ? '—' : formatDate(value)),
    ),
  );
}

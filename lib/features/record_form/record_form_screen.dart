import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../data/repositories/record_models.dart';
import '../../providers.dart';
import '../../services/file_storage.dart';
import '../../services/photo_picker.dart';
import '../../widgets/attachment_thumb.dart';
import '../../widgets/placeholder_view.dart';
import '../photo_viewer/photo_viewer_screen.dart';
import 'item_sheet.dart';
import 'photo_sheet.dart';

class RecordFormScreen extends ConsumerStatefulWidget {
  const RecordFormScreen({
    super.key,
    this.recordId,
    this.initialType,
    this.initialTaskId,
  });

  /// `null` when creating a new record.
  final int? recordId;

  /// Preselected record type for a new record, e.g. `fuel`.
  final String? initialType;

  /// Maintenance task to mark as completed by a new record ("Log service").
  final int? initialTaskId;

  @override
  ConsumerState<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends ConsumerState<RecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _odometer = TextEditingController();
  final _cost = TextEditingController();
  final _station = TextEditingController();
  final _note = TextEditingController();
  final _liters = TextEditingController();
  final _price = TextEditingController();

  RecordType _type = RecordType.service;
  DateTime _date = _today();
  bool _fullTank = true;
  final List<ItemDraft> _items = [];
  final Set<int> _completedTaskIds = {};

  /// Tasks already linked to the edited record. They may be inactive now
  /// (completed one-off tasks), so they are not in the active list.
  List<MaintenanceTask> _linkedTasks = [];

  List<AttachmentDraft> _attachments = [];

  /// Photos imported while the form is open. They are deleted again if the
  /// form is left without saving, so no orphan files stay on disk.
  final Set<String> _sessionFiles = {};
  bool _saved = false;

  /// Photos still being compressed.
  int _importing = 0;

  // Read once: `ref` cannot be used in dispose().
  late final FileStorage _storage;

  int? _vehicleId;
  bool _loading = true;
  bool _saving = false;

  /// The total was typed by hand, so it is not recalculated from fuel data.
  bool _costEdited = false;

  bool get _isNew => widget.recordId == null;
  bool get _isFuel => _type == RecordType.fuel;
  bool get _hasItems => _type != RecordType.fuel && _type != RecordType.wash;

  @override
  void initState() {
    super.initState();
    _storage = ref.read(fileStorageProvider);
    _liters.addListener(_recalculateFuelCost);
    _price.addListener(_recalculateFuelCost);
    _load();
  }

  Future<void> _load() async {
    final id = widget.recordId;
    if (id == null) {
      await ref.read(vehiclesProvider.future);
      final vehicle = ref.read(currentVehicleProvider).value;
      _vehicleId = vehicle?.id;
      if (vehicle != null) _odometer.text = '${vehicle.currentOdo}';
      _type = RecordType.values.asNameMap()[widget.initialType] ?? _type;
      if (widget.initialTaskId case final taskId?) {
        final task = await ref.read(taskRepositoryProvider).getById(taskId);
        if (task != null) {
          _completedTaskIds.add(task.id);
          _title.text = task.title;
        }
      }
    } else {
      final details = await ref.read(recordRepositoryProvider).getDetails(id);
      if (details != null) _fill(details);
    }
    if (mounted) setState(() => _loading = false);
  }

  void _fill(RecordDetails d) {
    final r = d.record;
    _vehicleId = r.vehicleId;
    _type = r.type;
    _date = r.date;
    _title.text = r.title;
    _odometer.text = '${r.odometer}';
    _cost.text = decimalToInput(r.cost);
    _costEdited = true;
    _station.text = r.station ?? '';
    _note.text = r.note ?? '';
    if (d.fuel case final fuel?) {
      _liters.text = decimalToInput(fuel.liters);
      _price.text = decimalToInput(fuel.pricePerLiter);
      _fullTank = fuel.fullTank;
    }
    _items.addAll(
      d.items.map(
        (i) => ItemDraft(
          kind: i.kind,
          name: i.name,
          partNumber: i.partNumber,
          cost: i.cost,
        ),
      ),
    );
    _linkedTasks = d.completedTasks;
    _completedTaskIds.addAll(d.completedTasks.map((t) => t.id));
    _attachments = [
      for (final a in d.attachments)
        AttachmentDraft(
          id: a.id,
          fileName: a.fileName,
          docType: a.docType,
          caption: a.caption,
        ),
    ];
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _odometer,
      _cost,
      _station,
      _note,
      _liters,
      _price,
    ]) {
      c.dispose();
    }
    if (!_saved) _storage.deleteAll(_sessionFiles);
    super.dispose();
  }

  void _recalculateFuelCost() {
    if (!_isFuel || _costEdited) return;
    final liters = parseDecimal(_liters.text);
    final price = parseDecimal(_price.text);
    if (liters != null && price != null) {
      _cost.text = (liters * price).toStringAsFixed(2);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: _today(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _editItem([int? index]) async {
    final result = await showItemSheet(
      context,
      item: index == null ? null : _items[index],
    );
    if (result == null) return;
    setState(() {
      if (index == null) {
        _items.add(result);
      } else {
        _items[index] = result;
      }
    });
  }

  Future<void> _addPhotos() async {
    final source = await askPhotoSource(context);
    if (source == null) return;
    final paths = await ref.read(photoPickerProvider).pick(source);
    if (paths.isEmpty || !mounted) return;

    final import = ref.read(photoImporterProvider);
    setState(() => _importing += paths.length);
    for (final path in paths) {
      try {
        final name = await import(path);
        _sessionFiles.add(name);
        if (!mounted) return;
        setState(() => _attachments.add(AttachmentDraft(fileName: name)));
      } finally {
        if (mounted) setState(() => _importing--);
      }
    }
  }

  Future<void> _editPhoto(int index) async {
    final photo = _attachments[index];
    final result = await showPhotoSheet(context, photo);
    if (result == null || !mounted) return;

    switch (result) {
      case PhotoSheetOpen():
        await openPhotoViewer(context, _viewerPhotos, initialIndex: index);
      case PhotoSheetRemove():
        setState(() => _attachments.removeAt(index));
        // Unsaved photos are deleted right away; saved ones when the record
        // is saved (the repository removes files of dropped attachments).
        if (_sessionFiles.remove(photo.fileName)) {
          await _storage.delete(photo.fileName);
        }
      case PhotoSheetUpdate(:final docType, :final caption):
        setState(
          () => _attachments[index] = AttachmentDraft(
            id: photo.id,
            fileName: photo.fileName,
            docType: docType,
            caption: caption,
          ),
        );
    }
  }

  List<ViewerPhoto> get _viewerPhotos => [
    for (final a in _attachments)
      ViewerPhoto(fileName: a.fileName, docType: a.docType, caption: a.caption),
  ];

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    var cost = parseDecimal(_cost.text);
    FuelDraft? fuel;
    if (_isFuel) {
      final liters = parseDecimal(_liters.text)!;
      // Any two of liters / price / total are enough.
      final price = parseDecimal(_price.text) ?? cost! / liters;
      cost ??= liters * price;
      fuel = FuelDraft(
        liters: liters,
        pricePerLiter: price,
        fullTank: _fullTank,
      );
    }

    final items = _hasItems ? _items : const <ItemDraft>[];
    final itemsTotal = items.fold<double>(0, (sum, i) => sum + (i.cost ?? 0));
    if (cost == null && itemsTotal > 0) cost = itemsTotal;

    final title = _title.text.trim();
    await ref
        .read(recordRepositoryProvider)
        .save(
          RecordDraft(
            id: widget.recordId,
            vehicleId: _vehicleId!,
            type: _type,
            date: _date,
            odometer: parseInt(_odometer.text)!,
            title: title.isEmpty ? _type.label : title,
            station: _station.text,
            cost: cost,
            note: _note.text,
            fuel: fuel,
            items: items,
            attachments: _attachments,
            completedTaskIds: _isFuel ? const {} : _completedTaskIds,
          ),
        );

    _saved = true;
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
        title: Text(_isNew ? 'New record' : 'Edit record'),
        actions: [
          TextButton(
            onPressed:
                _loading || _saving || _importing > 0 || _vehicleId == null
                ? null
                : _save,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final type in RecordType.values)
              ChoiceChip(
                avatar: Icon(type.icon, size: 18),
                label: Text(type.label),
                selected: _type == type,
                showCheckmark: false,
                onSelected: (_) => setState(() => _type = type),
              ),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _title,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Title',
            hintText: _type.label,
          ),
        ),
        gap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today, size: 20),
                  ),
                  child: Text(formatDate(_date)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _odometer,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Mileage *',
                  suffixText: 'km',
                ),
                validator: (v) => parseInt(v ?? '') == null ? 'Required' : null,
              ),
            ),
          ],
        ),
        if (_isFuel) ...[gap, ..._fuelFields()],
        gap,
        TextFormField(
          controller: _cost,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Total cost',
            helperText: _isFuel
                ? 'Calculated from liters and price'
                : _hasItems
                ? 'Leave empty to sum up the items'
                : null,
          ),
          onChanged: (_) => _costEdited = true,
          validator: _optionalDecimal,
        ),
        gap,
        TextFormField(
          controller: _station,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: switch (_type) {
              RecordType.fuel => 'Gas station',
              RecordType.wash => 'Car wash',
              RecordType.parts => 'Shop',
              _ => 'Service station',
            },
          ),
        ),
        if (_hasItems) ...[const SizedBox(height: 24), ..._itemsSection()],
        if (!_isFuel) ..._tasksSection(textTheme),
        const SizedBox(height: 24),
        ..._photosSection(textTheme),
        const SizedBox(height: 24),
        TextFormField(
          controller: _note,
          textCapitalization: TextCapitalization.sentences,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Note'),
        ),
      ],
    );
  }

  List<Widget> _photosSection(TextTheme textTheme) {
    final scheme = Theme.of(context).colorScheme;
    const size = 88.0;
    return [
      Text('Receipts & photos', style: textTheme.titleMedium),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final (i, a) in _attachments.indexed)
            AttachmentThumb(
              fileName: a.fileName,
              docType: a.docType,
              size: size,
              onTap: () => _editPhoto(i),
            ),
          for (var i = 0; i < _importing; i++)
            SizedBox.square(
              dimension: size,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          SizedBox.square(
            dimension: size,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _addPhotos,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_a_photo_outlined),
                  SizedBox(height: 4),
                  Text('Add photo', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _fuelFields() => [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _liters,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Liters *',
              suffixText: 'L',
            ),
            validator: (v) {
              final liters = parseDecimal(v ?? '');
              return liters == null || liters <= 0 ? 'Required' : null;
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Price per liter'),
            validator: (v) {
              if (v != null && v.trim().isNotEmpty) {
                return parseDecimal(v) == null ? 'Enter a number' : null;
              }
              return parseDecimal(_cost.text) == null
                  ? 'Enter price or total'
                  : null;
            },
          ),
        ),
      ],
    ),
    SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Full tank'),
      subtitle: const Text('Needed to calculate fuel consumption'),
      value: _fullTank,
      onChanged: (v) => setState(() => _fullTank = v),
    ),
  ];

  List<Widget> _itemsSection() {
    final total = _items.fold<double>(0, (sum, i) => sum + (i.cost ?? 0));
    return [
      Row(
        children: [
          Expanded(
            child: Text(
              'Works & parts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (total > 0) Text(formatMoney(total)),
        ],
      ),
      for (final (i, item) in _items.indexed)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            item.kind == ItemKind.work
                ? Icons.handyman_outlined
                : Icons.settings_outlined,
          ),
          title: Text(item.name),
          subtitle: item.partNumber == null ? null : Text(item.partNumber!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.cost != null) Text(formatMoney(item.cost!)),
              IconButton(
                tooltip: 'Remove',
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _items.removeAt(i)),
              ),
            ],
          ),
          onTap: () => _editItem(i),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add work or part'),
          onPressed: _editItem,
        ),
      ),
    ];
  }

  List<Widget> _tasksSection(TextTheme textTheme) {
    final active = ref.watch(activeTasksProvider(_vehicleId!)).value ?? [];
    final tasks = {
      for (final t in [..._linkedTasks, ...active]) t.id: t,
    }.values.toList();
    if (tasks.isEmpty) return const [];

    return [
      const SizedBox(height: 24),
      Text('Completed maintenance', style: textTheme.titleMedium),
      const SizedBox(height: 4),
      Text(
        'Checked tasks will be rescheduled from this record',
        style: textTheme.bodySmall,
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final task in tasks)
            FilterChip(
              label: Text(task.title),
              selected: _completedTaskIds.contains(task.id),
              onSelected: (selected) => setState(() {
                selected
                    ? _completedTaskIds.add(task.id)
                    : _completedTaskIds.remove(task.id);
              }),
            ),
        ],
      ),
    ];
  }
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String? _optionalDecimal(String? v) =>
    v == null || v.trim().isEmpty || parseDecimal(v) != null
    ? null
    : 'Enter a number';

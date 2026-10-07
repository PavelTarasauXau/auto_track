import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../widgets/vehicle_avatar.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.vehicleId});

  /// `null` when creating a new vehicle.
  final int? vehicleId;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _year = TextEditingController();
  final _plate = TextEditingController();
  final _vin = TextEditingController();
  final _odometer = TextEditingController();

  Vehicle? _existing;
  bool _loading = true;
  bool _saving = false;

  /// Photo picked in this session, not yet copied to storage.
  String? _pickedPhotoPath;

  /// The user removed the existing photo.
  bool _photoRemoved = false;

  bool get _isNew => widget.vehicleId == null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.vehicleId;
    if (id != null) {
      final v = await ref.read(vehicleRepositoryProvider).getById(id);
      if (v != null) {
        _existing = v;
        _brand.text = v.brand;
        _model.text = v.model;
        _year.text = v.year?.toString() ?? '';
        _plate.text = v.plate ?? '';
        _vin.text = v.vin ?? '';
        _odometer.text = '${v.currentOdo}';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    for (final c in [_brand, _model, _year, _plate, _vin, _odometer]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final hasPhoto =
        _pickedPhotoPath != null ||
        (_existing?.photoFileName != null && !_photoRemoved);

    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove photo'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );

    if (choice == 'remove') {
      setState(() {
        _pickedPhotoPath = null;
        _photoRemoved = true;
      });
      return;
    }
    if (choice == null) return;

    final file = await ImagePicker().pickImage(
      source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
      // A small preview is enough for the vehicle photo.
      maxWidth: 1280,
      imageQuality: 85,
    );
    if (file != null) setState(() => _pickedPhotoPath = file.path);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final storage = ref.read(fileStorageProvider);
    final repo = ref.read(vehicleRepositoryProvider);
    final oldPhoto = _existing?.photoFileName;

    String? photo = _photoRemoved ? null : oldPhoto;
    if (_pickedPhotoPath != null) {
      photo = await storage.importFile(_pickedPhotoPath!);
    }

    final odometer = parseInt(_odometer.text)!;
    final companion = VehiclesCompanion(
      id: _isNew ? const Value.absent() : Value(widget.vehicleId!),
      brand: Value(_brand.text.trim()),
      model: Value(_model.text.trim()),
      year: Value(int.tryParse(_year.text)),
      plate: Value(_nullIfBlank(_plate.text)?.toUpperCase()),
      vin: Value(_nullIfBlank(_vin.text)?.toUpperCase()),
      photoFileName: Value(photo),
      // For existing vehicles the odometer goes through updateOdometer()
      // so that the change is logged.
      currentOdo: _isNew ? Value(odometer) : const Value.absent(),
    );

    final id = await repo.save(companion);
    if (!_isNew && odometer != _existing!.currentOdo) {
      await repo.updateOdometer(id, odometer);
    }
    if (oldPhoto != null && oldPhoto != photo) await storage.delete(oldPhoto);
    if (_isNew) await ref.read(selectedVehicleIdProvider.notifier).select(id);

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? 'New vehicle' : 'Edit vehicle'),
        actions: [
          TextButton(
            onPressed: _loading || _saving ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(child: _photoPicker(context)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _brand,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Brand *'),
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _model,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Model *'),
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _year,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: const InputDecoration(labelText: 'Year'),
                          validator: _validateYear,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _plate,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'License plate',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _odometer,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Current mileage *',
                      suffixText: 'km',
                    ),
                    validator: (v) =>
                        parseInt(v ?? '') == null ? 'Enter the mileage' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vin,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [LengthLimitingTextInputFormatter(17)],
                    decoration: const InputDecoration(
                      labelText: 'VIN',
                      helperText: '17 characters, optional',
                    ),
                    validator: (v) {
                      final vin = v?.trim() ?? '';
                      return vin.isEmpty || vin.length == 17
                          ? null
                          : 'VIN must have 17 characters';
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _photoPicker(BuildContext context) {
    const size = 120.0;
    final Widget image;
    if (_pickedPhotoPath != null) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.file(
          File(_pickedPhotoPath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      image = VehicleAvatar(
        photoFileName: _photoRemoved ? null : _existing?.photoFileName,
        size: size,
        radius: 24,
      );
    }

    return Stack(
      children: [
        GestureDetector(onTap: _pickPhoto, child: image),
        Positioned(
          right: 0,
          bottom: 0,
          child: IconButton.filled(
            tooltip: 'Change photo',
            icon: const Icon(Icons.photo_camera, size: 20),
            onPressed: _pickPhoto,
          ),
        ),
      ],
    );
  }
}

String? _required(String? value) =>
    value == null || value.trim().isEmpty ? 'Required' : null;

String? _validateYear(String? value) {
  if (value == null || value.isEmpty) return null;
  final year = int.tryParse(value);
  final max = DateTime.now().year + 1;
  if (year == null || year < 1900 || year > max) {
    return 'From 1900 to $max';
  }
  return null;
}

String? _nullIfBlank(String s) => s.trim().isEmpty ? null : s.trim();

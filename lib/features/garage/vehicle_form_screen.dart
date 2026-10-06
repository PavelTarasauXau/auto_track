import 'package:flutter/material.dart';

import '../../widgets/placeholder_view.dart';

class VehicleFormScreen extends StatelessWidget {
  const VehicleFormScreen({super.key, this.vehicleId});

  /// `null` when creating a new vehicle.
  final int? vehicleId;

  @override
  Widget build(BuildContext context) {
    final isNew = vehicleId == null;
    return Scaffold(
      appBar: AppBar(title: Text(isNew ? 'New vehicle' : 'Edit vehicle')),
      body: PlaceholderView(
        icon: Icons.edit_note,
        title: isNew ? 'New vehicle' : 'Vehicle #$vehicleId',
        subtitle: 'Brand, model, year, plate, odometer',
      ),
    );
  }
}

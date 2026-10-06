import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router.dart';
import '../../widgets/placeholder_view.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Garage')),
      body: PlaceholderView(
        icon: Icons.garage_outlined,
        title: 'Your vehicles',
        subtitle: 'Add vehicles and pick the current one',
        actions: [
          OutlinedButton(
            onPressed: () => context.push(Routes.editVehicle(1)),
            child: const Text('Edit sample vehicle'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add vehicle'),
        onPressed: () => context.push(Routes.newVehicle),
      ),
    );
  }
}

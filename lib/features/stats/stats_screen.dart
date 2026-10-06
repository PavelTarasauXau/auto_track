import 'package:flutter/material.dart';

import '../../widgets/placeholder_view.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: const PlaceholderView(
        icon: Icons.bar_chart,
        title: 'Statistics',
        subtitle: 'Costs by category, mileage, fuel consumption',
      ),
    );
  }
}

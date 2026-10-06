import 'package:flutter/material.dart';

import '../../widgets/placeholder_view.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plan'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Maintenance'),
              Tab(text: 'Reminders'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PlaceholderView(
              icon: Icons.build_circle_outlined,
              title: 'Maintenance plan',
              subtitle: 'Recurring tasks by mileage and/or time',
            ),
            PlaceholderView(
              icon: Icons.notifications_outlined,
              title: 'Reminders',
              subtitle: 'Notifications at a specific date and time',
            ),
          ],
        ),
      ),
    );
  }
}

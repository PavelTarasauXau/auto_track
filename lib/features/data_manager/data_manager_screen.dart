import 'package:flutter/material.dart';

import '../../widgets/placeholder_view.dart';

class DataManagerScreen extends StatelessWidget {
  const DataManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export & backup')),
      body: const PlaceholderView(
        icon: Icons.settings_backup_restore,
        title: 'Data manager',
        subtitle: 'PDF report, CSV export, ZIP backup and restore',
      ),
    );
  }
}

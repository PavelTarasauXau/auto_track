import 'package:flutter/material.dart';

import '../../widgets/placeholder_view.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: const PlaceholderView(
        icon: Icons.photo_library_outlined,
        title: 'Documents',
        subtitle: 'Receipts, warranties and insurance with search',
      ),
    );
  }
}

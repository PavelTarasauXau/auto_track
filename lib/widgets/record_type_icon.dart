import 'package:flutter/material.dart';

import '../core/enums.dart';

/// Round icon in the color of the record type.
class RecordTypeIcon extends StatelessWidget {
  const RecordTypeIcon(this.type, {super.key, this.size = 40});

  final RecordType type;
  final double size;

  static Color colorOf(RecordType type) => switch (type) {
    RecordType.fuel => Colors.orange,
    RecordType.service => Colors.blue,
    RecordType.repair => Colors.red,
    RecordType.parts => Colors.purple,
    RecordType.wash => Colors.teal,
    RecordType.other => Colors.blueGrey,
  };

  @override
  Widget build(BuildContext context) {
    final color = colorOf(type);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(type.icon, color: color, size: size * 0.55),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'ui.dart';

/// Glowing icon in the color of the record type.
class RecordTypeIcon extends StatelessWidget {
  const RecordTypeIcon(this.type, {super.key, this.size = 44});

  final RecordType type;
  final double size;

  static Color colorOf(RecordType type) => switch (type) {
    RecordType.fuel => const Color(0xFFFFB547),
    RecordType.service => const Color(0xFF3DD9FF),
    RecordType.repair => const Color(0xFFFF5470),
    RecordType.parts => const Color(0xFFA78BFA),
    RecordType.wash => const Color(0xFF2DD4BF),
    RecordType.other => const Color(0xFF94A3B8),
  };

  @override
  Widget build(BuildContext context) =>
      GlowIcon(type.icon, color: colorOf(type), size: size);
}

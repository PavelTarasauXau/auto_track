import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// Vehicle photo from storage, or a car icon when there is none.
class VehicleAvatar extends ConsumerWidget {
  const VehicleAvatar({
    super.key,
    required this.photoFileName,
    this.size = 56,
    this.radius = 12,
  });

  final String? photoFileName;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final fallback = ColoredBox(
      color: scheme.primaryContainer,
      child: Icon(
        Icons.directions_car,
        size: size * 0.5,
        color: scheme.onPrimaryContainer,
      ),
    );

    final name = photoFileName;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox.square(
        dimension: size,
        child: name == null
            ? fallback
            : Image.file(
                ref.watch(fileStorageProvider).fileOf(name),
                fit: BoxFit.cover,
                // Decode at display size, not at full camera resolution.
                cacheWidth: (size * MediaQuery.devicePixelRatioOf(context))
                    .round(),
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

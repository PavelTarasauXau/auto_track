import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/router.dart';
import '../../data/repositories/record_models.dart';
import '../../providers.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/placeholder_view.dart';
import '../../widgets/record_type_icon.dart';

class RecordDetailsScreen extends ConsumerWidget {
  const RecordDetailsScreen({super.key, required this.recordId});

  final int recordId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await confirm(
      context,
      title: 'Delete record?',
      message: 'The record and its photos will be deleted.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    context.pop();
    await ref.read(recordRepositoryProvider).delete(recordId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(recordDetailsProvider(recordId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
        actions: [
          if (details.value != null) ...[
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(Routes.editRecord(recordId)),
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context, ref),
            ),
          ],
        ],
      ),
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (d) => d == null
            ? const PlaceholderView(
                icon: Icons.search_off,
                title: 'Record not found',
              )
            : _Details(details: d),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.details});

  final RecordDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = details.record;
    final fuel = details.fuel;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            RecordTypeIcon(r.type, size: 56),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.title, style: theme.textTheme.titleLarge),
                  Text(
                    r.type.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (r.cost != null)
              Text(formatMoney(r.cost!), style: theme.textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 16),
        _Section(
          children: [
            _InfoRow(Icons.event, 'Date', formatDate(r.date)),
            _InfoRow(Icons.speed, 'Mileage', formatKm(r.odometer)),
            if (r.station != null)
              _InfoRow(Icons.place_outlined, 'Station', r.station!),
          ],
        ),
        if (fuel != null)
          _Section(
            title: 'Fuel',
            children: [
              _InfoRow(
                Icons.local_gas_station_outlined,
                'Volume',
                '${formatDecimal(fuel.liters)} L',
              ),
              _InfoRow(
                Icons.sell_outlined,
                'Price per liter',
                formatMoney(fuel.pricePerLiter),
              ),
              _InfoRow(
                Icons.water_drop_outlined,
                'Full tank',
                fuel.fullTank ? 'Yes' : 'No',
              ),
            ],
          ),
        if (details.items.isNotEmpty)
          _Section(
            title: 'Works & parts',
            children: [
              for (final item in details.items)
                ListTile(
                  dense: true,
                  leading: Icon(
                    item.kind == ItemKind.work
                        ? Icons.handyman_outlined
                        : Icons.settings_outlined,
                  ),
                  title: Text(item.name),
                  subtitle: item.partNumber == null
                      ? null
                      : Text(item.partNumber!),
                  trailing: item.cost == null
                      ? null
                      : Text(formatMoney(item.cost!)),
                ),
            ],
          ),
        if (details.completedTasks.isNotEmpty)
          _Section(
            title: 'Completed maintenance',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in details.completedTasks)
                      Chip(
                        avatar: const Icon(Icons.check, size: 18),
                        label: Text(t.title),
                      ),
                  ],
                ),
              ),
            ],
          ),
        if (r.note != null)
          _Section(
            title: 'Note',
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(r.note!),
              ),
            ],
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card.filled(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(title!, style: theme.textTheme.titleSmall),
                ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

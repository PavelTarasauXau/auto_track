import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums.dart';
import '../../core/format.dart';
import '../../core/router.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../domain/task_schedule.dart';
import '../../domain/task_view.dart';
import '../../providers.dart';
import '../../widgets/placeholder_view.dart';
import '../../widgets/record_type_icon.dart';
import '../../widgets/ui.dart';
import '../garage/odometer_dialog.dart';
import '../garage/vehicle_text.dart';
import '../history/record_tile.dart';
import '../plan/reminder_sheet.dart';
import '../plan/task_tile.dart';
import '../plan/templates_sheet.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentVehicleProvider);
    final vehicle = current.value;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        title: const _Brand(),
        actions: [
          if (vehicle != null) const _GarageButton(),
          IconButton(
            tooltip: 'Export & backup',
            icon: const Icon(Icons.settings_backup_restore),
            onPressed: () => context.push(Routes.data),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: current.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (vehicle) => vehicle == null
            ? PlaceholderView(
                icon: Icons.directions_car,
                title: 'Welcome to AutoTrack',
                subtitle:
                    'Add your vehicle to track its maintenance, '
                    'service history and documents',
                actions: [
                  GradientButton(
                    icon: Icons.add,
                    label: 'Add vehicle',
                    onPressed: () => context.push(Routes.newVehicle),
                  ),
                ],
              )
            : _Dashboard(vehicle: vehicle),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    // Sections appear one after another.
    Widget staged(int i, Widget child) => FadeSlideIn(
      delay: Duration(milliseconds: 70 * i),
      child: child,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        staged(0, _HeroCard(vehicle: vehicle)),
        const SizedBox(height: 14),
        staged(1, _Gauges(vehicle: vehicle)),
        const SizedBox(height: 22),
        staged(2, _QuickActions(vehicle: vehicle)),
        const SizedBox(height: 26),
        staged(3, _Maintenance(vehicle: vehicle)),
        const SizedBox(height: 18),
        staged(4, _RecentRecords(vehicleId: vehicle.id)),
      ],
    );
  }
}

/// App name in the signature gradient.
class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: AppColors.accent.createShader,
      child: const Text(
        'AutoTrack',
        style: TextStyle(
          fontFamily: displayFont,
          fontWeight: FontWeight.w700,
          fontSize: 26,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Opens the garage to switch between vehicles.
class _GarageButton extends StatelessWidget {
  const _GarageButton();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Garage',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(Routes.garage),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.garage_outlined, size: 20),
              Icon(Icons.arrow_drop_down, color: AppColors.cyan),
            ],
          ),
        ),
      ),
    );
  }
}

/// Big vehicle card: photo (or a glowing silhouette), name and plate.
class _HeroCard extends ConsumerWidget {
  const _HeroCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = vehicle.photoFileName;
    final file = photo == null
        ? null
        : ref.watch(fileStorageProvider).fileOf(photo);

    final background = file == null
        ? const _Silhouette()
        : Image.file(
            file,
            fit: BoxFit.cover,
            cacheWidth:
                (MediaQuery.sizeOf(context).width *
                        MediaQuery.devicePixelRatioOf(context))
                    .round(),
            errorBuilder: (_, _, _) => const _Silhouette(),
          );

    return GlowBackdrop(
      child: Container(
        height: 210,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withValues(alpha: 0.12),
              blurRadius: 40,
              spreadRadius: -10,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            background,
            // Darkens the bottom so the text stays readable on any photo.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE6070910)],
                  stops: [0.35, 1],
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _GlassIconButton(
                tooltip: 'Edit vehicle',
                icon: Icons.edit_outlined,
                onPressed: () => context.push(Routes.editVehicle(vehicle.id)),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.displayName,
                    style: Theme.of(context).textTheme.headlineMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (vehicle.plate != null) ...[
                        LicensePlate(vehicle.plate!),
                        const SizedBox(width: 10),
                      ],
                      if (vehicle.year != null)
                        Text(
                          '${vehicle.year}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Silhouette extends StatelessWidget {
  const _Silhouette();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E2A34), Color(0xFF1A1440)],
        ),
      ),
      child: Align(
        alignment: const Alignment(0.75, -0.35),
        child: Icon(
          Icons.directions_car_filled,
          size: 150,
          color: AppColors.cyan.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(side: BorderSide(color: Colors.white24)),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: 20, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}

/// Odometer and the vehicle health ring, like an instrument cluster.
class _Gauges extends ConsumerWidget {
  const _Gauges({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastUpdate = ref
        .watch(odometerLogProvider(vehicle.id))
        .value
        ?.lastOrNull;
    final views = ref.watch(taskViewsProvider(vehicle.id)).value ?? const [];
    final health = healthScore(views);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _CapsLabel('ODOMETER'),
                  const SizedBox(height: 4),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: vehicle.currentOdo.toDouble()),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutExpo,
                    builder: (context, v, _) => Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: formatNumber(v.round()),
                            style: const TextStyle(
                              fontFamily: displayFont,
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                              height: 1.1,
                            ),
                          ),
                          const TextSpan(
                            text: ' km',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (lastUpdate != null)
                    Text(
                      'Updated ${formatDate(lastUpdate.date)}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.speed, size: 18),
                    label: const Text('Update'),
                    onPressed: () => showOdometerDialog(context, ref, vehicle),
                  ),
                ],
              ),
            ),
            ProgressRing(
              value: (health ?? 0) / 100,
              size: 108,
              stroke: 9,
              gradient: AppColors.accent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    health == null ? '—' : '$health%',
                    style: const TextStyle(
                      fontFamily: displayFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const _CapsLabel('HEALTH'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CapsLabel extends StatelessWidget {
  const _CapsLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      letterSpacing: 1.6,
      fontWeight: FontWeight.w600,
      color: AppColors.textMuted,
    ),
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (
        Icons.local_gas_station,
        'Refuel',
        RecordTypeIcon.colorOf(RecordType.fuel),
        () => context.push('${Routes.newRecord}?type=fuel'),
      ),
      (
        Icons.build,
        'Log service',
        RecordTypeIcon.colorOf(RecordType.service),
        () => context.push('${Routes.newRecord}?type=service'),
      ),
      (
        Icons.add_alert,
        'Reminder',
        AppColors.violet,
        () => showReminderSheet(context, vehicle: vehicle),
      ),
      (
        Icons.car_repair,
        'Repair',
        RecordTypeIcon.colorOf(RecordType.repair),
        () => context.push('${Routes.newRecord}?type=repair'),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final (icon, label, color, onTap) in actions)
          _RoundAction(icon: icon, label: label, color: color, onTap: onTap),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                  border: Border.all(color: color.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 18,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tasks that need attention; when all is fine, the next upcoming ones.
class _Maintenance extends ConsumerWidget {
  const _Maintenance({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final views = ref.watch(taskViewsProvider(vehicle.id)).value;
    if (views == null) return const SizedBox.shrink();

    final urgent = views
        .where(
          (v) => v.urgency == Urgency.overdue || v.urgency == Urgency.dueSoon,
        )
        .toList();
    final List<TaskView> shown = urgent.isNotEmpty
        ? urgent
        : views.where((v) => v.urgency == Urgency.ok).take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          'Maintenance',
          action: views.isEmpty ? null : 'See plan',
          onAction: () => context.go(Routes.plan),
        ),
        if (views.isEmpty)
          _SetupPlanCard(onTap: () => showTemplatesSheet(context, vehicle))
        else ...[
          if (urgent.isEmpty) const _AllGood(),
          for (final v in shown) ...[
            TaskTile(view: v, compact: true),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _AllGood extends StatelessWidget {
  const _AllGood();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.ok.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.ok.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified, color: AppColors.ok),
          SizedBox(width: 12),
          Expanded(child: Text('All good. Coming up next:')),
        ],
      ),
    );
  }
}

class _SetupPlanCard extends StatelessWidget {
  const _SetupPlanCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              GlowIcon(Icons.playlist_add, color: AppColors.violet),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Set up a maintenance plan',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Get reminded about oil, filters, insurance…',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentRecords extends ConsumerWidget {
  const _RecentRecords({required this.vehicleId});

  final int vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(recentRecordsProvider(vehicleId)).value ?? [];
    if (records.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          'Recent records',
          action: 'See all',
          onAction: () => context.go(Routes.history),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [for (final r in records) RecordTile(record: r)],
            ),
          ),
        ),
      ],
    );
  }
}

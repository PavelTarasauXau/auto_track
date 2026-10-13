import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../providers.dart';
import '../../services/backup_service.dart';
import '../../services/export/csv_export.dart';
import '../../services/export/pdf_report.dart';
import '../../widgets/confirm_dialog.dart';
import '../garage/vehicle_text.dart';

enum ReportPeriod {
  all('All time'),
  year('Last 12 months'),
  thisYear('This year');

  const ReportPeriod(this.label);

  final String label;

  DateTime? from(DateTime now) => switch (this) {
    ReportPeriod.all => null,
    ReportPeriod.year => DateTime(now.year - 1, now.month, now.day),
    ReportPeriod.thisYear => DateTime(now.year),
  };
}

class DataManagerScreen extends ConsumerStatefulWidget {
  const DataManagerScreen({super.key});

  @override
  ConsumerState<DataManagerScreen> createState() => _DataManagerScreenState();
}

class _DataManagerScreenState extends ConsumerState<DataManagerScreen> {
  ReportPeriod _period = ReportPeriod.all;
  bool _includePhotos = true;

  /// What is being done right now; `null` when idle.
  String? _busy;

  /// Runs [job] with a progress indicator and reports errors.
  Future<void> _run(String message, Future<String?> Function() job) async {
    setState(() => _busy = message);
    try {
      final done = await job();
      if (done != null) _snack(done);
    } on BackupException catch (e) {
      _snack(e.message);
    } catch (e) {
      _snack('Something went wrong: $e');
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<File> _tempFile(String name) async {
    final dir = await ref.read(tempDirProvider)();
    return File(p.join(dir.path, name));
  }

  Future<void> _share(File file, String subject) =>
      ref.read(shareFileProvider)(file.path, subject);

  Future<String?> _exportPdf(Vehicle vehicle) async {
    final now = DateTime.now();
    final from = _period.from(now);
    final records = await ref
        .read(recordRepositoryProvider)
        .getAllDetails(vehicle.id, from: from);
    final fonts = await Future.wait([
      rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
      rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
    ]);

    final bytes = await buildServiceBook(
      ServiceBookInput(
        vehicle: vehicle,
        records: records,
        regularFont: fonts[0].buffer.asUint8List(),
        boldFont: fonts[1].buffer.asUint8List(),
        generatedAt: now,
        from: from,
        photosDir: _includePhotos
            ? ref.read(fileStorageProvider).directory.path
            : null,
      ),
    );
    final file = await _tempFile('service-book-${_slug(vehicle)}.pdf');
    await file.writeAsBytes(bytes);
    await _share(file, 'Service book: ${vehicle.displayName}');
    return null;
  }

  Future<String?> _exportCsv(Vehicle vehicle) async {
    final records = await ref
        .read(recordRepositoryProvider)
        .getAllDetails(vehicle.id);
    final file = await _tempFile('history-${_slug(vehicle)}.csv');
    await file.writeAsString(buildRecordsCsv(records));
    await _share(file, 'Service history: ${vehicle.displayName}');
    return null;
  }

  Future<String?> _createBackup() async {
    final dir = await ref.read(tempDirProvider)();
    final zip = await ref.read(backupServiceProvider).create(dir);
    await _share(zip, 'AutoTrack backup');
    return null;
  }

  Future<void> _restore() async {
    final path = await ref.read(pickBackupFileProvider)();
    if (path == null || !mounted) return;
    final ok = await confirm(
      context,
      title: 'Restore backup?',
      message:
          'All vehicles, records and photos on this phone will be replaced '
          'with the data from the backup. This cannot be undone.',
      confirmLabel: 'Restore',
      destructive: true,
    );
    if (!ok) return;

    await _run('Restoring…', () async {
      final temp = await ref.read(tempDirProvider)();
      final work = Directory(
        p.join(temp.path, 'restore-${DateTime.now().millisecondsSinceEpoch}'),
      );
      final db = ref.read(databaseProvider);
      // Validated before anything is touched: a bad file changes nothing.
      final backup = await BackupService.unpack(
        path,
        work,
        currentSchemaVersion: db.schemaVersion,
      );
      final service = ref.read(backupServiceProvider);
      await db.close();
      service.replaceData(backup);
      // Reopens the database; every screen reloads its data.
      ref.invalidate(databaseProvider);
      work.deleteSync(recursive: true);
      return 'Backup from ${formatDateTime(backup.createdAt)} restored';
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = ref.watch(currentVehicleProvider).value;
    final busy = _busy;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export & backup'),
        bottom: busy == null
            ? null
            : const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              ),
      ),
      body: AbsorbPointer(
        absorbing: busy != null,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (busy != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(busy, textAlign: TextAlign.center),
              ),
            if (vehicle != null) ...[
              _Section(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Service book (PDF)',
                description:
                    'All services, repairs and refuels of '
                    '${vehicle.displayName} in one document — handy when '
                    'selling the car.',
                children: [
                  DropdownButtonFormField<ReportPeriod>(
                    initialValue: _period,
                    decoration: const InputDecoration(labelText: 'Period'),
                    items: [
                      for (final period in ReportPeriod.values)
                        DropdownMenuItem(
                          value: period,
                          child: Text(period.label),
                        ),
                    ],
                    onChanged: (v) => setState(() => _period = v ?? _period),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Include receipt photos'),
                    value: _includePhotos,
                    onChanged: (v) => setState(() => _includePhotos = v),
                  ),
                  FilledButton.icon(
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Create PDF'),
                    onPressed: () =>
                        _run('Building the PDF…', () => _exportPdf(vehicle)),
                  ),
                ],
              ),
              _Section(
                icon: Icons.table_chart_outlined,
                title: 'Spreadsheet (CSV)',
                description:
                    'The full history of ${vehicle.displayName}; '
                    'opens in Excel or Google Sheets.',
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Export CSV'),
                    onPressed: () =>
                        _run('Exporting…', () => _exportCsv(vehicle)),
                  ),
                ],
              ),
            ],
            _Section(
              icon: Icons.backup_outlined,
              title: 'Backup',
              description:
                  'All vehicles, records, plans and photos in one .zip file. '
                  'Save it to the cloud or send it to your new phone, then '
                  'restore it there.',
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.archive_outlined),
                  label: const Text('Create backup'),
                  onPressed: () => _run('Creating the backup…', _createBackup),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  icon: const Icon(Icons.settings_backup_restore),
                  label: const Text('Restore from backup'),
                  onPressed: _restore,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// `Toyota Corolla` → `toyota-corolla-20261013` (safe for file names).
String _slug(Vehicle v) {
  final name = v.displayName.toLowerCase().replaceAll(
    RegExp(r'[\\/:*?"<>|\s]+'),
    '-',
  );
  return '$name-${DateFormat('yyyyMMdd').format(DateTime.now())}';
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.title,
    required this.description,
    required this.children,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(icon, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(title, style: theme.textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8),
              Text(description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

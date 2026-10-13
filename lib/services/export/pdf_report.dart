import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/enums.dart';
import '../../data/db/database.dart';
import '../../data/repositories/record_models.dart';

/// Everything needed to build the report; plain data, so it can be sent
/// to a background isolate.
class ServiceBookInput {
  const ServiceBookInput({
    required this.vehicle,
    required this.records,
    required this.regularFont,
    required this.boldFont,
    required this.generatedAt,
    this.from,
    this.photosDir,
  });

  final Vehicle vehicle;

  /// Records of the period, oldest first.
  final List<RecordDetails> records;

  /// TTF files with Cyrillic glyphs (assets/fonts).
  final Uint8List regularFont;
  final Uint8List boldFont;
  final DateTime generatedAt;

  /// Start of the period, `null` for the whole history.
  final DateTime? from;

  /// Directory with attachment files; `null` to leave photos out.
  final String? photosDir;
}

/// Builds the "service book" PDF in a background isolate: laying out
/// tables and decoding/resizing receipt photos takes seconds on a phone.
Future<Uint8List> buildServiceBook(ServiceBookInput input) =>
    Isolate.run(() => buildServiceBookSync(input));

final _date = DateFormat('d MMM yyyy', 'en_US');
final _money = NumberFormat('#,##0.00', 'en');
final _km = NumberFormat.decimalPattern('en');

/// The actual work; runs inside the isolate.
Future<Uint8List> buildServiceBookSync(ServiceBookInput input) async {
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(input.regularFont.buffer.asByteData()),
    bold: pw.Font.ttf(input.boldFont.buffer.asByteData()),
  );
  final v = input.vehicle;
  final records = input.records;
  final accent = PdfColor.fromHex('#1E5AA8');

  final total = records.fold<double>(0, (s, d) => s + (d.record.cost ?? 0));
  final byType = <RecordType, double>{};
  for (final d in records) {
    final cost = d.record.cost ?? 0;
    if (cost > 0) byType[d.record.type] = (byType[d.record.type] ?? 0) + cost;
  }
  final odometers = records.map((d) => d.record.odometer).toList();

  final doc = pw.Document(
    theme: theme,
    title: 'Service book — ${v.brand} ${v.model}',
    creator: 'AutoTrack',
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      footer: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'AutoTrack · ${_date.format(input.generatedAt)}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
      build: (context) => [
        pw.Text(
          'Service book',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: accent,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          [
            '${v.brand} ${v.model}',
            if (v.year != null) '${v.year}',
            ?v.plate,
          ].join(' · '),
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          [
            if (v.vin != null) 'VIN ${v.vin}',
            'Current mileage ${_km.format(v.currentOdo)} km',
            input.from == null
                ? 'All records'
                : 'Records since ${_date.format(input.from!)}',
          ].join(' · '),
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 16),
        _summary(records.length, total, odometers, byType),
        pw.SizedBox(height: 20),
        if (records.isEmpty)
          pw.Text('No records in this period.')
        else
          _recordsTable(records, accent),
      ],
    ),
  );

  final photos = input.photosDir == null
      ? const <_Photo>[]
      : _loadPhotos(records, input.photosDir!);
  if (photos.isNotEmpty) {
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'Receipts & documents',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: accent,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final photo in photos)
                pw.SizedBox(
                  width: 250,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(
                        pw.MemoryImage(photo.bytes),
                        width: 250,
                        height: 250,
                        fit: pw.BoxFit.contain,
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        photo.caption,
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  return doc.save();
}

pw.Widget _summary(
  int count,
  double total,
  List<int> odometers,
  Map<RecordType, double> byType,
) {
  pw.Widget cell(String label, String value) => pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ],
      ),
    ),
  );

  final distance = odometers.length < 2
      ? '—'
      : '${_km.format(odometers.reduce((a, b) => a > b ? a : b) - odometers.reduce((a, b) => a < b ? a : b))} km';

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Row(
        children: [
          cell('Records', '$count'),
          pw.SizedBox(width: 8),
          cell('Total spent', _money.format(total)),
          pw.SizedBox(width: 8),
          cell('Distance covered', distance),
        ],
      ),
      if (byType.isNotEmpty) ...[
        pw.SizedBox(height: 8),
        pw.Text(
          byType.entries
              .map((e) => '${e.key.label}: ${_money.format(e.value)}')
              .join('   ·   '),
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
        ),
      ],
    ],
  );
}

pw.Widget _recordsTable(List<RecordDetails> records, PdfColor accent) {
  const header = pw.TextStyle(fontSize: 9, color: PdfColors.white);
  const body = pw.TextStyle(fontSize: 9);
  const small = pw.TextStyle(fontSize: 8, color: PdfColors.grey700);

  pw.Widget pad(pw.Widget child) =>
      pw.Padding(padding: const pw.EdgeInsets.all(5), child: child);

  return pw.Table(
    columnWidths: const {
      0: pw.FixedColumnWidth(62),
      1: pw.FixedColumnWidth(58),
      2: pw.FlexColumnWidth(),
      3: pw.FixedColumnWidth(60),
    },
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
    ),
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: accent),
        repeat: true,
        children: [
          pad(pw.Text('Date', style: header)),
          pad(pw.Text('Mileage', style: header)),
          pad(pw.Text('Work', style: header)),
          pad(
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Cost', style: header),
            ),
          ),
        ],
      ),
      for (final d in records)
        pw.TableRow(
          children: [
            pad(pw.Text(_date.format(d.record.date), style: body)),
            pad(pw.Text('${_km.format(d.record.odometer)} km', style: body)),
            pad(
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '${d.record.title} (${d.record.type.label})',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (d.record.station != null)
                    pw.Text(d.record.station!, style: small),
                  if (d.fuel case final f?)
                    pw.Text(
                      '${f.liters} L × ${_money.format(f.pricePerLiter)}'
                      '${f.fullTank ? ' · full tank' : ''}',
                      style: small,
                    ),
                  for (final i in d.items)
                    pw.Text(
                      [
                        '• ${i.name}',
                        if (i.partNumber != null) '(${i.partNumber})',
                        if (i.cost != null) '— ${_money.format(i.cost)}',
                      ].join(' '),
                      style: small,
                    ),
                  if (d.completedTasks.isNotEmpty)
                    pw.Text(
                      'Maintenance: ${d.completedTasks.map((t) => t.title).join(', ')}',
                      style: small,
                    ),
                  if (d.record.note != null)
                    pw.Text(d.record.note!, style: small),
                ],
              ),
            ),
            pad(
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Text(
                  d.record.cost == null ? '' : _money.format(d.record.cost),
                  style: body,
                ),
              ),
            ),
          ],
        ),
    ],
  );
}

class _Photo {
  const _Photo(this.bytes, this.caption);

  final Uint8List bytes;
  final String caption;
}

/// Reads attachment photos and shrinks them so the PDF stays small.
List<_Photo> _loadPhotos(List<RecordDetails> records, String dir) {
  final photos = <_Photo>[];
  for (final d in records) {
    for (final a in d.attachments) {
      final file = File(p.join(dir, a.fileName));
      if (!file.existsSync()) continue;
      final decoded = img.decodeImage(file.readAsBytesSync());
      if (decoded == null) continue;
      final resized = decoded.width > 700 || decoded.height > 700
          ? img.copyResize(
              decoded,
              width: decoded.width >= decoded.height ? 700 : null,
              height: decoded.width >= decoded.height ? null : 700,
            )
          : decoded;
      photos.add(
        _Photo(
          img.encodeJpg(resized, quality: 75),
          [
            _date.format(d.record.date),
            d.record.title,
            a.docType.label,
            ?a.caption,
          ].join(' · '),
        ),
      );
    }
  }
  return photos;
}

import 'package:drift/drift.dart';

import '../../core/enums.dart';
import '../../services/file_storage.dart';
import '../db/database.dart';
import 'record_repository.dart';

/// An attachment with the record it belongs to (if any), for the documents grid.
class DocumentEntry {
  const DocumentEntry(this.attachment, this.record);

  final Attachment attachment;
  final ServiceRecord? record;
}

class AttachmentRepository {
  AttachmentRepository(this._db, this._files);

  final AppDatabase _db;
  final FileStorage _files;

  /// Documents of a vehicle, newest first. [query] searches the caption and
  /// the linked record (title, station, parts, date) via the FTS index.
  Stream<List<DocumentEntry>> watchDocuments(
    int vehicleId, {
    DocType? type,
    String? query,
  }) {
    final a = _db.attachments;
    final r = _db.serviceRecords;
    final select = _db.select(a).join([
      leftOuterJoin(r, r.id.equalsExp(a.recordId)),
    ])..where(a.vehicleId.equals(vehicleId));

    if (type != null) select.where(a.docType.equalsValue(type));

    final match = ftsMatchQuery(query);
    if (match != null) {
      final literal = "'${match.replaceAll("'", "''")}'";
      final like = '%${query!.trim()}%';
      select.where(
        a.caption.like(like) |
            CustomExpression<bool>(
              'attachments.record_id IN (SELECT rowid FROM record_search '
              'WHERE record_search MATCH $literal)',
            ),
      );
    }

    select.orderBy([OrderingTerm.desc(r.date), OrderingTerm.desc(a.createdAt)]);
    return select
        .map((row) => DocumentEntry(row.readTable(a), row.readTableOrNull(r)))
        .watch();
  }

  /// Adds a standalone document (not linked to a record).
  Future<int> addDocument({
    required int vehicleId,
    required String fileName,
    required DocType type,
    String? caption,
  }) => _db
      .into(_db.attachments)
      .insert(
        AttachmentsCompanion.insert(
          vehicleId: vehicleId,
          fileName: fileName,
          docType: type,
          caption: Value(caption),
        ),
      );

  Future<void> updateCaption(int id, {String? caption, DocType? type}) =>
      (_db.update(_db.attachments)..where((a) => a.id.equals(id))).write(
        AttachmentsCompanion(
          caption: Value(caption),
          docType: type == null ? const Value.absent() : Value(type),
        ),
      );

  Future<void> delete(Attachment attachment) async {
    await (_db.delete(
      _db.attachments,
    )..where((a) => a.id.equals(attachment.id))).go();
    await _files.delete(attachment.fileName);
  }
}

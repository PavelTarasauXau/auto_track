import '../../core/enums.dart';
import '../db/database.dart';

/// Everything the record form edits, saved in one transaction.
class RecordDraft {
  const RecordDraft({
    this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.odometer,
    required this.title,
    this.station,
    this.cost,
    this.note,
    this.fuel,
    this.items = const [],
    this.attachments = const [],
    this.completedTaskIds = const {},
  });

  /// `null` for a new record.
  final int? id;
  final int vehicleId;
  final RecordType type;
  final DateTime date;
  final int odometer;
  final String title;
  final String? station;
  final double? cost;
  final String? note;

  /// Required for [RecordType.fuel], ignored otherwise.
  final FuelDraft? fuel;
  final List<ItemDraft> items;

  /// Attachments the record should have after saving. Existing ones that are
  /// missing here are deleted together with their files.
  final List<AttachmentDraft> attachments;
  final Set<int> completedTaskIds;
}

class FuelDraft {
  const FuelDraft({
    required this.liters,
    required this.pricePerLiter,
    this.fullTank = true,
  });

  final double liters;
  final double pricePerLiter;
  final bool fullTank;
}

class ItemDraft {
  const ItemDraft({
    required this.kind,
    required this.name,
    this.partNumber,
    this.cost,
  });

  final ItemKind kind;
  final String name;
  final String? partNumber;
  final double? cost;
}

class AttachmentDraft {
  const AttachmentDraft({
    this.id,
    required this.fileName,
    this.docType = DocType.receipt,
    this.caption,
  });

  /// `null` for a newly added photo.
  final int? id;
  final String fileName;
  final DocType docType;
  final String? caption;
}

/// A record with all related data, for the details screen and the form.
class RecordDetails {
  const RecordDetails({
    required this.record,
    this.fuel,
    required this.items,
    required this.attachments,
    required this.completedTasks,
  });

  final ServiceRecord record;
  final FuelDetail? fuel;
  final List<RecordItem> items;
  final List<Attachment> attachments;
  final List<MaintenanceTask> completedTasks;
}

/// Filter for the history list.
class RecordFilter {
  const RecordFilter({this.types = const {}, this.from, this.query});

  /// Empty means all types.
  final Set<RecordType> types;
  final DateTime? from;
  final String? query;
}

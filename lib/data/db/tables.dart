import 'package:drift/drift.dart';

import '../../core/enums.dart';

class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer().nullable()();
  TextColumn get plate => text().nullable()();
  TextColumn get vin => text().nullable()();
  IntColumn get currentOdo => integer().withDefault(const Constant(0))();

  /// File name inside the receipts directory, not a full path.
  TextColumn get photoFileName => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Every odometer update; used to estimate average daily mileage.
class OdometerLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get value => integer()();
}

// `Record` is a built-in Dart type, hence the explicit data class name.
@DataClassName('ServiceRecord')
class ServiceRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => textEnum<RecordType>()();
  DateTimeColumn get date => dateTime()();
  IntColumn get odometer => integer()();
  TextColumn get title => text()();
  TextColumn get station => text().nullable()();
  RealColumn get cost => real().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Extra data for [RecordType.fuel] records (one-to-one).
class FuelDetails extends Table {
  IntColumn get recordId =>
      integer().references(ServiceRecords, #id, onDelete: KeyAction.cascade)();
  RealColumn get liters => real()();
  RealColumn get pricePerLiter => real()();

  /// Needed to calculate consumption with the "full tank to full tank" method.
  BoolColumn get fullTank => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {recordId};
}

/// Works and parts listed in a record.
class RecordItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recordId =>
      integer().references(ServiceRecords, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => textEnum<ItemKind>()();
  TextColumn get name => text()();
  TextColumn get partNumber => text().nullable()();
  RealColumn get cost => real().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
}

/// Scheduled maintenance: recurring (by km and/or days) or one-off.
class MaintenanceTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  IntColumn get intervalKm => integer().nullable()();
  IntColumn get intervalDays => integer().nullable()();
  IntColumn get lastDoneOdo => integer().nullable()();
  DateTimeColumn get lastDoneDate => dateTime().nullable()();
  IntColumn get dueOdo => integer().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get remindBeforeKm => integer().withDefault(const Constant(500))();
  IntColumn get remindBeforeDays => integer().withDefault(const Constant(14))();
  TextColumn get note => text().nullable()();

  /// One-off tasks become inactive once completed.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Which maintenance tasks a record has completed.
class RecordTasks extends Table {
  IntColumn get recordId =>
      integer().references(ServiceRecords, #id, onDelete: KeyAction.cascade)();
  IntColumn get taskId => integer().references(
    MaintenanceTasks,
    #id,
    onDelete: KeyAction.cascade,
  )();

  @override
  Set<Column> get primaryKey => {recordId, taskId};
}

/// Calendar-style reminders with a push notification at an exact time.
class Reminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId => integer().nullable().references(
    Vehicles,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get title => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get remindAt => dateTime()();
  TextColumn get repeat =>
      textEnum<RepeatRule>().withDefault(Constant(RepeatRule.none.name))();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
}

/// Photos of receipts and documents. A document may exist without a record
/// (e.g. an insurance policy).
class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  IntColumn get recordId => integer().nullable().references(
    ServiceRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// File name inside the receipts directory, not a full path, so that
  /// backups can be restored on another device.
  TextColumn get fileName => text()();
  TextColumn get docType => textEnum<DocType>()();
  TextColumn get caption => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

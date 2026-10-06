// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
    'vin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentOdoMeta = const VerificationMeta(
    'currentOdo',
  );
  @override
  late final GeneratedColumn<int> currentOdo = GeneratedColumn<int>(
    'current_odo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _photoFileNameMeta = const VerificationMeta(
    'photoFileName',
  );
  @override
  late final GeneratedColumn<String> photoFileName = GeneratedColumn<String>(
    'photo_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    brand,
    model,
    year,
    plate,
    vin,
    currentOdo,
    photoFileName,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    }
    if (data.containsKey('vin')) {
      context.handle(
        _vinMeta,
        vin.isAcceptableOrUnknown(data['vin']!, _vinMeta),
      );
    }
    if (data.containsKey('current_odo')) {
      context.handle(
        _currentOdoMeta,
        currentOdo.isAcceptableOrUnknown(data['current_odo']!, _currentOdoMeta),
      );
    }
    if (data.containsKey('photo_file_name')) {
      context.handle(
        _photoFileNameMeta,
        photoFileName.isAcceptableOrUnknown(
          data['photo_file_name']!,
          _photoFileNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      ),
      vin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vin'],
      ),
      currentOdo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_odo'],
      )!,
      photoFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_file_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String brand;
  final String model;
  final int? year;
  final String? plate;
  final String? vin;
  final int currentOdo;

  /// File name inside the receipts directory, not a full path.
  final String? photoFileName;
  final DateTime createdAt;
  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    this.year,
    this.plate,
    this.vin,
    required this.currentOdo,
    this.photoFileName,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || plate != null) {
      map['plate'] = Variable<String>(plate);
    }
    if (!nullToAbsent || vin != null) {
      map['vin'] = Variable<String>(vin);
    }
    map['current_odo'] = Variable<int>(currentOdo);
    if (!nullToAbsent || photoFileName != null) {
      map['photo_file_name'] = Variable<String>(photoFileName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      brand: Value(brand),
      model: Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      plate: plate == null && nullToAbsent
          ? const Value.absent()
          : Value(plate),
      vin: vin == null && nullToAbsent ? const Value.absent() : Value(vin),
      currentOdo: Value(currentOdo),
      photoFileName: photoFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(photoFileName),
      createdAt: Value(createdAt),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      plate: serializer.fromJson<String?>(json['plate']),
      vin: serializer.fromJson<String?>(json['vin']),
      currentOdo: serializer.fromJson<int>(json['currentOdo']),
      photoFileName: serializer.fromJson<String?>(json['photoFileName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int?>(year),
      'plate': serializer.toJson<String?>(plate),
      'vin': serializer.toJson<String?>(vin),
      'currentOdo': serializer.toJson<int>(currentOdo),
      'photoFileName': serializer.toJson<String?>(photoFileName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Vehicle copyWith({
    int? id,
    String? brand,
    String? model,
    Value<int?> year = const Value.absent(),
    Value<String?> plate = const Value.absent(),
    Value<String?> vin = const Value.absent(),
    int? currentOdo,
    Value<String?> photoFileName = const Value.absent(),
    DateTime? createdAt,
  }) => Vehicle(
    id: id ?? this.id,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    year: year.present ? year.value : this.year,
    plate: plate.present ? plate.value : this.plate,
    vin: vin.present ? vin.value : this.vin,
    currentOdo: currentOdo ?? this.currentOdo,
    photoFileName: photoFileName.present
        ? photoFileName.value
        : this.photoFileName,
    createdAt: createdAt ?? this.createdAt,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      plate: data.plate.present ? data.plate.value : this.plate,
      vin: data.vin.present ? data.vin.value : this.vin,
      currentOdo: data.currentOdo.present
          ? data.currentOdo.value
          : this.currentOdo,
      photoFileName: data.photoFileName.present
          ? data.photoFileName.value
          : this.photoFileName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('vin: $vin, ')
          ..write('currentOdo: $currentOdo, ')
          ..write('photoFileName: $photoFileName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    brand,
    model,
    year,
    plate,
    vin,
    currentOdo,
    photoFileName,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.plate == this.plate &&
          other.vin == this.vin &&
          other.currentOdo == this.currentOdo &&
          other.photoFileName == this.photoFileName &&
          other.createdAt == this.createdAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> model;
  final Value<int?> year;
  final Value<String?> plate;
  final Value<String?> vin;
  final Value<int> currentOdo;
  final Value<String?> photoFileName;
  final Value<DateTime> createdAt;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.plate = const Value.absent(),
    this.vin = const Value.absent(),
    this.currentOdo = const Value.absent(),
    this.photoFileName = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String model,
    this.year = const Value.absent(),
    this.plate = const Value.absent(),
    this.vin = const Value.absent(),
    this.currentOdo = const Value.absent(),
    this.photoFileName = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : brand = Value(brand),
       model = Value(model);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? plate,
    Expression<String>? vin,
    Expression<int>? currentOdo,
    Expression<String>? photoFileName,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (plate != null) 'plate': plate,
      if (vin != null) 'vin': vin,
      if (currentOdo != null) 'current_odo': currentOdo,
      if (photoFileName != null) 'photo_file_name': photoFileName,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? brand,
    Value<String>? model,
    Value<int?>? year,
    Value<String?>? plate,
    Value<String?>? vin,
    Value<int>? currentOdo,
    Value<String?>? photoFileName,
    Value<DateTime>? createdAt,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      vin: vin ?? this.vin,
      currentOdo: currentOdo ?? this.currentOdo,
      photoFileName: photoFileName ?? this.photoFileName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (currentOdo.present) {
      map['current_odo'] = Variable<int>(currentOdo.value);
    }
    if (photoFileName.present) {
      map['photo_file_name'] = Variable<String>(photoFileName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('vin: $vin, ')
          ..write('currentOdo: $currentOdo, ')
          ..write('photoFileName: $photoFileName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OdometerLogsTable extends OdometerLogs
    with TableInfo<$OdometerLogsTable, OdometerLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OdometerLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, vehicleId, date, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'odometer_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OdometerLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OdometerLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OdometerLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $OdometerLogsTable createAlias(String alias) {
    return $OdometerLogsTable(attachedDatabase, alias);
  }
}

class OdometerLog extends DataClass implements Insertable<OdometerLog> {
  final int id;
  final int vehicleId;
  final DateTime date;
  final int value;
  const OdometerLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['value'] = Variable<int>(value);
    return map;
  }

  OdometerLogsCompanion toCompanion(bool nullToAbsent) {
    return OdometerLogsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      value: Value(value),
    );
  }

  factory OdometerLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OdometerLog(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'value': serializer.toJson<int>(value),
    };
  }

  OdometerLog copyWith({int? id, int? vehicleId, DateTime? date, int? value}) =>
      OdometerLog(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
        date: date ?? this.date,
        value: value ?? this.value,
      );
  OdometerLog copyWithCompanion(OdometerLogsCompanion data) {
    return OdometerLog(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OdometerLog(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vehicleId, date, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OdometerLog &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.value == this.value);
}

class OdometerLogsCompanion extends UpdateCompanion<OdometerLog> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<DateTime> date;
  final Value<int> value;
  const OdometerLogsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.value = const Value.absent(),
  });
  OdometerLogsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required DateTime date,
    required int value,
  }) : vehicleId = Value(vehicleId),
       date = Value(date),
       value = Value(value);
  static Insertable<OdometerLog> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<DateTime>? date,
    Expression<int>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (value != null) 'value': value,
    });
  }

  OdometerLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<DateTime>? date,
    Value<int>? value,
  }) {
    return OdometerLogsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OdometerLogsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ServiceRecordsTable extends ServiceRecords
    with TableInfo<$ServiceRecordsTable, ServiceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RecordType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecordType>($ServiceRecordsTable.$convertertype);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<int> odometer = GeneratedColumn<int>(
    'odometer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationMeta = const VerificationMeta(
    'station',
  );
  @override
  late final GeneratedColumn<String> station = GeneratedColumn<String>(
    'station',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    type,
    date,
    odometer,
    title,
    station,
    cost,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    } else if (isInserting) {
      context.missing(_odometerMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('station')) {
      context.handle(
        _stationMeta,
        station.isAcceptableOrUnknown(data['station']!, _stationMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      type: $ServiceRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      station: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ServiceRecordsTable createAlias(String alias) {
    return $ServiceRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RecordType, String, String> $convertertype =
      const EnumNameConverter<RecordType>(RecordType.values);
}

class ServiceRecord extends DataClass implements Insertable<ServiceRecord> {
  final int id;
  final int vehicleId;
  final RecordType type;
  final DateTime date;
  final int odometer;
  final String title;
  final String? station;
  final double? cost;
  final String? note;
  final DateTime createdAt;
  const ServiceRecord({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.date,
    required this.odometer,
    required this.title,
    this.station,
    this.cost,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    {
      map['type'] = Variable<String>(
        $ServiceRecordsTable.$convertertype.toSql(type),
      );
    }
    map['date'] = Variable<DateTime>(date);
    map['odometer'] = Variable<int>(odometer);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || station != null) {
      map['station'] = Variable<String>(station);
    }
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ServiceRecordsCompanion toCompanion(bool nullToAbsent) {
    return ServiceRecordsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      type: Value(type),
      date: Value(date),
      odometer: Value(odometer),
      title: Value(title),
      station: station == null && nullToAbsent
          ? const Value.absent()
          : Value(station),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory ServiceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceRecord(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      type: $ServiceRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      odometer: serializer.fromJson<int>(json['odometer']),
      title: serializer.fromJson<String>(json['title']),
      station: serializer.fromJson<String?>(json['station']),
      cost: serializer.fromJson<double?>(json['cost']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'type': serializer.toJson<String>(
        $ServiceRecordsTable.$convertertype.toJson(type),
      ),
      'date': serializer.toJson<DateTime>(date),
      'odometer': serializer.toJson<int>(odometer),
      'title': serializer.toJson<String>(title),
      'station': serializer.toJson<String?>(station),
      'cost': serializer.toJson<double?>(cost),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ServiceRecord copyWith({
    int? id,
    int? vehicleId,
    RecordType? type,
    DateTime? date,
    int? odometer,
    String? title,
    Value<String?> station = const Value.absent(),
    Value<double?> cost = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => ServiceRecord(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    type: type ?? this.type,
    date: date ?? this.date,
    odometer: odometer ?? this.odometer,
    title: title ?? this.title,
    station: station.present ? station.value : this.station,
    cost: cost.present ? cost.value : this.cost,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  ServiceRecord copyWithCompanion(ServiceRecordsCompanion data) {
    return ServiceRecord(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      type: data.type.present ? data.type.value : this.type,
      date: data.date.present ? data.date.value : this.date,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      title: data.title.present ? data.title.value : this.title,
      station: data.station.present ? data.station.value : this.station,
      cost: data.cost.present ? data.cost.value : this.cost,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecord(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('title: $title, ')
          ..write('station: $station, ')
          ..write('cost: $cost, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    type,
    date,
    odometer,
    title,
    station,
    cost,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceRecord &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.type == this.type &&
          other.date == this.date &&
          other.odometer == this.odometer &&
          other.title == this.title &&
          other.station == this.station &&
          other.cost == this.cost &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ServiceRecordsCompanion extends UpdateCompanion<ServiceRecord> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<RecordType> type;
  final Value<DateTime> date;
  final Value<int> odometer;
  final Value<String> title;
  final Value<String?> station;
  final Value<double?> cost;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const ServiceRecordsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.type = const Value.absent(),
    this.date = const Value.absent(),
    this.odometer = const Value.absent(),
    this.title = const Value.absent(),
    this.station = const Value.absent(),
    this.cost = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ServiceRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required RecordType type,
    required DateTime date,
    required int odometer,
    required String title,
    this.station = const Value.absent(),
    this.cost = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       type = Value(type),
       date = Value(date),
       odometer = Value(odometer),
       title = Value(title);
  static Insertable<ServiceRecord> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? type,
    Expression<DateTime>? date,
    Expression<int>? odometer,
    Expression<String>? title,
    Expression<String>? station,
    Expression<double>? cost,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (type != null) 'type': type,
      if (date != null) 'date': date,
      if (odometer != null) 'odometer': odometer,
      if (title != null) 'title': title,
      if (station != null) 'station': station,
      if (cost != null) 'cost': cost,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ServiceRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<RecordType>? type,
    Value<DateTime>? date,
    Value<int>? odometer,
    Value<String>? title,
    Value<String?>? station,
    Value<double?>? cost,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return ServiceRecordsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      title: title ?? this.title,
      station: station ?? this.station,
      cost: cost ?? this.cost,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ServiceRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<int>(odometer.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (station.present) {
      map['station'] = Variable<String>(station.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('date: $date, ')
          ..write('odometer: $odometer, ')
          ..write('title: $title, ')
          ..write('station: $station, ')
          ..write('cost: $cost, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FuelDetailsTable extends FuelDetails
    with TableInfo<$FuelDetailsTable, FuelDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _litersMeta = const VerificationMeta('liters');
  @override
  late final GeneratedColumn<double> liters = GeneratedColumn<double>(
    'liters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pricePerLiterMeta = const VerificationMeta(
    'pricePerLiter',
  );
  @override
  late final GeneratedColumn<double> pricePerLiter = GeneratedColumn<double>(
    'price_per_liter',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullTankMeta = const VerificationMeta(
    'fullTank',
  );
  @override
  late final GeneratedColumn<bool> fullTank = GeneratedColumn<bool>(
    'full_tank',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("full_tank" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    recordId,
    liters,
    pricePerLiter,
    fullTank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelDetail> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    }
    if (data.containsKey('liters')) {
      context.handle(
        _litersMeta,
        liters.isAcceptableOrUnknown(data['liters']!, _litersMeta),
      );
    } else if (isInserting) {
      context.missing(_litersMeta);
    }
    if (data.containsKey('price_per_liter')) {
      context.handle(
        _pricePerLiterMeta,
        pricePerLiter.isAcceptableOrUnknown(
          data['price_per_liter']!,
          _pricePerLiterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerLiterMeta);
    }
    if (data.containsKey('full_tank')) {
      context.handle(
        _fullTankMeta,
        fullTank.isAcceptableOrUnknown(data['full_tank']!, _fullTankMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordId};
  @override
  FuelDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelDetail(
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      )!,
      liters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}liters'],
      )!,
      pricePerLiter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_liter'],
      )!,
      fullTank: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}full_tank'],
      )!,
    );
  }

  @override
  $FuelDetailsTable createAlias(String alias) {
    return $FuelDetailsTable(attachedDatabase, alias);
  }
}

class FuelDetail extends DataClass implements Insertable<FuelDetail> {
  final int recordId;
  final double liters;
  final double pricePerLiter;

  /// Needed to calculate consumption with the "full tank to full tank" method.
  final bool fullTank;
  const FuelDetail({
    required this.recordId,
    required this.liters,
    required this.pricePerLiter,
    required this.fullTank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_id'] = Variable<int>(recordId);
    map['liters'] = Variable<double>(liters);
    map['price_per_liter'] = Variable<double>(pricePerLiter);
    map['full_tank'] = Variable<bool>(fullTank);
    return map;
  }

  FuelDetailsCompanion toCompanion(bool nullToAbsent) {
    return FuelDetailsCompanion(
      recordId: Value(recordId),
      liters: Value(liters),
      pricePerLiter: Value(pricePerLiter),
      fullTank: Value(fullTank),
    );
  }

  factory FuelDetail.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelDetail(
      recordId: serializer.fromJson<int>(json['recordId']),
      liters: serializer.fromJson<double>(json['liters']),
      pricePerLiter: serializer.fromJson<double>(json['pricePerLiter']),
      fullTank: serializer.fromJson<bool>(json['fullTank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordId': serializer.toJson<int>(recordId),
      'liters': serializer.toJson<double>(liters),
      'pricePerLiter': serializer.toJson<double>(pricePerLiter),
      'fullTank': serializer.toJson<bool>(fullTank),
    };
  }

  FuelDetail copyWith({
    int? recordId,
    double? liters,
    double? pricePerLiter,
    bool? fullTank,
  }) => FuelDetail(
    recordId: recordId ?? this.recordId,
    liters: liters ?? this.liters,
    pricePerLiter: pricePerLiter ?? this.pricePerLiter,
    fullTank: fullTank ?? this.fullTank,
  );
  FuelDetail copyWithCompanion(FuelDetailsCompanion data) {
    return FuelDetail(
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      liters: data.liters.present ? data.liters.value : this.liters,
      pricePerLiter: data.pricePerLiter.present
          ? data.pricePerLiter.value
          : this.pricePerLiter,
      fullTank: data.fullTank.present ? data.fullTank.value : this.fullTank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelDetail(')
          ..write('recordId: $recordId, ')
          ..write('liters: $liters, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('fullTank: $fullTank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordId, liters, pricePerLiter, fullTank);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelDetail &&
          other.recordId == this.recordId &&
          other.liters == this.liters &&
          other.pricePerLiter == this.pricePerLiter &&
          other.fullTank == this.fullTank);
}

class FuelDetailsCompanion extends UpdateCompanion<FuelDetail> {
  final Value<int> recordId;
  final Value<double> liters;
  final Value<double> pricePerLiter;
  final Value<bool> fullTank;
  const FuelDetailsCompanion({
    this.recordId = const Value.absent(),
    this.liters = const Value.absent(),
    this.pricePerLiter = const Value.absent(),
    this.fullTank = const Value.absent(),
  });
  FuelDetailsCompanion.insert({
    this.recordId = const Value.absent(),
    required double liters,
    required double pricePerLiter,
    this.fullTank = const Value.absent(),
  }) : liters = Value(liters),
       pricePerLiter = Value(pricePerLiter);
  static Insertable<FuelDetail> custom({
    Expression<int>? recordId,
    Expression<double>? liters,
    Expression<double>? pricePerLiter,
    Expression<bool>? fullTank,
  }) {
    return RawValuesInsertable({
      if (recordId != null) 'record_id': recordId,
      if (liters != null) 'liters': liters,
      if (pricePerLiter != null) 'price_per_liter': pricePerLiter,
      if (fullTank != null) 'full_tank': fullTank,
    });
  }

  FuelDetailsCompanion copyWith({
    Value<int>? recordId,
    Value<double>? liters,
    Value<double>? pricePerLiter,
    Value<bool>? fullTank,
  }) {
    return FuelDetailsCompanion(
      recordId: recordId ?? this.recordId,
      liters: liters ?? this.liters,
      pricePerLiter: pricePerLiter ?? this.pricePerLiter,
      fullTank: fullTank ?? this.fullTank,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (liters.present) {
      map['liters'] = Variable<double>(liters.value);
    }
    if (pricePerLiter.present) {
      map['price_per_liter'] = Variable<double>(pricePerLiter.value);
    }
    if (fullTank.present) {
      map['full_tank'] = Variable<bool>(fullTank.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelDetailsCompanion(')
          ..write('recordId: $recordId, ')
          ..write('liters: $liters, ')
          ..write('pricePerLiter: $pricePerLiter, ')
          ..write('fullTank: $fullTank')
          ..write(')'))
        .toString();
  }
}

class $RecordItemsTable extends RecordItems
    with TableInfo<$RecordItemsTable, RecordItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_records (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ItemKind>($RecordItemsTable.$converterkind);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partNumberMeta = const VerificationMeta(
    'partNumber',
  );
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
    'part_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordId,
    kind,
    name,
    partNumber,
    cost,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('part_number')) {
      context.handle(
        _partNumberMeta,
        partNumber.isAcceptableOrUnknown(data['part_number']!, _partNumberMeta),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      )!,
      kind: $RecordItemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      partNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_number'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $RecordItemsTable createAlias(String alias) {
    return $RecordItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemKind, String, String> $converterkind =
      const EnumNameConverter<ItemKind>(ItemKind.values);
}

class RecordItem extends DataClass implements Insertable<RecordItem> {
  final int id;
  final int recordId;
  final ItemKind kind;
  final String name;
  final String? partNumber;
  final double? cost;
  final int position;
  const RecordItem({
    required this.id,
    required this.recordId,
    required this.kind,
    required this.name,
    this.partNumber,
    this.cost,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['record_id'] = Variable<int>(recordId);
    {
      map['kind'] = Variable<String>(
        $RecordItemsTable.$converterkind.toSql(kind),
      );
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || partNumber != null) {
      map['part_number'] = Variable<String>(partNumber);
    }
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  RecordItemsCompanion toCompanion(bool nullToAbsent) {
    return RecordItemsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      kind: Value(kind),
      name: Value(name),
      partNumber: partNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(partNumber),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      position: Value(position),
    );
  }

  factory RecordItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordItem(
      id: serializer.fromJson<int>(json['id']),
      recordId: serializer.fromJson<int>(json['recordId']),
      kind: $RecordItemsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      name: serializer.fromJson<String>(json['name']),
      partNumber: serializer.fromJson<String?>(json['partNumber']),
      cost: serializer.fromJson<double?>(json['cost']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordId': serializer.toJson<int>(recordId),
      'kind': serializer.toJson<String>(
        $RecordItemsTable.$converterkind.toJson(kind),
      ),
      'name': serializer.toJson<String>(name),
      'partNumber': serializer.toJson<String?>(partNumber),
      'cost': serializer.toJson<double?>(cost),
      'position': serializer.toJson<int>(position),
    };
  }

  RecordItem copyWith({
    int? id,
    int? recordId,
    ItemKind? kind,
    String? name,
    Value<String?> partNumber = const Value.absent(),
    Value<double?> cost = const Value.absent(),
    int? position,
  }) => RecordItem(
    id: id ?? this.id,
    recordId: recordId ?? this.recordId,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    partNumber: partNumber.present ? partNumber.value : this.partNumber,
    cost: cost.present ? cost.value : this.cost,
    position: position ?? this.position,
  );
  RecordItem copyWithCompanion(RecordItemsCompanion data) {
    return RecordItem(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      partNumber: data.partNumber.present
          ? data.partNumber.value
          : this.partNumber,
      cost: data.cost.present ? data.cost.value : this.cost,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordItem(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('partNumber: $partNumber, ')
          ..write('cost: $cost, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordId, kind, name, partNumber, cost, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordItem &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.partNumber == this.partNumber &&
          other.cost == this.cost &&
          other.position == this.position);
}

class RecordItemsCompanion extends UpdateCompanion<RecordItem> {
  final Value<int> id;
  final Value<int> recordId;
  final Value<ItemKind> kind;
  final Value<String> name;
  final Value<String?> partNumber;
  final Value<double?> cost;
  final Value<int> position;
  const RecordItemsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.cost = const Value.absent(),
    this.position = const Value.absent(),
  });
  RecordItemsCompanion.insert({
    this.id = const Value.absent(),
    required int recordId,
    required ItemKind kind,
    required String name,
    this.partNumber = const Value.absent(),
    this.cost = const Value.absent(),
    this.position = const Value.absent(),
  }) : recordId = Value(recordId),
       kind = Value(kind),
       name = Value(name);
  static Insertable<RecordItem> custom({
    Expression<int>? id,
    Expression<int>? recordId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? partNumber,
    Expression<double>? cost,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (partNumber != null) 'part_number': partNumber,
      if (cost != null) 'cost': cost,
      if (position != null) 'position': position,
    });
  }

  RecordItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? recordId,
    Value<ItemKind>? kind,
    Value<String>? name,
    Value<String?>? partNumber,
    Value<double?>? cost,
    Value<int>? position,
  }) {
    return RecordItemsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      partNumber: partNumber ?? this.partNumber,
      cost: cost ?? this.cost,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $RecordItemsTable.$converterkind.toSql(kind.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordItemsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('partNumber: $partNumber, ')
          ..write('cost: $cost, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceTasksTable extends MaintenanceTasks
    with TableInfo<$MaintenanceTasksTable, MaintenanceTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalKmMeta = const VerificationMeta(
    'intervalKm',
  );
  @override
  late final GeneratedColumn<int> intervalKm = GeneratedColumn<int>(
    'interval_km',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneOdoMeta = const VerificationMeta(
    'lastDoneOdo',
  );
  @override
  late final GeneratedColumn<int> lastDoneOdo = GeneratedColumn<int>(
    'last_done_odo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneDateMeta = const VerificationMeta(
    'lastDoneDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastDoneDate = GeneratedColumn<DateTime>(
    'last_done_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueOdoMeta = const VerificationMeta('dueOdo');
  @override
  late final GeneratedColumn<int> dueOdo = GeneratedColumn<int>(
    'due_odo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindBeforeKmMeta = const VerificationMeta(
    'remindBeforeKm',
  );
  @override
  late final GeneratedColumn<int> remindBeforeKm = GeneratedColumn<int>(
    'remind_before_km',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(500),
  );
  static const VerificationMeta _remindBeforeDaysMeta = const VerificationMeta(
    'remindBeforeDays',
  );
  @override
  late final GeneratedColumn<int> remindBeforeDays = GeneratedColumn<int>(
    'remind_before_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(14),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    title,
    intervalKm,
    intervalDays,
    lastDoneOdo,
    lastDoneDate,
    dueOdo,
    dueDate,
    remindBeforeKm,
    remindBeforeDays,
    note,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('interval_km')) {
      context.handle(
        _intervalKmMeta,
        intervalKm.isAcceptableOrUnknown(data['interval_km']!, _intervalKmMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_done_odo')) {
      context.handle(
        _lastDoneOdoMeta,
        lastDoneOdo.isAcceptableOrUnknown(
          data['last_done_odo']!,
          _lastDoneOdoMeta,
        ),
      );
    }
    if (data.containsKey('last_done_date')) {
      context.handle(
        _lastDoneDateMeta,
        lastDoneDate.isAcceptableOrUnknown(
          data['last_done_date']!,
          _lastDoneDateMeta,
        ),
      );
    }
    if (data.containsKey('due_odo')) {
      context.handle(
        _dueOdoMeta,
        dueOdo.isAcceptableOrUnknown(data['due_odo']!, _dueOdoMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('remind_before_km')) {
      context.handle(
        _remindBeforeKmMeta,
        remindBeforeKm.isAcceptableOrUnknown(
          data['remind_before_km']!,
          _remindBeforeKmMeta,
        ),
      );
    }
    if (data.containsKey('remind_before_days')) {
      context.handle(
        _remindBeforeDaysMeta,
        remindBeforeDays.isAcceptableOrUnknown(
          data['remind_before_days']!,
          _remindBeforeDaysMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      intervalKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_km'],
      ),
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      ),
      lastDoneOdo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_done_odo'],
      ),
      lastDoneDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_done_date'],
      ),
      dueOdo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_odo'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      remindBeforeKm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_before_km'],
      )!,
      remindBeforeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_before_days'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MaintenanceTasksTable createAlias(String alias) {
    return $MaintenanceTasksTable(attachedDatabase, alias);
  }
}

class MaintenanceTask extends DataClass implements Insertable<MaintenanceTask> {
  final int id;
  final int vehicleId;
  final String title;
  final int? intervalKm;
  final int? intervalDays;
  final int? lastDoneOdo;
  final DateTime? lastDoneDate;
  final int? dueOdo;
  final DateTime? dueDate;
  final int remindBeforeKm;
  final int remindBeforeDays;
  final String? note;

  /// One-off tasks become inactive once completed.
  final bool isActive;
  final DateTime createdAt;
  const MaintenanceTask({
    required this.id,
    required this.vehicleId,
    required this.title,
    this.intervalKm,
    this.intervalDays,
    this.lastDoneOdo,
    this.lastDoneDate,
    this.dueOdo,
    this.dueDate,
    required this.remindBeforeKm,
    required this.remindBeforeDays,
    this.note,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || intervalKm != null) {
      map['interval_km'] = Variable<int>(intervalKm);
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || lastDoneOdo != null) {
      map['last_done_odo'] = Variable<int>(lastDoneOdo);
    }
    if (!nullToAbsent || lastDoneDate != null) {
      map['last_done_date'] = Variable<DateTime>(lastDoneDate);
    }
    if (!nullToAbsent || dueOdo != null) {
      map['due_odo'] = Variable<int>(dueOdo);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['remind_before_km'] = Variable<int>(remindBeforeKm);
    map['remind_before_days'] = Variable<int>(remindBeforeDays);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MaintenanceTasksCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceTasksCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      title: Value(title),
      intervalKm: intervalKm == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalKm),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      lastDoneOdo: lastDoneOdo == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneOdo),
      lastDoneDate: lastDoneDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneDate),
      dueOdo: dueOdo == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOdo),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      remindBeforeKm: Value(remindBeforeKm),
      remindBeforeDays: Value(remindBeforeDays),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory MaintenanceTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceTask(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      title: serializer.fromJson<String>(json['title']),
      intervalKm: serializer.fromJson<int?>(json['intervalKm']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      lastDoneOdo: serializer.fromJson<int?>(json['lastDoneOdo']),
      lastDoneDate: serializer.fromJson<DateTime?>(json['lastDoneDate']),
      dueOdo: serializer.fromJson<int?>(json['dueOdo']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      remindBeforeKm: serializer.fromJson<int>(json['remindBeforeKm']),
      remindBeforeDays: serializer.fromJson<int>(json['remindBeforeDays']),
      note: serializer.fromJson<String?>(json['note']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'title': serializer.toJson<String>(title),
      'intervalKm': serializer.toJson<int?>(intervalKm),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'lastDoneOdo': serializer.toJson<int?>(lastDoneOdo),
      'lastDoneDate': serializer.toJson<DateTime?>(lastDoneDate),
      'dueOdo': serializer.toJson<int?>(dueOdo),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'remindBeforeKm': serializer.toJson<int>(remindBeforeKm),
      'remindBeforeDays': serializer.toJson<int>(remindBeforeDays),
      'note': serializer.toJson<String?>(note),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MaintenanceTask copyWith({
    int? id,
    int? vehicleId,
    String? title,
    Value<int?> intervalKm = const Value.absent(),
    Value<int?> intervalDays = const Value.absent(),
    Value<int?> lastDoneOdo = const Value.absent(),
    Value<DateTime?> lastDoneDate = const Value.absent(),
    Value<int?> dueOdo = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    int? remindBeforeKm,
    int? remindBeforeDays,
    Value<String?> note = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => MaintenanceTask(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    title: title ?? this.title,
    intervalKm: intervalKm.present ? intervalKm.value : this.intervalKm,
    intervalDays: intervalDays.present ? intervalDays.value : this.intervalDays,
    lastDoneOdo: lastDoneOdo.present ? lastDoneOdo.value : this.lastDoneOdo,
    lastDoneDate: lastDoneDate.present ? lastDoneDate.value : this.lastDoneDate,
    dueOdo: dueOdo.present ? dueOdo.value : this.dueOdo,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    remindBeforeKm: remindBeforeKm ?? this.remindBeforeKm,
    remindBeforeDays: remindBeforeDays ?? this.remindBeforeDays,
    note: note.present ? note.value : this.note,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  MaintenanceTask copyWithCompanion(MaintenanceTasksCompanion data) {
    return MaintenanceTask(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      title: data.title.present ? data.title.value : this.title,
      intervalKm: data.intervalKm.present
          ? data.intervalKm.value
          : this.intervalKm,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      lastDoneOdo: data.lastDoneOdo.present
          ? data.lastDoneOdo.value
          : this.lastDoneOdo,
      lastDoneDate: data.lastDoneDate.present
          ? data.lastDoneDate.value
          : this.lastDoneDate,
      dueOdo: data.dueOdo.present ? data.dueOdo.value : this.dueOdo,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      remindBeforeKm: data.remindBeforeKm.present
          ? data.remindBeforeKm.value
          : this.remindBeforeKm,
      remindBeforeDays: data.remindBeforeDays.present
          ? data.remindBeforeDays.value
          : this.remindBeforeDays,
      note: data.note.present ? data.note.value : this.note,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceTask(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastDoneOdo: $lastDoneOdo, ')
          ..write('lastDoneDate: $lastDoneDate, ')
          ..write('dueOdo: $dueOdo, ')
          ..write('dueDate: $dueDate, ')
          ..write('remindBeforeKm: $remindBeforeKm, ')
          ..write('remindBeforeDays: $remindBeforeDays, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    title,
    intervalKm,
    intervalDays,
    lastDoneOdo,
    lastDoneDate,
    dueOdo,
    dueDate,
    remindBeforeKm,
    remindBeforeDays,
    note,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceTask &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.title == this.title &&
          other.intervalKm == this.intervalKm &&
          other.intervalDays == this.intervalDays &&
          other.lastDoneOdo == this.lastDoneOdo &&
          other.lastDoneDate == this.lastDoneDate &&
          other.dueOdo == this.dueOdo &&
          other.dueDate == this.dueDate &&
          other.remindBeforeKm == this.remindBeforeKm &&
          other.remindBeforeDays == this.remindBeforeDays &&
          other.note == this.note &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class MaintenanceTasksCompanion extends UpdateCompanion<MaintenanceTask> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<String> title;
  final Value<int?> intervalKm;
  final Value<int?> intervalDays;
  final Value<int?> lastDoneOdo;
  final Value<DateTime?> lastDoneDate;
  final Value<int?> dueOdo;
  final Value<DateTime?> dueDate;
  final Value<int> remindBeforeKm;
  final Value<int> remindBeforeDays;
  final Value<String?> note;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const MaintenanceTasksCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.title = const Value.absent(),
    this.intervalKm = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastDoneOdo = const Value.absent(),
    this.lastDoneDate = const Value.absent(),
    this.dueOdo = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.remindBeforeKm = const Value.absent(),
    this.remindBeforeDays = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MaintenanceTasksCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    required String title,
    this.intervalKm = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastDoneOdo = const Value.absent(),
    this.lastDoneDate = const Value.absent(),
    this.dueOdo = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.remindBeforeKm = const Value.absent(),
    this.remindBeforeDays = const Value.absent(),
    this.note = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       title = Value(title);
  static Insertable<MaintenanceTask> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? title,
    Expression<int>? intervalKm,
    Expression<int>? intervalDays,
    Expression<int>? lastDoneOdo,
    Expression<DateTime>? lastDoneDate,
    Expression<int>? dueOdo,
    Expression<DateTime>? dueDate,
    Expression<int>? remindBeforeKm,
    Expression<int>? remindBeforeDays,
    Expression<String>? note,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (title != null) 'title': title,
      if (intervalKm != null) 'interval_km': intervalKm,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastDoneOdo != null) 'last_done_odo': lastDoneOdo,
      if (lastDoneDate != null) 'last_done_date': lastDoneDate,
      if (dueOdo != null) 'due_odo': dueOdo,
      if (dueDate != null) 'due_date': dueDate,
      if (remindBeforeKm != null) 'remind_before_km': remindBeforeKm,
      if (remindBeforeDays != null) 'remind_before_days': remindBeforeDays,
      if (note != null) 'note': note,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MaintenanceTasksCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<String>? title,
    Value<int?>? intervalKm,
    Value<int?>? intervalDays,
    Value<int?>? lastDoneOdo,
    Value<DateTime?>? lastDoneDate,
    Value<int?>? dueOdo,
    Value<DateTime?>? dueDate,
    Value<int>? remindBeforeKm,
    Value<int>? remindBeforeDays,
    Value<String?>? note,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return MaintenanceTasksCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      intervalKm: intervalKm ?? this.intervalKm,
      intervalDays: intervalDays ?? this.intervalDays,
      lastDoneOdo: lastDoneOdo ?? this.lastDoneOdo,
      lastDoneDate: lastDoneDate ?? this.lastDoneDate,
      dueOdo: dueOdo ?? this.dueOdo,
      dueDate: dueDate ?? this.dueDate,
      remindBeforeKm: remindBeforeKm ?? this.remindBeforeKm,
      remindBeforeDays: remindBeforeDays ?? this.remindBeforeDays,
      note: note ?? this.note,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (intervalKm.present) {
      map['interval_km'] = Variable<int>(intervalKm.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastDoneOdo.present) {
      map['last_done_odo'] = Variable<int>(lastDoneOdo.value);
    }
    if (lastDoneDate.present) {
      map['last_done_date'] = Variable<DateTime>(lastDoneDate.value);
    }
    if (dueOdo.present) {
      map['due_odo'] = Variable<int>(dueOdo.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (remindBeforeKm.present) {
      map['remind_before_km'] = Variable<int>(remindBeforeKm.value);
    }
    if (remindBeforeDays.present) {
      map['remind_before_days'] = Variable<int>(remindBeforeDays.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceTasksCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('intervalKm: $intervalKm, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastDoneOdo: $lastDoneOdo, ')
          ..write('lastDoneDate: $lastDoneDate, ')
          ..write('dueOdo: $dueOdo, ')
          ..write('dueDate: $dueDate, ')
          ..write('remindBeforeKm: $remindBeforeKm, ')
          ..write('remindBeforeDays: $remindBeforeDays, ')
          ..write('note: $note, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecordTasksTable extends RecordTasks
    with TableInfo<$RecordTasksTable, RecordTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES maintenance_tasks (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [recordId, taskId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordTask> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordId, taskId};
  @override
  RecordTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordTask(
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
    );
  }

  @override
  $RecordTasksTable createAlias(String alias) {
    return $RecordTasksTable(attachedDatabase, alias);
  }
}

class RecordTask extends DataClass implements Insertable<RecordTask> {
  final int recordId;
  final int taskId;
  const RecordTask({required this.recordId, required this.taskId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['record_id'] = Variable<int>(recordId);
    map['task_id'] = Variable<int>(taskId);
    return map;
  }

  RecordTasksCompanion toCompanion(bool nullToAbsent) {
    return RecordTasksCompanion(
      recordId: Value(recordId),
      taskId: Value(taskId),
    );
  }

  factory RecordTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordTask(
      recordId: serializer.fromJson<int>(json['recordId']),
      taskId: serializer.fromJson<int>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recordId': serializer.toJson<int>(recordId),
      'taskId': serializer.toJson<int>(taskId),
    };
  }

  RecordTask copyWith({int? recordId, int? taskId}) => RecordTask(
    recordId: recordId ?? this.recordId,
    taskId: taskId ?? this.taskId,
  );
  RecordTask copyWithCompanion(RecordTasksCompanion data) {
    return RecordTask(
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordTask(')
          ..write('recordId: $recordId, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recordId, taskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordTask &&
          other.recordId == this.recordId &&
          other.taskId == this.taskId);
}

class RecordTasksCompanion extends UpdateCompanion<RecordTask> {
  final Value<int> recordId;
  final Value<int> taskId;
  final Value<int> rowid;
  const RecordTasksCompanion({
    this.recordId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordTasksCompanion.insert({
    required int recordId,
    required int taskId,
    this.rowid = const Value.absent(),
  }) : recordId = Value(recordId),
       taskId = Value(taskId);
  static Insertable<RecordTask> custom({
    Expression<int>? recordId,
    Expression<int>? taskId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordId != null) 'record_id': recordId,
      if (taskId != null) 'task_id': taskId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordTasksCompanion copyWith({
    Value<int>? recordId,
    Value<int>? taskId,
    Value<int>? rowid,
  }) {
    return RecordTasksCompanion(
      recordId: recordId ?? this.recordId,
      taskId: taskId ?? this.taskId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordTasksCompanion(')
          ..write('recordId: $recordId, ')
          ..write('taskId: $taskId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindAtMeta = const VerificationMeta(
    'remindAt',
  );
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
    'remind_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RepeatRule, String> repeat =
      GeneratedColumn<String>(
        'repeat',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(RepeatRule.none.name),
      ).withConverter<RepeatRule>($RemindersTable.$converterrepeat);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    title,
    note,
    remindAt,
    repeat,
    isDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    } else if (isInserting) {
      context.missing(_remindAtMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remind_at'],
      )!,
      repeat: $RemindersTable.$converterrepeat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}repeat'],
        )!,
      ),
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RepeatRule, String, String> $converterrepeat =
      const EnumNameConverter<RepeatRule>(RepeatRule.values);
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;
  final int? vehicleId;
  final String title;
  final String? note;
  final DateTime remindAt;
  final RepeatRule repeat;
  final bool isDone;
  const Reminder({
    required this.id,
    this.vehicleId,
    required this.title,
    this.note,
    required this.remindAt,
    required this.repeat,
    required this.isDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || vehicleId != null) {
      map['vehicle_id'] = Variable<int>(vehicleId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['remind_at'] = Variable<DateTime>(remindAt);
    {
      map['repeat'] = Variable<String>(
        $RemindersTable.$converterrepeat.toSql(repeat),
      );
    }
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      vehicleId: vehicleId == null && nullToAbsent
          ? const Value.absent()
          : Value(vehicleId),
      title: Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      remindAt: Value(remindAt),
      repeat: Value(repeat),
      isDone: Value(isDone),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int?>(json['vehicleId']),
      title: serializer.fromJson<String>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      repeat: $RemindersTable.$converterrepeat.fromJson(
        serializer.fromJson<String>(json['repeat']),
      ),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int?>(vehicleId),
      'title': serializer.toJson<String>(title),
      'note': serializer.toJson<String?>(note),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'repeat': serializer.toJson<String>(
        $RemindersTable.$converterrepeat.toJson(repeat),
      ),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  Reminder copyWith({
    int? id,
    Value<int?> vehicleId = const Value.absent(),
    String? title,
    Value<String?> note = const Value.absent(),
    DateTime? remindAt,
    RepeatRule? repeat,
    bool? isDone,
  }) => Reminder(
    id: id ?? this.id,
    vehicleId: vehicleId.present ? vehicleId.value : this.vehicleId,
    title: title ?? this.title,
    note: note.present ? note.value : this.note,
    remindAt: remindAt ?? this.remindAt,
    repeat: repeat ?? this.repeat,
    isDone: isDone ?? this.isDone,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('remindAt: $remindAt, ')
          ..write('repeat: $repeat, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, vehicleId, title, note, remindAt, repeat, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.title == this.title &&
          other.note == this.note &&
          other.remindAt == this.remindAt &&
          other.repeat == this.repeat &&
          other.isDone == this.isDone);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<int?> vehicleId;
  final Value<String> title;
  final Value<String?> note;
  final Value<DateTime> remindAt;
  final Value<RepeatRule> repeat;
  final Value<bool> isDone;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.repeat = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    required String title,
    this.note = const Value.absent(),
    required DateTime remindAt,
    this.repeat = const Value.absent(),
    this.isDone = const Value.absent(),
  }) : title = Value(title),
       remindAt = Value(remindAt);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<String>? title,
    Expression<String>? note,
    Expression<DateTime>? remindAt,
    Expression<String>? repeat,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (remindAt != null) 'remind_at': remindAt,
      if (repeat != null) 'repeat': repeat,
      if (isDone != null) 'is_done': isDone,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<int?>? vehicleId,
    Value<String>? title,
    Value<String?>? note,
    Value<DateTime>? remindAt,
    Value<RepeatRule>? repeat,
    Value<bool>? isDone,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      title: title ?? this.title,
      note: note ?? this.note,
      remindAt: remindAt ?? this.remindAt,
      repeat: repeat ?? this.repeat,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(
        $RemindersTable.$converterrepeat.toSql(repeat.value),
      );
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('remindAt: $remindAt, ')
          ..write('repeat: $repeat, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $AttachmentsTable extends Attachments
    with TableInfo<$AttachmentsTable, Attachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<int> recordId = GeneratedColumn<int>(
    'record_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DocType, String> docType =
      GeneratedColumn<String>(
        'doc_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DocType>($AttachmentsTable.$converterdocType);
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    recordId,
    fileName,
    docType,
    caption,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Attachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_id'],
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      docType: $AttachmentsTable.$converterdocType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}doc_type'],
        )!,
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AttachmentsTable createAlias(String alias) {
    return $AttachmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DocType, String, String> $converterdocType =
      const EnumNameConverter<DocType>(DocType.values);
}

class Attachment extends DataClass implements Insertable<Attachment> {
  final int id;
  final int vehicleId;
  final int? recordId;

  /// File name inside the receipts directory, not a full path, so that
  /// backups can be restored on another device.
  final String fileName;
  final DocType docType;
  final String? caption;
  final DateTime createdAt;
  const Attachment({
    required this.id,
    required this.vehicleId,
    this.recordId,
    required this.fileName,
    required this.docType,
    this.caption,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehicle_id'] = Variable<int>(vehicleId);
    if (!nullToAbsent || recordId != null) {
      map['record_id'] = Variable<int>(recordId);
    }
    map['file_name'] = Variable<String>(fileName);
    {
      map['doc_type'] = Variable<String>(
        $AttachmentsTable.$converterdocType.toSql(docType),
      );
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AttachmentsCompanion toCompanion(bool nullToAbsent) {
    return AttachmentsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      recordId: recordId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordId),
      fileName: Value(fileName),
      docType: Value(docType),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      createdAt: Value(createdAt),
    );
  }

  factory Attachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attachment(
      id: serializer.fromJson<int>(json['id']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      recordId: serializer.fromJson<int?>(json['recordId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      docType: $AttachmentsTable.$converterdocType.fromJson(
        serializer.fromJson<String>(json['docType']),
      ),
      caption: serializer.fromJson<String?>(json['caption']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'recordId': serializer.toJson<int?>(recordId),
      'fileName': serializer.toJson<String>(fileName),
      'docType': serializer.toJson<String>(
        $AttachmentsTable.$converterdocType.toJson(docType),
      ),
      'caption': serializer.toJson<String?>(caption),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Attachment copyWith({
    int? id,
    int? vehicleId,
    Value<int?> recordId = const Value.absent(),
    String? fileName,
    DocType? docType,
    Value<String?> caption = const Value.absent(),
    DateTime? createdAt,
  }) => Attachment(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    recordId: recordId.present ? recordId.value : this.recordId,
    fileName: fileName ?? this.fileName,
    docType: docType ?? this.docType,
    caption: caption.present ? caption.value : this.caption,
    createdAt: createdAt ?? this.createdAt,
  );
  Attachment copyWithCompanion(AttachmentsCompanion data) {
    return Attachment(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      docType: data.docType.present ? data.docType.value : this.docType,
      caption: data.caption.present ? data.caption.value : this.caption,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attachment(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('recordId: $recordId, ')
          ..write('fileName: $fileName, ')
          ..write('docType: $docType, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    recordId,
    fileName,
    docType,
    caption,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attachment &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.recordId == this.recordId &&
          other.fileName == this.fileName &&
          other.docType == this.docType &&
          other.caption == this.caption &&
          other.createdAt == this.createdAt);
}

class AttachmentsCompanion extends UpdateCompanion<Attachment> {
  final Value<int> id;
  final Value<int> vehicleId;
  final Value<int?> recordId;
  final Value<String> fileName;
  final Value<DocType> docType;
  final Value<String?> caption;
  final Value<DateTime> createdAt;
  const AttachmentsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.recordId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.docType = const Value.absent(),
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required int vehicleId,
    this.recordId = const Value.absent(),
    required String fileName,
    required DocType docType,
    this.caption = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : vehicleId = Value(vehicleId),
       fileName = Value(fileName),
       docType = Value(docType);
  static Insertable<Attachment> custom({
    Expression<int>? id,
    Expression<int>? vehicleId,
    Expression<int>? recordId,
    Expression<String>? fileName,
    Expression<String>? docType,
    Expression<String>? caption,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (recordId != null) 'record_id': recordId,
      if (fileName != null) 'file_name': fileName,
      if (docType != null) 'doc_type': docType,
      if (caption != null) 'caption': caption,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AttachmentsCompanion copyWith({
    Value<int>? id,
    Value<int>? vehicleId,
    Value<int?>? recordId,
    Value<String>? fileName,
    Value<DocType>? docType,
    Value<String?>? caption,
    Value<DateTime>? createdAt,
  }) {
    return AttachmentsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      recordId: recordId ?? this.recordId,
      fileName: fileName ?? this.fileName,
      docType: docType ?? this.docType,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<int>(recordId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (docType.present) {
      map['doc_type'] = Variable<String>(
        $AttachmentsTable.$converterdocType.toSql(docType.value),
      );
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('recordId: $recordId, ')
          ..write('fileName: $fileName, ')
          ..write('docType: $docType, ')
          ..write('caption: $caption, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $OdometerLogsTable odometerLogs = $OdometerLogsTable(this);
  late final $ServiceRecordsTable serviceRecords = $ServiceRecordsTable(this);
  late final $FuelDetailsTable fuelDetails = $FuelDetailsTable(this);
  late final $RecordItemsTable recordItems = $RecordItemsTable(this);
  late final $MaintenanceTasksTable maintenanceTasks = $MaintenanceTasksTable(
    this,
  );
  late final $RecordTasksTable recordTasks = $RecordTasksTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $AttachmentsTable attachments = $AttachmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    odometerLogs,
    serviceRecords,
    fuelDetails,
    recordItems,
    maintenanceTasks,
    recordTasks,
    reminders,
    attachments,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('odometer_logs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('service_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('fuel_details', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('record_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('maintenance_tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('record_tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'maintenance_tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('record_tasks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reminders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attachments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attachments', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  required String brand,
  required String model,
  Value<int?> year,
  Value<String?> plate,
  Value<String?> vin,
  Value<int> currentOdo,
  Value<String?> photoFileName,
  Value<DateTime> createdAt,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  Value<String> brand,
  Value<String> model,
  Value<int?> year,
  Value<String?> plate,
  Value<String?> vin,
  Value<int> currentOdo,
  Value<String?> photoFileName,
  Value<DateTime> createdAt,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OdometerLogsTable, List<OdometerLog>>
  _odometerLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.odometerLogs,
    aliasName: 'vehicles__id__odometer_logs__vehicle_id',
  );

  $$OdometerLogsTableProcessedTableManager get odometerLogsRefs {
    final manager = $$OdometerLogsTableTableManager(
      $_db,
      $_db.odometerLogs,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_odometerLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ServiceRecordsTable, List<ServiceRecord>>
  _serviceRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.serviceRecords,
    aliasName: 'vehicles__id__service_records__vehicle_id',
  );

  $$ServiceRecordsTableProcessedTableManager get serviceRecordsRefs {
    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_serviceRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaintenanceTasksTable, List<MaintenanceTask>>
  _maintenanceTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.maintenanceTasks,
    aliasName: 'vehicles__id__maintenance_tasks__vehicle_id',
  );

  $$MaintenanceTasksTableProcessedTableManager get maintenanceTasksRefs {
    final manager = $$MaintenanceTasksTableTableManager(
      $_db,
      $_db.maintenanceTasks,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceTasksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
  _remindersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reminders,
    aliasName: 'vehicles__id__reminders__vehicle_id',
  );

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager(
      $_db,
      $_db.reminders,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttachmentsTable, List<Attachment>>
  _attachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: 'vehicles__id__attachments__vehicle_id',
  );

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentOdo => $composableBuilder(
    column: $table.currentOdo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoFileName => $composableBuilder(
    column: $table.photoFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> odometerLogsRefs(
    Expression<bool> Function($$OdometerLogsTableFilterComposer f) f,
  ) {
    final $$OdometerLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.odometerLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OdometerLogsTableFilterComposer(
            $db: $db,
            $table: $db.odometerLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> serviceRecordsRefs(
    Expression<bool> Function($$ServiceRecordsTableFilterComposer f) f,
  ) {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenanceTasksRefs(
    Expression<bool> Function($$MaintenanceTasksTableFilterComposer f) f,
  ) {
    final $$MaintenanceTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceTasks,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceTasksTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> remindersRefs(
    Expression<bool> Function($$RemindersTableFilterComposer f) f,
  ) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableFilterComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($$AttachmentsTableFilterComposer f) f,
  ) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentOdo => $composableBuilder(
    column: $table.currentOdo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoFileName => $composableBuilder(
    column: $table.photoFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<int> get currentOdo => $composableBuilder(
    column: $table.currentOdo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoFileName => $composableBuilder(
    column: $table.photoFileName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> odometerLogsRefs<T extends Object>(
    Expression<T> Function($$OdometerLogsTableAnnotationComposer a) f,
  ) {
    final $$OdometerLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.odometerLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OdometerLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.odometerLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> serviceRecordsRefs<T extends Object>(
    Expression<T> Function($$ServiceRecordsTableAnnotationComposer a) f,
  ) {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> maintenanceTasksRefs<T extends Object>(
    Expression<T> Function($$MaintenanceTasksTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceTasks,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenanceTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
    Expression<T> Function($$RemindersTableAnnotationComposer a) f,
  ) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reminders,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RemindersTableAnnotationComposer(
            $db: $db,
            $table: $db.reminders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($$AttachmentsTableAnnotationComposer a) f,
  ) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({
            bool odometerLogsRefs,
            bool serviceRecordsRefs,
            bool maintenanceTasksRefs,
            bool remindersRefs,
            bool attachmentsRefs,
          })
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<int> currentOdo = const Value.absent(),
                Value<String?> photoFileName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                currentOdo: currentOdo,
                photoFileName: photoFileName,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String brand,
                required String model,
                Value<int?> year = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<int> currentOdo = const Value.absent(),
                Value<String?> photoFileName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                currentOdo: currentOdo,
                photoFileName: photoFileName,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiclesTable, Vehicle>(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                odometerLogsRefs = false,
                serviceRecordsRefs = false,
                maintenanceTasksRefs = false,
                remindersRefs = false,
                attachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (odometerLogsRefs) db.odometerLogs,
                    if (serviceRecordsRefs) db.serviceRecords,
                    if (maintenanceTasksRefs) db.maintenanceTasks,
                    if (remindersRefs) db.reminders,
                    if (attachmentsRefs) db.attachments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (odometerLogsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          OdometerLog
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._odometerLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).odometerLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (serviceRecordsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          ServiceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._serviceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).serviceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (maintenanceTasksRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          MaintenanceTask
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (remindersRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          Reminder
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._remindersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).remindersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attachmentsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          Attachment
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).attachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({
        bool odometerLogsRefs,
        bool serviceRecordsRefs,
        bool maintenanceTasksRefs,
        bool remindersRefs,
        bool attachmentsRefs,
      })
    >;
typedef $$OdometerLogsTableCreateCompanionBuilder =
    OdometerLogsCompanion Function({
      Value<int> id,
      required int vehicleId,
      required DateTime date,
      required int value,
    });
typedef $$OdometerLogsTableUpdateCompanionBuilder =
    OdometerLogsCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<DateTime> date,
      Value<int> value,
    });

final class $$OdometerLogsTableReferences
    extends BaseReferences<_$AppDatabase, $OdometerLogsTable, OdometerLog> {
  $$OdometerLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('odometer_logs__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OdometerLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OdometerLogsTable> {
  $$OdometerLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OdometerLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OdometerLogsTable> {
  $$OdometerLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OdometerLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OdometerLogsTable> {
  $$OdometerLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OdometerLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OdometerLogsTable,
          OdometerLog,
          $$OdometerLogsTableFilterComposer,
          $$OdometerLogsTableOrderingComposer,
          $$OdometerLogsTableAnnotationComposer,
          $$OdometerLogsTableCreateCompanionBuilder,
          $$OdometerLogsTableUpdateCompanionBuilder,
          (OdometerLog, $$OdometerLogsTableReferences),
          OdometerLog,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$OdometerLogsTableTableManager(_$AppDatabase db, $OdometerLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OdometerLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OdometerLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OdometerLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> value = const Value.absent(),
              }) => OdometerLogsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required DateTime date,
                required int value,
              }) => OdometerLogsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OdometerLogsTable, OdometerLog>(table),
                  $$OdometerLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$OdometerLogsTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$OdometerLogsTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OdometerLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OdometerLogsTable,
      OdometerLog,
      $$OdometerLogsTableFilterComposer,
      $$OdometerLogsTableOrderingComposer,
      $$OdometerLogsTableAnnotationComposer,
      $$OdometerLogsTableCreateCompanionBuilder,
      $$OdometerLogsTableUpdateCompanionBuilder,
      (OdometerLog, $$OdometerLogsTableReferences),
      OdometerLog,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$ServiceRecordsTableCreateCompanionBuilder =
    ServiceRecordsCompanion Function({
      Value<int> id,
      required int vehicleId,
      required RecordType type,
      required DateTime date,
      required int odometer,
      required String title,
      Value<String?> station,
      Value<double?> cost,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$ServiceRecordsTableUpdateCompanionBuilder =
    ServiceRecordsCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<RecordType> type,
      Value<DateTime> date,
      Value<int> odometer,
      Value<String> title,
      Value<String?> station,
      Value<double?> cost,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$ServiceRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ServiceRecordsTable, ServiceRecord> {
  $$ServiceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('service_records__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FuelDetailsTable, List<FuelDetail>>
  _fuelDetailsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fuelDetails,
    aliasName: 'service_records__id__fuel_details__record_id',
  );

  $$FuelDetailsTableProcessedTableManager get fuelDetailsRefs {
    final manager = $$FuelDetailsTableTableManager(
      $_db,
      $_db.fuelDetails,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fuelDetailsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordItemsTable, List<RecordItem>>
  _recordItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordItems,
    aliasName: 'service_records__id__record_items__record_id',
  );

  $$RecordItemsTableProcessedTableManager get recordItemsRefs {
    final manager = $$RecordItemsTableTableManager(
      $_db,
      $_db.recordItems,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecordTasksTable, List<RecordTask>>
  _recordTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordTasks,
    aliasName: 'service_records__id__record_tasks__record_id',
  );

  $$RecordTasksTableProcessedTableManager get recordTasksRefs {
    final manager = $$RecordTasksTableTableManager(
      $_db,
      $_db.recordTasks,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttachmentsTable, List<Attachment>>
  _attachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attachments,
    aliasName: 'service_records__id__attachments__record_id',
  );

  $$AttachmentsTableProcessedTableManager get attachmentsRefs {
    final manager = $$AttachmentsTableTableManager(
      $_db,
      $_db.attachments,
    ).filter((f) => f.recordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_attachmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RecordType, RecordType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> fuelDetailsRefs(
    Expression<bool> Function($$FuelDetailsTableFilterComposer f) f,
  ) {
    final $$FuelDetailsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fuelDetails,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuelDetailsTableFilterComposer(
            $db: $db,
            $table: $db.fuelDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordItemsRefs(
    Expression<bool> Function($$RecordItemsTableFilterComposer f) f,
  ) {
    final $$RecordItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordItems,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordItemsTableFilterComposer(
            $db: $db,
            $table: $db.recordItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recordTasksRefs(
    Expression<bool> Function($$RecordTasksTableFilterComposer f) f,
  ) {
    final $$RecordTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordTasks,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordTasksTableFilterComposer(
            $db: $db,
            $table: $db.recordTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attachmentsRefs(
    Expression<bool> Function($$AttachmentsTableFilterComposer f) f,
  ) {
    final $$AttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get station => $composableBuilder(
    column: $table.station,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServiceRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceRecordsTable> {
  $$ServiceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecordType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get station =>
      $composableBuilder(column: $table.station, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> fuelDetailsRefs<T extends Object>(
    Expression<T> Function($$FuelDetailsTableAnnotationComposer a) f,
  ) {
    final $$FuelDetailsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fuelDetails,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuelDetailsTableAnnotationComposer(
            $db: $db,
            $table: $db.fuelDetails,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordItemsRefs<T extends Object>(
    Expression<T> Function($$RecordItemsTableAnnotationComposer a) f,
  ) {
    final $$RecordItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordItems,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recordItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recordTasksRefs<T extends Object>(
    Expression<T> Function($$RecordTasksTableAnnotationComposer a) f,
  ) {
    final $$RecordTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordTasks,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.recordTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attachmentsRefs<T extends Object>(
    Expression<T> Function($$AttachmentsTableAnnotationComposer a) f,
  ) {
    final $$AttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attachments,
      getReferencedColumn: (t) => t.recordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.attachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServiceRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceRecordsTable,
          ServiceRecord,
          $$ServiceRecordsTableFilterComposer,
          $$ServiceRecordsTableOrderingComposer,
          $$ServiceRecordsTableAnnotationComposer,
          $$ServiceRecordsTableCreateCompanionBuilder,
          $$ServiceRecordsTableUpdateCompanionBuilder,
          (ServiceRecord, $$ServiceRecordsTableReferences),
          ServiceRecord,
          PrefetchHooks Function({
            bool vehicleId,
            bool fuelDetailsRefs,
            bool recordItemsRefs,
            bool recordTasksRefs,
            bool attachmentsRefs,
          })
        > {
  $$ServiceRecordsTableTableManager(
    _$AppDatabase db,
    $ServiceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<RecordType> type = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> odometer = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> station = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServiceRecordsCompanion(
                id: id,
                vehicleId: vehicleId,
                type: type,
                date: date,
                odometer: odometer,
                title: title,
                station: station,
                cost: cost,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required RecordType type,
                required DateTime date,
                required int odometer,
                required String title,
                Value<String?> station = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ServiceRecordsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                type: type,
                date: date,
                odometer: odometer,
                title: title,
                station: station,
                cost: cost,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServiceRecordsTable, ServiceRecord>(table),
                  $$ServiceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                vehicleId = false,
                fuelDetailsRefs = false,
                recordItemsRefs = false,
                recordTasksRefs = false,
                attachmentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fuelDetailsRefs) db.fuelDetails,
                    if (recordItemsRefs) db.recordItems,
                    if (recordTasksRefs) db.recordTasks,
                    if (attachmentsRefs) db.attachments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.vehicleId,
                            referencedTable: $$ServiceRecordsTableReferences
                                ._vehicleIdTable(db),
                            referencedColumn: $$ServiceRecordsTableReferences
                                ._vehicleIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fuelDetailsRefs)
                        await $_getPrefetchedData<
                          ServiceRecord,
                          $ServiceRecordsTable,
                          FuelDetail
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceRecordsTableReferences
                              ._fuelDetailsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).fuelDetailsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recordItemsRefs)
                        await $_getPrefetchedData<
                          ServiceRecord,
                          $ServiceRecordsTable,
                          RecordItem
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceRecordsTableReferences
                              ._recordItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).recordItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recordTasksRefs)
                        await $_getPrefetchedData<
                          ServiceRecord,
                          $ServiceRecordsTable,
                          RecordTask
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceRecordsTableReferences
                              ._recordTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).recordTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attachmentsRefs)
                        await $_getPrefetchedData<
                          ServiceRecord,
                          $ServiceRecordsTable,
                          Attachment
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceRecordsTableReferences
                              ._attachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceRecordsTableReferences(
                                db,
                                table,
                                p0,
                              ).attachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ServiceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceRecordsTable,
      ServiceRecord,
      $$ServiceRecordsTableFilterComposer,
      $$ServiceRecordsTableOrderingComposer,
      $$ServiceRecordsTableAnnotationComposer,
      $$ServiceRecordsTableCreateCompanionBuilder,
      $$ServiceRecordsTableUpdateCompanionBuilder,
      (ServiceRecord, $$ServiceRecordsTableReferences),
      ServiceRecord,
      PrefetchHooks Function({
        bool vehicleId,
        bool fuelDetailsRefs,
        bool recordItemsRefs,
        bool recordTasksRefs,
        bool attachmentsRefs,
      })
    >;
typedef $$FuelDetailsTableCreateCompanionBuilder =
    FuelDetailsCompanion Function({
      Value<int> recordId,
      required double liters,
      required double pricePerLiter,
      Value<bool> fullTank,
    });
typedef $$FuelDetailsTableUpdateCompanionBuilder =
    FuelDetailsCompanion Function({
      Value<int> recordId,
      Value<double> liters,
      Value<double> pricePerLiter,
      Value<bool> fullTank,
    });

final class $$FuelDetailsTableReferences
    extends BaseReferences<_$AppDatabase, $FuelDetailsTable, FuelDetail> {
  $$FuelDetailsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceRecordsTable _recordIdTable(_$AppDatabase db) => db
      .serviceRecords
      .createAlias('fuel_details__record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<int>('record_id')!;

    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FuelDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelDetailsTable> {
  $$FuelDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fullTank => $composableBuilder(
    column: $table.fullTank,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceRecordsTableFilterComposer get recordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelDetailsTable> {
  $$FuelDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get liters => $composableBuilder(
    column: $table.liters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fullTank => $composableBuilder(
    column: $table.fullTank,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceRecordsTableOrderingComposer get recordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelDetailsTable> {
  $$FuelDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get liters =>
      $composableBuilder(column: $table.liters, builder: (column) => column);

  GeneratedColumn<double> get pricePerLiter => $composableBuilder(
    column: $table.pricePerLiter,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fullTank =>
      $composableBuilder(column: $table.fullTank, builder: (column) => column);

  $$ServiceRecordsTableAnnotationComposer get recordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelDetailsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelDetailsTable,
          FuelDetail,
          $$FuelDetailsTableFilterComposer,
          $$FuelDetailsTableOrderingComposer,
          $$FuelDetailsTableAnnotationComposer,
          $$FuelDetailsTableCreateCompanionBuilder,
          $$FuelDetailsTableUpdateCompanionBuilder,
          (FuelDetail, $$FuelDetailsTableReferences),
          FuelDetail,
          PrefetchHooks Function({bool recordId})
        > {
  $$FuelDetailsTableTableManager(_$AppDatabase db, $FuelDetailsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelDetailsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelDetailsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> recordId = const Value.absent(),
                Value<double> liters = const Value.absent(),
                Value<double> pricePerLiter = const Value.absent(),
                Value<bool> fullTank = const Value.absent(),
              }) => FuelDetailsCompanion(
                recordId: recordId,
                liters: liters,
                pricePerLiter: pricePerLiter,
                fullTank: fullTank,
              ),
          createCompanionCallback:
              ({
                Value<int> recordId = const Value.absent(),
                required double liters,
                required double pricePerLiter,
                Value<bool> fullTank = const Value.absent(),
              }) => FuelDetailsCompanion.insert(
                recordId: recordId,
                liters: liters,
                pricePerLiter: pricePerLiter,
                fullTank: fullTank,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FuelDetailsTable, FuelDetail>(table),
                  $$FuelDetailsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordId,
                        referencedTable: $$FuelDetailsTableReferences
                            ._recordIdTable(db),
                        referencedColumn: $$FuelDetailsTableReferences
                            ._recordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FuelDetailsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelDetailsTable,
      FuelDetail,
      $$FuelDetailsTableFilterComposer,
      $$FuelDetailsTableOrderingComposer,
      $$FuelDetailsTableAnnotationComposer,
      $$FuelDetailsTableCreateCompanionBuilder,
      $$FuelDetailsTableUpdateCompanionBuilder,
      (FuelDetail, $$FuelDetailsTableReferences),
      FuelDetail,
      PrefetchHooks Function({bool recordId})
    >;
typedef $$RecordItemsTableCreateCompanionBuilder =
    RecordItemsCompanion Function({
      Value<int> id,
      required int recordId,
      required ItemKind kind,
      required String name,
      Value<String?> partNumber,
      Value<double?> cost,
      Value<int> position,
    });
typedef $$RecordItemsTableUpdateCompanionBuilder =
    RecordItemsCompanion Function({
      Value<int> id,
      Value<int> recordId,
      Value<ItemKind> kind,
      Value<String> name,
      Value<String?> partNumber,
      Value<double?> cost,
      Value<int> position,
    });

final class $$RecordItemsTableReferences
    extends BaseReferences<_$AppDatabase, $RecordItemsTable, RecordItem> {
  $$RecordItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceRecordsTable _recordIdTable(_$AppDatabase db) => db
      .serviceRecords
      .createAlias('record_items__record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<int>('record_id')!;

    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordItemsTable> {
  $$RecordItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemKind, ItemKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceRecordsTableFilterComposer get recordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordItemsTable> {
  $$RecordItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceRecordsTableOrderingComposer get recordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordItemsTable> {
  $$RecordItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
    column: $table.partNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$ServiceRecordsTableAnnotationComposer get recordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordItemsTable,
          RecordItem,
          $$RecordItemsTableFilterComposer,
          $$RecordItemsTableOrderingComposer,
          $$RecordItemsTableAnnotationComposer,
          $$RecordItemsTableCreateCompanionBuilder,
          $$RecordItemsTableUpdateCompanionBuilder,
          (RecordItem, $$RecordItemsTableReferences),
          RecordItem,
          PrefetchHooks Function({bool recordId})
        > {
  $$RecordItemsTableTableManager(_$AppDatabase db, $RecordItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recordId = const Value.absent(),
                Value<ItemKind> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> partNumber = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => RecordItemsCompanion(
                id: id,
                recordId: recordId,
                kind: kind,
                name: name,
                partNumber: partNumber,
                cost: cost,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recordId,
                required ItemKind kind,
                required String name,
                Value<String?> partNumber = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => RecordItemsCompanion.insert(
                id: id,
                recordId: recordId,
                kind: kind,
                name: name,
                partNumber: partNumber,
                cost: cost,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordItemsTable, RecordItem>(table),
                  $$RecordItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordId,
                        referencedTable: $$RecordItemsTableReferences
                            ._recordIdTable(db),
                        referencedColumn: $$RecordItemsTableReferences
                            ._recordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecordItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordItemsTable,
      RecordItem,
      $$RecordItemsTableFilterComposer,
      $$RecordItemsTableOrderingComposer,
      $$RecordItemsTableAnnotationComposer,
      $$RecordItemsTableCreateCompanionBuilder,
      $$RecordItemsTableUpdateCompanionBuilder,
      (RecordItem, $$RecordItemsTableReferences),
      RecordItem,
      PrefetchHooks Function({bool recordId})
    >;
typedef $$MaintenanceTasksTableCreateCompanionBuilder =
    MaintenanceTasksCompanion Function({
      Value<int> id,
      required int vehicleId,
      required String title,
      Value<int?> intervalKm,
      Value<int?> intervalDays,
      Value<int?> lastDoneOdo,
      Value<DateTime?> lastDoneDate,
      Value<int?> dueOdo,
      Value<DateTime?> dueDate,
      Value<int> remindBeforeKm,
      Value<int> remindBeforeDays,
      Value<String?> note,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$MaintenanceTasksTableUpdateCompanionBuilder =
    MaintenanceTasksCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<String> title,
      Value<int?> intervalKm,
      Value<int?> intervalDays,
      Value<int?> lastDoneOdo,
      Value<DateTime?> lastDoneDate,
      Value<int?> dueOdo,
      Value<DateTime?> dueDate,
      Value<int> remindBeforeKm,
      Value<int> remindBeforeDays,
      Value<String?> note,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$MaintenanceTasksTableReferences
    extends
        BaseReferences<_$AppDatabase, $MaintenanceTasksTable, MaintenanceTask> {
  $$MaintenanceTasksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('maintenance_tasks__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecordTasksTable, List<RecordTask>>
  _recordTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recordTasks,
    aliasName: 'maintenance_tasks__id__record_tasks__task_id',
  );

  $$RecordTasksTableProcessedTableManager get recordTasksRefs {
    final manager = $$RecordTasksTableTableManager(
      $_db,
      $_db.recordTasks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recordTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MaintenanceTasksTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceTasksTable> {
  $$MaintenanceTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastDoneOdo => $composableBuilder(
    column: $table.lastDoneOdo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastDoneDate => $composableBuilder(
    column: $table.lastDoneDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueOdo => $composableBuilder(
    column: $table.dueOdo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindBeforeKm => $composableBuilder(
    column: $table.remindBeforeKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindBeforeDays => $composableBuilder(
    column: $table.remindBeforeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recordTasksRefs(
    Expression<bool> Function($$RecordTasksTableFilterComposer f) f,
  ) {
    final $$RecordTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordTasksTableFilterComposer(
            $db: $db,
            $table: $db.recordTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaintenanceTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceTasksTable> {
  $$MaintenanceTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastDoneOdo => $composableBuilder(
    column: $table.lastDoneOdo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDoneDate => $composableBuilder(
    column: $table.lastDoneDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueOdo => $composableBuilder(
    column: $table.dueOdo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindBeforeKm => $composableBuilder(
    column: $table.remindBeforeKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindBeforeDays => $composableBuilder(
    column: $table.remindBeforeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceTasksTable> {
  $$MaintenanceTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get intervalKm => $composableBuilder(
    column: $table.intervalKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastDoneOdo => $composableBuilder(
    column: $table.lastDoneOdo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastDoneDate => $composableBuilder(
    column: $table.lastDoneDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueOdo =>
      $composableBuilder(column: $table.dueOdo, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get remindBeforeKm => $composableBuilder(
    column: $table.remindBeforeKm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remindBeforeDays => $composableBuilder(
    column: $table.remindBeforeDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recordTasksRefs<T extends Object>(
    Expression<T> Function($$RecordTasksTableAnnotationComposer a) f,
  ) {
    final $$RecordTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recordTasks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecordTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.recordTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaintenanceTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceTasksTable,
          MaintenanceTask,
          $$MaintenanceTasksTableFilterComposer,
          $$MaintenanceTasksTableOrderingComposer,
          $$MaintenanceTasksTableAnnotationComposer,
          $$MaintenanceTasksTableCreateCompanionBuilder,
          $$MaintenanceTasksTableUpdateCompanionBuilder,
          (MaintenanceTask, $$MaintenanceTasksTableReferences),
          MaintenanceTask,
          PrefetchHooks Function({bool vehicleId, bool recordTasksRefs})
        > {
  $$MaintenanceTasksTableTableManager(
    _$AppDatabase db,
    $MaintenanceTasksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> intervalKm = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> lastDoneOdo = const Value.absent(),
                Value<DateTime?> lastDoneDate = const Value.absent(),
                Value<int?> dueOdo = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int> remindBeforeKm = const Value.absent(),
                Value<int> remindBeforeDays = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MaintenanceTasksCompanion(
                id: id,
                vehicleId: vehicleId,
                title: title,
                intervalKm: intervalKm,
                intervalDays: intervalDays,
                lastDoneOdo: lastDoneOdo,
                lastDoneDate: lastDoneDate,
                dueOdo: dueOdo,
                dueDate: dueDate,
                remindBeforeKm: remindBeforeKm,
                remindBeforeDays: remindBeforeDays,
                note: note,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                required String title,
                Value<int?> intervalKm = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> lastDoneOdo = const Value.absent(),
                Value<DateTime?> lastDoneDate = const Value.absent(),
                Value<int?> dueOdo = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int> remindBeforeKm = const Value.absent(),
                Value<int> remindBeforeDays = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MaintenanceTasksCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                title: title,
                intervalKm: intervalKm,
                intervalDays: intervalDays,
                lastDoneOdo: lastDoneOdo,
                lastDoneDate: lastDoneDate,
                dueOdo: dueOdo,
                dueDate: dueDate,
                remindBeforeKm: remindBeforeKm,
                remindBeforeDays: remindBeforeDays,
                note: note,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MaintenanceTasksTable, MaintenanceTask>(table),
                  $$MaintenanceTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, recordTasksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recordTasksRefs) db.recordTasks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.vehicleId,
                            referencedTable: $$MaintenanceTasksTableReferences
                                ._vehicleIdTable(db),
                            referencedColumn: $$MaintenanceTasksTableReferences
                                ._vehicleIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recordTasksRefs)
                        await $_getPrefetchedData<
                          MaintenanceTask,
                          $MaintenanceTasksTable,
                          RecordTask
                        >(
                          currentTable: table,
                          referencedTable: $$MaintenanceTasksTableReferences
                              ._recordTasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaintenanceTasksTableReferences(
                                db,
                                table,
                                p0,
                              ).recordTasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MaintenanceTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceTasksTable,
      MaintenanceTask,
      $$MaintenanceTasksTableFilterComposer,
      $$MaintenanceTasksTableOrderingComposer,
      $$MaintenanceTasksTableAnnotationComposer,
      $$MaintenanceTasksTableCreateCompanionBuilder,
      $$MaintenanceTasksTableUpdateCompanionBuilder,
      (MaintenanceTask, $$MaintenanceTasksTableReferences),
      MaintenanceTask,
      PrefetchHooks Function({bool vehicleId, bool recordTasksRefs})
    >;
typedef $$RecordTasksTableCreateCompanionBuilder =
    RecordTasksCompanion Function({
      required int recordId,
      required int taskId,
      Value<int> rowid,
    });
typedef $$RecordTasksTableUpdateCompanionBuilder =
    RecordTasksCompanion Function({
      Value<int> recordId,
      Value<int> taskId,
      Value<int> rowid,
    });

final class $$RecordTasksTableReferences
    extends BaseReferences<_$AppDatabase, $RecordTasksTable, RecordTask> {
  $$RecordTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceRecordsTable _recordIdTable(_$AppDatabase db) => db
      .serviceRecords
      .createAlias('record_tasks__record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager get recordId {
    final $_column = $_itemColumn<int>('record_id')!;

    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $MaintenanceTasksTable _taskIdTable(_$AppDatabase db) => db
      .maintenanceTasks
      .createAlias('record_tasks__task_id__maintenance_tasks__id');

  $$MaintenanceTasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<int>('task_id')!;

    final manager = $$MaintenanceTasksTableTableManager(
      $_db,
      $_db.maintenanceTasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecordTasksTableFilterComposer
    extends Composer<_$AppDatabase, $RecordTasksTable> {
  $$RecordTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ServiceRecordsTableFilterComposer get recordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MaintenanceTasksTableFilterComposer get taskId {
    final $$MaintenanceTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.maintenanceTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceTasksTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordTasksTable> {
  $$RecordTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ServiceRecordsTableOrderingComposer get recordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MaintenanceTasksTableOrderingComposer get taskId {
    final $$MaintenanceTasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.maintenanceTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceTasksTableOrderingComposer(
            $db: $db,
            $table: $db.maintenanceTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordTasksTable> {
  $$RecordTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$ServiceRecordsTableAnnotationComposer get recordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$MaintenanceTasksTableAnnotationComposer get taskId {
    final $$MaintenanceTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.maintenanceTasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenanceTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecordTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordTasksTable,
          RecordTask,
          $$RecordTasksTableFilterComposer,
          $$RecordTasksTableOrderingComposer,
          $$RecordTasksTableAnnotationComposer,
          $$RecordTasksTableCreateCompanionBuilder,
          $$RecordTasksTableUpdateCompanionBuilder,
          (RecordTask, $$RecordTasksTableReferences),
          RecordTask,
          PrefetchHooks Function({bool recordId, bool taskId})
        > {
  $$RecordTasksTableTableManager(_$AppDatabase db, $RecordTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> recordId = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordTasksCompanion(
                recordId: recordId,
                taskId: taskId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int recordId,
                required int taskId,
                Value<int> rowid = const Value.absent(),
              }) => RecordTasksCompanion.insert(
                recordId: recordId,
                taskId: taskId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecordTasksTable, RecordTask>(table),
                  $$RecordTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordId = false, taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordId,
                        referencedTable: $$RecordTasksTableReferences
                            ._recordIdTable(db),
                        referencedColumn: $$RecordTasksTableReferences
                            ._recordIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (taskId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.taskId,
                        referencedTable: $$RecordTasksTableReferences
                            ._taskIdTable(db),
                        referencedColumn: $$RecordTasksTableReferences
                            ._taskIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecordTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordTasksTable,
      RecordTask,
      $$RecordTasksTableFilterComposer,
      $$RecordTasksTableOrderingComposer,
      $$RecordTasksTableAnnotationComposer,
      $$RecordTasksTableCreateCompanionBuilder,
      $$RecordTasksTableUpdateCompanionBuilder,
      (RecordTask, $$RecordTasksTableReferences),
      RecordTask,
      PrefetchHooks Function({bool recordId, bool taskId})
    >;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int?> vehicleId,
  required String title,
  Value<String?> note,
  required DateTime remindAt,
  Value<RepeatRule> repeat,
  Value<bool> isDone,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<int> id,
  Value<int?> vehicleId,
  Value<String> title,
  Value<String?> note,
  Value<DateTime> remindAt,
  Value<RepeatRule> repeat,
  Value<bool> isDone,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('reminders__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager? get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id');
    if ($_column == null) return null;
    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RepeatRule, RepeatRule, String> get repeat =>
      $composableBuilder(
        column: $table.repeat,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RepeatRule, String> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, $$RemindersTableReferences),
          Reminder,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> vehicleId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> remindAt = const Value.absent(),
                Value<RepeatRule> repeat = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                vehicleId: vehicleId,
                title: title,
                note: note,
                remindAt: remindAt,
                repeat: repeat,
                isDone: isDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> vehicleId = const Value.absent(),
                required String title,
                Value<String?> note = const Value.absent(),
                required DateTime remindAt,
                Value<RepeatRule> repeat = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                title: title,
                note: note,
                remindAt: remindAt,
                repeat: repeat,
                isDone: isDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RemindersTable, Reminder>(table),
                  $$RemindersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$RemindersTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$RemindersTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, $$RemindersTableReferences),
      Reminder,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$AttachmentsTableCreateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      required int vehicleId,
      Value<int?> recordId,
      required String fileName,
      required DocType docType,
      Value<String?> caption,
      Value<DateTime> createdAt,
    });
typedef $$AttachmentsTableUpdateCompanionBuilder =
    AttachmentsCompanion Function({
      Value<int> id,
      Value<int> vehicleId,
      Value<int?> recordId,
      Value<String> fileName,
      Value<DocType> docType,
      Value<String?> caption,
      Value<DateTime> createdAt,
    });

final class $$AttachmentsTableReferences
    extends BaseReferences<_$AppDatabase, $AttachmentsTable, Attachment> {
  $$AttachmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('attachments__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceRecordsTable _recordIdTable(_$AppDatabase db) => db
      .serviceRecords
      .createAlias('attachments__record_id__service_records__id');

  $$ServiceRecordsTableProcessedTableManager? get recordId {
    final $_column = $_itemColumn<int>('record_id');
    if ($_column == null) return null;
    final manager = $$ServiceRecordsTableTableManager(
      $_db,
      $_db.serviceRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DocType, DocType, String> get docType =>
      $composableBuilder(
        column: $table.docType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceRecordsTableFilterComposer get recordId {
    final $$ServiceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get docType => $composableBuilder(
    column: $table.docType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceRecordsTableOrderingComposer get recordId {
    final $$ServiceRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttachmentsTable> {
  $$AttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DocType, String> get docType =>
      $composableBuilder(column: $table.docType, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceRecordsTableAnnotationComposer get recordId {
    final $$ServiceRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordId,
      referencedTable: $db.serviceRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.serviceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttachmentsTable,
          Attachment,
          $$AttachmentsTableFilterComposer,
          $$AttachmentsTableOrderingComposer,
          $$AttachmentsTableAnnotationComposer,
          $$AttachmentsTableCreateCompanionBuilder,
          $$AttachmentsTableUpdateCompanionBuilder,
          (Attachment, $$AttachmentsTableReferences),
          Attachment,
          PrefetchHooks Function({bool vehicleId, bool recordId})
        > {
  $$AttachmentsTableTableManager(_$AppDatabase db, $AttachmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<int?> recordId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<DocType> docType = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttachmentsCompanion(
                id: id,
                vehicleId: vehicleId,
                recordId: recordId,
                fileName: fileName,
                docType: docType,
                caption: caption,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int vehicleId,
                Value<int?> recordId = const Value.absent(),
                required String fileName,
                required DocType docType,
                Value<String?> caption = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AttachmentsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                recordId: recordId,
                fileName: fileName,
                docType: docType,
                caption: caption,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AttachmentsTable, Attachment>(table),
                  $$AttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false, recordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.vehicleId,
                        referencedTable: $$AttachmentsTableReferences
                            ._vehicleIdTable(db),
                        referencedColumn: $$AttachmentsTableReferences
                            ._vehicleIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (recordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordId,
                        referencedTable: $$AttachmentsTableReferences
                            ._recordIdTable(db),
                        referencedColumn: $$AttachmentsTableReferences
                            ._recordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttachmentsTable,
      Attachment,
      $$AttachmentsTableFilterComposer,
      $$AttachmentsTableOrderingComposer,
      $$AttachmentsTableAnnotationComposer,
      $$AttachmentsTableCreateCompanionBuilder,
      $$AttachmentsTableUpdateCompanionBuilder,
      (Attachment, $$AttachmentsTableReferences),
      Attachment,
      PrefetchHooks Function({bool vehicleId, bool recordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$OdometerLogsTableTableManager get odometerLogs =>
      $$OdometerLogsTableTableManager(_db, _db.odometerLogs);
  $$ServiceRecordsTableTableManager get serviceRecords =>
      $$ServiceRecordsTableTableManager(_db, _db.serviceRecords);
  $$FuelDetailsTableTableManager get fuelDetails =>
      $$FuelDetailsTableTableManager(_db, _db.fuelDetails);
  $$RecordItemsTableTableManager get recordItems =>
      $$RecordItemsTableTableManager(_db, _db.recordItems);
  $$MaintenanceTasksTableTableManager get maintenanceTasks =>
      $$MaintenanceTasksTableTableManager(_db, _db.maintenanceTasks);
  $$RecordTasksTableTableManager get recordTasks =>
      $$RecordTasksTableTableManager(_db, _db.recordTasks);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db, _db.attachments);
}

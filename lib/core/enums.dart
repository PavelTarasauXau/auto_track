import 'package:flutter/material.dart';

// Enums are stored in the database by name (see `textEnum` in tables.dart),
// so values can be reordered safely, but must not be renamed.

enum RecordType {
  fuel('Fuel', Icons.local_gas_station),
  service('Service', Icons.build),
  repair('Repair', Icons.car_repair),
  parts('Parts', Icons.settings),
  wash('Wash', Icons.local_car_wash),
  other('Other', Icons.more_horiz);

  const RecordType(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum ItemKind {
  work('Work'),
  part('Part');

  const ItemKind(this.label);

  final String label;
}

enum DocType {
  receipt('Receipt', Icons.receipt_long),
  warranty('Warranty', Icons.verified_outlined),
  insurance('Insurance', Icons.shield_outlined),
  registration('Registration', Icons.badge_outlined),
  other('Other', Icons.description_outlined);

  const DocType(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum RepeatRule {
  none('Does not repeat'),
  daily('Every day'),
  weekly('Every week'),
  monthly('Every month'),
  yearly('Every year');

  const RepeatRule(this.label);

  final String label;
}

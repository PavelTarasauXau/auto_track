import 'task_schedule.dart';

/// A typical maintenance item with a common interval. Real intervals depend
/// on the car, so tasks created from templates can be edited afterwards.
class MaintenanceTemplate {
  const MaintenanceTemplate(
    this.title, {
    this.intervalKm,
    this.intervalMonths,
    this.common = false,
  });

  final String title;
  final int? intervalKm;
  final int? intervalMonths;

  /// Preselected in the templates sheet.
  final bool common;

  int? get intervalDays =>
      intervalMonths == null ? null : monthsToDays(intervalMonths!);
}

const maintenanceTemplates = [
  MaintenanceTemplate(
    'Engine oil & filter',
    intervalKm: 10000,
    intervalMonths: 12,
    common: true,
  ),
  MaintenanceTemplate(
    'Air filter',
    intervalKm: 20000,
    intervalMonths: 24,
    common: true,
  ),
  MaintenanceTemplate(
    'Cabin filter',
    intervalKm: 15000,
    intervalMonths: 12,
    common: true,
  ),
  MaintenanceTemplate('Brake fluid', intervalMonths: 24, common: true),
  MaintenanceTemplate('Insurance', intervalMonths: 12, common: true),
  MaintenanceTemplate('Technical inspection', intervalMonths: 12),
  MaintenanceTemplate('Spark plugs', intervalKm: 30000, intervalMonths: 36),
  MaintenanceTemplate('Brake pads check', intervalKm: 15000),
  MaintenanceTemplate('Coolant', intervalKm: 60000, intervalMonths: 36),
  MaintenanceTemplate('Timing belt', intervalKm: 60000, intervalMonths: 60),
  MaintenanceTemplate('Transmission oil', intervalKm: 60000),
  MaintenanceTemplate('Tire rotation', intervalKm: 10000),
];

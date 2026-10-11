import 'package:intl/intl.dart';

final _number = NumberFormat.decimalPattern('en');
final _decimal = NumberFormat('#,##0.##', 'en');
final _money = NumberFormat('#,##0.00', 'en');
final _date = DateFormat('d MMM yyyy', 'en_US');
final _dateTime = DateFormat('d MMM yyyy, HH:mm', 'en_US');
final _month = DateFormat('MMMM yyyy', 'en_US');

/// `51000` → `51,000 km`
String formatKm(int km) => '${_number.format(km)} km';

String formatNumber(num value) => _number.format(value);

/// Up to two decimals without trailing zeros: `40` → `40`, `1.5` → `1.5`.
String formatDecimal(num value) => _decimal.format(value);

String formatMoney(double value) => _money.format(value);

String formatDate(DateTime date) => _date.format(date);

String formatDateTime(DateTime date) => _dateTime.format(date);

/// `October 2026`
String formatMonth(DateTime date) => _month.format(date);

/// Parses user input like `51 000` or `51,000`; `null` if not a number.
int? parseInt(String input) =>
    int.tryParse(input.replaceAll(RegExp(r'[\s,]'), ''));

/// Parses `1.5`, `1,5` or `1 234.5`; `null` if not a number.
double? parseDecimal(String input) {
  final s = input.trim().replaceAll(' ', '');
  if (s.isEmpty) return null;
  // A single comma is a decimal separator (`1,5`); otherwise commas
  // group thousands (`1,234.5`).
  final normalized = s.contains('.') || ','.allMatches(s).length > 1
      ? s.replaceAll(',', '')
      : s.replaceAll(',', '.');
  return double.tryParse(normalized);
}

/// Value for a text field: `40.0` → `40`, `1.5` → `1.5`, `null` → empty.
String decimalToInput(double? value) {
  if (value == null) return '';
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : double.parse(value.toStringAsFixed(2)).toString();
}

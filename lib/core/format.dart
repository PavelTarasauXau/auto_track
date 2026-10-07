import 'package:intl/intl.dart';

final _number = NumberFormat.decimalPattern('en');
final _money = NumberFormat('#,##0.00', 'en');
final _date = DateFormat('d MMM yyyy', 'en_US');
final _dateTime = DateFormat('d MMM yyyy, HH:mm', 'en_US');

/// `51000` → `51,000 km`
String formatKm(int km) => '${_number.format(km)} km';

String formatNumber(num value) => _number.format(value);

String formatMoney(double value) => _money.format(value);

String formatDate(DateTime date) => _date.format(date);

String formatDateTime(DateTime date) => _dateTime.format(date);

/// Parses user input like `51 000` or `51,000`; `null` if not a number.
int? parseInt(String input) =>
    int.tryParse(input.replaceAll(RegExp(r'[\s,]'), ''));

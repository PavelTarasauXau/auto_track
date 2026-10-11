import 'package:auto_track/core/format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseDecimal accepts dot, comma and grouping', () {
    expect(parseDecimal('1.5'), 1.5);
    expect(parseDecimal('1,5'), 1.5);
    expect(parseDecimal('1 234.5'), 1234.5);
    expect(parseDecimal('1,234.5'), 1234.5);
    expect(parseDecimal('1,234,567'), 1234567);
    expect(parseDecimal(''), isNull);
    expect(parseDecimal('abc'), isNull);
  });

  test('decimalToInput drops trailing zeros', () {
    expect(decimalToInput(40), '40');
    expect(decimalToInput(1.5), '1.5');
    expect(decimalToInput(1.239), '1.24');
    expect(decimalToInput(null), '');
  });

  test('formatters', () {
    expect(formatKm(51000), '51,000 km');
    expect(formatMoney(60), '60.00');
    expect(formatDate(DateTime(2026, 10, 9)), '9 Oct 2026');
    expect(formatMonth(DateTime(2026, 10)), 'October 2026');
  });
}

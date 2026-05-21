import 'package:intl/intl.dart';

final DateFormat _shortDateFormat = DateFormat.MMMd();
final DateFormat _monthDayYearFormat = DateFormat.yMMMd();
final DateFormat _monthFormat = DateFormat.MMM();
final NumberFormat _chartNumberFormat = NumberFormat.decimalPattern()
  ..maximumFractionDigits = 1;
final NumberFormat _percentFormat = NumberFormat.percentPattern();

String formatCurrency(
  num amount, {
  String name = 'USD',
  int decimalDigits = 0,
}) => NumberFormat.simpleCurrency(
  name: name,
  decimalDigits: decimalDigits,
).format(amount);

String formatCurrencyFlag(String currencyCode) {
  final normalized = currencyCode.trim().toUpperCase();
  final countryCode = switch (normalized) {
    'AUD' => 'AU',
    'EUR' => 'EU',
    'GBP' => 'GB',
    'IDR' => 'ID',
    'JPY' => 'JP',
    'KRW' => 'KR',
    'MYR' => 'MY',
    'PLN' => 'PL',
    'SGD' => 'SG',
    'THB' => 'TH',
    'USD' => 'US',
    'VND' => 'VN',
    _ => '',
  };
  if (countryCode.length != 2) {
    return normalized.isEmpty ? '?' : normalized.substring(0, 1);
  }
  return String.fromCharCodes(
    countryCode.codeUnits.map((unit) => 0x1F1E6 + unit - 0x41),
  );
}

String formatCents(
  int amountInCents, {
  String name = 'USD',
  int decimalDigits = 0,
}) => formatCurrency(
  amountInCents / 100,
  name: name,
  decimalDigits: decimalDigits,
);

String formatShortDate(DateTime date) => _shortDateFormat.format(date);

String formatDateRange(DateTime start, DateTime end) =>
    '${_shortDateFormat.format(start)} - ${_shortDateFormat.format(end)}';

String formatFullDate(DateTime date) => _monthDayYearFormat.format(date);

String formatMonth(DateTime date) => _monthFormat.format(date);

String formatChartNumber(double value) => _chartNumberFormat.format(value);

String formatPercent(double value) => _percentFormat.format(value);

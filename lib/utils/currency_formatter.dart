import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _vndFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  static String formatVnd(num value, {bool convertFromUsd = true}) {
    final amount = value;
    return _vndFormat.format(amount);
  }

  static String formatSignedVnd(num value, {bool convertFromUsd = true}) {
    final prefix = value < 0 ? '- ' : '';
    return '$prefix${formatVnd(value.abs(), convertFromUsd: convertFromUsd)}';
  }
}

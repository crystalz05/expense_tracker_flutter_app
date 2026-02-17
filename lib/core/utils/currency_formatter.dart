import 'package:intl/intl.dart';

String formatNaira(double amount, {int decimalDigits = 2}) {
  return NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: decimalDigits,
  ).format(amount);
}

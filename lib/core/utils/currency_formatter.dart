import 'package:expenses_tracker_app/core/presentation/cubit/currency_cubit.dart';
import 'package:intl/intl.dart';

/// Format [amount] using the app's selected [currency].
String formatCurrency(double amount, AppCurrency currency,
    {int decimalDigits = 2}) {
  if (currency == AppCurrency.usd) {
    return formatDollar(amount, decimalDigits: decimalDigits);
  }
  return formatNaira(amount, decimalDigits: decimalDigits);
}

String formatNaira(double amount, {int decimalDigits = 2}) {
  return NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: decimalDigits,
  ).format(amount);
}

String formatDollar(double amount, {int decimalDigits = 2}) {
  return NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: decimalDigits,
  ).format(amount);
}

/// Returns the symbol for [currency].
String currencySymbol(AppCurrency currency) => currency.symbol;

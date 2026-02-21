import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported currencies.
enum AppCurrency {
  ngn, // Nigerian Naira ₦
  usd, // US Dollar $
}

extension AppCurrencyExtension on AppCurrency {
  String get code => name.toUpperCase(); // 'NGN' | 'USD'
  String get symbol => this == AppCurrency.ngn ? '₦' : '\$';
  String get displayName =>
      this == AppCurrency.ngn ? 'NGN (₦)' : 'USD (\$)';
}

class CurrencyCubit extends Cubit<AppCurrency> {
  final SharedPreferences prefs;
  static const String _currencyKey = 'selected_currency';

  CurrencyCubit(this.prefs) : super(AppCurrency.ngn) {
    _loadCurrency();
  }

  void _loadCurrency() {
    final saved = prefs.getString(_currencyKey);
    if (saved == AppCurrency.usd.name) {
      emit(AppCurrency.usd);
    } else {
      emit(AppCurrency.ngn);
    }
  }

  Future<void> setCurrency(AppCurrency currency) async {
    await prefs.setString(_currencyKey, currency.name);
    emit(currency);
  }
}

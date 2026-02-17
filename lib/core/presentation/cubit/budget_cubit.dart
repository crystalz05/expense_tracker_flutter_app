import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetStateSecondary {
  final double monthlyBudget;
  BudgetStateSecondary({required this.monthlyBudget});
}

class BudgetCubit extends Cubit<BudgetStateSecondary> {
  final SharedPreferences prefs;
  static const String _budgetKey = 'monthly_budget';

  BudgetCubit({required this.prefs})
    : super(
        BudgetStateSecondary(
          monthlyBudget: prefs.getDouble(_budgetKey) ?? 200000,
        ),
      );

  void setBudget(double newBudget) {
    // Save to SharedPreferences
    prefs.setDouble(_budgetKey, newBudget);
    emit(BudgetStateSecondary(monthlyBudget: newBudget));
  }
}

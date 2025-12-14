import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BudgetState {
  final double monthlyBudget;
  BudgetState({required this.monthlyBudget});
}

class BudgetCubit extends Cubit<BudgetState> {
  final SharedPreferences prefs;
  static const String _budgetKey = 'monthly_budget';

  BudgetCubit({required this.prefs})
      : super(BudgetState(
    monthlyBudget: prefs.getDouble(_budgetKey) ?? 200000,
  ));

  void setBudget(double newBudget) {
    // Save to SharedPreferences
    prefs.setDouble(_budgetKey, newBudget);
    emit(BudgetState(monthlyBudget: newBudget));
  }
}
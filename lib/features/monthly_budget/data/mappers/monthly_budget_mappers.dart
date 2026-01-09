
import 'package:expenses_tracker_app/features/monthly_budget/data/models/monthly_budget_model.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';

extension MonthlyBudgetModelMapper on MonthlyBudgetModel {
  MonthlyBudget toEntity(){
    return MonthlyBudget(
        id: id,
        userId: userId,
        month: month,
        year: year,
        amount: amount
    );
  }
}

extension MonthlyBudgetEntityMapper on MonthlyBudget {
  MonthlyBudgetModel toModel(){
    return MonthlyBudgetModel(
        id: id,
        userId: userId,
        month: month,
        year: year,
        amount: amount
    );
  }
}
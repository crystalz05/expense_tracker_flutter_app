import '../models/monthly_budget_model.dart';

abstract class MonthlyBudgetLocalDataSource {
  Future<List<MonthlyBudgetModel>> getMonthlyBudgets(String userId);
  Future<MonthlyBudgetModel?> getMonthlyBudgetById(String id);
  Future<MonthlyBudgetModel?> getMonthlyBudgetByMonthYear(
    String userId,
    int month,
    int year,
  );
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsByYear(
    String userId,
    int year,
  );
  Future<void> createMonthlyBudget(MonthlyBudgetModel monthlyBudget);
  Future<void> updateMonthlyBudget(MonthlyBudgetModel monthlyBudget);
  Future<void> deleteMonthlyBudget(String id);

  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsNeedingSync(String userId);
  Future<List<MonthlyBudgetModel>> getDeletedMonthlyBudgets(String userId);
  Future<void> permanentlyDeleteMonthlyBudgets(List<String> ids);
  Future<void> clearUserData(String userId);
}

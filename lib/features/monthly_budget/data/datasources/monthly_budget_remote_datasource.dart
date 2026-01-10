import '../models/monthly_budget_model.dart';

abstract class MonthlyBudgetRemoteDataSource {
  Future<List<MonthlyBudgetModel>> getMonthlyBudgets(String userId);
  Future<MonthlyBudgetModel?> getMonthlyBudgetById(String id);
  Future<MonthlyBudgetModel?> getMonthlyBudgetByMonthYear(String userId, int month, int year);
  Future<void> createMonthlyBudget(MonthlyBudgetModel monthlyBudget);
  Future<void> updateMonthlyBudget(MonthlyBudgetModel monthlyBudget);
  Future<void> deleteMonthlyBudget(String id);
  Future<void> permanentlyDeleteMonthlyBudgets(List<String> ids);
}
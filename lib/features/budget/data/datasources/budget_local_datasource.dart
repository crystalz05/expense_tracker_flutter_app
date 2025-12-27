import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetModel>> getBudgets();
  Future<BudgetModel?> getBudgetById(String id);
  Future<void> createBudget(BudgetModel budget);
  Future<void> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
}
import '../models/budget_model.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetModel>> getBudgets(String userId);
  Future<BudgetModel?> getBudgetById(String id);
  Future<void> createBudget(BudgetModel budget);
  Future<void> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);

  Future<List<BudgetModel>> getBudgetsNeedingSync(String userId);
  Future<List<BudgetModel>> getDeletedBudgets(String userId);
  Future<void> permanentlyDeleteBudgets(List<String> ids);
  Future<void> clearUserData(String userId);
}

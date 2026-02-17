import '../models/budget_model.dart';

abstract class BudgetRemoteDataSource {
  Future<List<BudgetModel>> getBudgets(String userId);
  Future<BudgetModel?> getBudgetById(String id);
  Future<void> createBudget(BudgetModel budget);
  Future<void> updateBudget(BudgetModel budget);
  Future<void> deleteBudget(String id);
  Future<void> permanentlyDeleteBudgets(List<String> ids);
  Future<List<BudgetModel>> getBudgetsModifiedAfter(
    DateTime timestamp,
    String userId,
  );
}

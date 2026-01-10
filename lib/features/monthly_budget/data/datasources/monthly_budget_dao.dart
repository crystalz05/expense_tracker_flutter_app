import 'package:floor/floor.dart';

import '../models/monthly_budget_model.dart';

@dao
abstract class MonthlyBudgetDao {
  @Query('SELECT * FROM monthly_budgets WHERE is_deleted = 0 AND user_id = :userId ORDER BY year DESC, month DESC')
  Future<List<MonthlyBudgetModel>> getAllMonthlyBudgets(String userId);

  @Query('SELECT * FROM monthly_budgets WHERE id = :id')
  Future<MonthlyBudgetModel?> getMonthlyBudgetById(String id);

  @Query('SELECT * FROM monthly_budgets WHERE user_id = :userId AND month = :month AND year = :year AND is_deleted = 0')
  Future<MonthlyBudgetModel?> getMonthlyBudgetByMonthYear(String userId, int month, int year);

  @Query('SELECT * FROM monthly_budgets WHERE user_id = :userId AND year = :year AND is_deleted = 0 ORDER BY month ASC')
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsByYear(String userId, int year);

  @insert
  Future<void> insertMonthlyBudget(MonthlyBudgetModel monthlyBudget);

  @update
  Future<void> updateMonthlyBudget(MonthlyBudgetModel monthlyBudget);

  @Query('DELETE FROM monthly_budgets WHERE id = :id')
  Future<void> deleteMonthlyBudget(String id);

  @Query('SELECT * FROM monthly_budgets WHERE needs_sync = 1 AND user_id = :userId')
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsNeedingSync(String userId);

  @Query('SELECT * FROM monthly_budgets WHERE is_deleted = 1 AND user_id = :userId')
  Future<List<MonthlyBudgetModel>> getDeletedMonthlyBudgets(String userId);

  @Query('DELETE FROM monthly_budgets WHERE is_deleted = 1 AND id IN (:ids)')
  Future<void> permanentlyDeleteMonthlyBudgets(List<String> ids);

  @Query('UPDATE monthly_budgets SET needs_sync = 0, last_synced_at = :syncTime WHERE id = :id')
  Future<void> markAsSynced(String id, DateTime syncTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMonthlyBudgets(List<MonthlyBudgetModel> budgets);

  @Query('DELETE FROM monthly_budgets WHERE user_id = :userId')
  Future<void> clearUserData(String userId);
}
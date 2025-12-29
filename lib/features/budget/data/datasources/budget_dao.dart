import 'package:floor/floor.dart';

import '../models/budget_model.dart';

@dao
abstract class BudgetDao {

// FIXED: Filter by user_id
  @Query('SELECT * FROM budgets WHERE is_deleted = 0 AND user_id = :userId')
  Future<List<BudgetModel>> getAllBudgets(String userId);

  @Query('SELECT * FROM budgets WHERE id = :id')
  Future<BudgetModel?> getBudgetById(String id);

  @insert
  Future<void> insertBudget(BudgetModel budget);

  @update
  Future<void> updateBudget(BudgetModel budget);

  @Query('DELETE FROM budgets WHERE id = :id')
  Future<void> deleteBudget(String id);

  // Sync-related queries - ALL need user_id filtering
  @Query('SELECT * FROM budgets WHERE needs_sync = 1 AND user_id = :userId')
  Future<List<BudgetModel>> getBudgetsNeedingSync(String userId);

  @Query('SELECT * FROM budgets WHERE is_deleted = 1 AND user_id = :userId')
  Future<List<BudgetModel>> getDeletedBudgets(String userId);

  @Query('DELETE FROM budgets WHERE is_deleted = 1 AND id IN (:ids)')
  Future<void> permanentlyDeleteBudgets(List<String> ids);

  @Query('UPDATE budgets SET needs_sync = 0, last_synced_at = :syncTime WHERE id = :id')
  Future<void> markAsSynced(String id, DateTime syncTime);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBudgets(List<BudgetModel> budgets);

  @Query('SELECT * FROM budgets WHERE user_id = :userId AND (updated_at > :timestamp OR (updated_at IS NULL AND created_at > :timestamp))')
  Future<List<BudgetModel>> getBudgetsModifiedAfter(String userId, DateTime timestamp);

  @Query('DELETE FROM budgets WHERE is_deleted = 1 AND updated_at < :cutoffTime')
  Future<void> cleanupOldDeletedBudgets(DateTime cutoffTime);

  // CRITICAL: Cleanup when user logs out
  @Query('DELETE FROM budgets WHERE user_id = :userId')
  Future<void> clearUserData(String userId);
}
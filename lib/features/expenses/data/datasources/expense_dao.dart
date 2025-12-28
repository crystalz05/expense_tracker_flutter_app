
import 'package:floor/floor.dart';

import '../models/expense_model.dart';

@dao
abstract class ExpenseDao {

  @Query('SELECT * FROM expenses WHERE is_deleted = 0 ORDER BY updated_at DESC')
  Future<List<ExpenseModel>> getExpenses();

  @Query('SELECT * FROM expenses WHERE is_deleted = 0 AND updated_at BETWEEN :start AND :end ORDER BY updated_at DESC')
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime start, DateTime end);

  @Query('SELECT * FROM expenses WHERE is_deleted = 0 AND category = :category AND updated_at BETWEEN :start AND :end ORDER BY updated_at DESC')
  Future<List<ExpenseModel>> getExpensesByCategoryAndPeriod(String category, DateTime start, DateTime end);

  @Query('SELECT * FROM expenses WHERE is_deleted = 0 AND category = :category ORDER BY updated_at DESC')
  Future<List<ExpenseModel>> getExpenseByCategory(String category);

  @insert
  Future<void> addExpense(ExpenseModel expense);

  @Query('SELECT * FROM expenses WHERE id = :id AND is_deleted = 0')
  Future<ExpenseModel?> getExpenseById(String id);

  @update
  Future<void> updateExpense(ExpenseModel expense);

  @Query('DELETE FROM expenses WHERE id = :id')
  Future<void> deleteExpense(String id);

  @Query('UPDATE expenses SET is_deleted = 1, updated_at = :updatedAt WHERE id = :id')
  Future<void> softDeleteExpense(String id, DateTime updatedAt);

  @Query('SELECT SUM(amount) FROM expenses WHERE is_deleted = 0 AND category = :category')
  Future<double?> getTotalByCategory(String category);

  @Query('SELECT SUM(amount) FROM expenses WHERE is_deleted = 0')
  Future<double?> getTotalExpense();
}



import 'package:expenses_tracker_app/features/expenses/data/entities/expense_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ExpenseDao {

  @Query('SELECT * FROM expenses ORDER BY updated_at DESC')
  Future<List<ExpenseEntity>> getExpenses();

  @Query('SELECT * FROM expenses WHERE updated_at BETWEEN :start AND :end ORDER BY updated_at DESC')
  Future<List<ExpenseEntity>> getExpensesByDateRange(DateTime start, DateTime end);

  @Query('SELECT * FROM expenses WHERE category = :category ORDER BY updated_at DESC')
  Future<List<ExpenseEntity>> getExpenseByCategory(String category);

  @insert
  Future<void> addExpense(ExpenseEntity expense);

  @Query('SELECT * FROM expenses WHERE id = :id')
  Future<ExpenseEntity?> getExpenseById(String id);

  @update
  Future<void> updateExpense(ExpenseEntity expense);

  @Query('SELECT * FROM expenses WHERE id = :id')
  Future<void> deleteExpense(String id);

  @Query('SELECT SUM(amount) FROM expenses WHERE category = :category')
  Future<double?> getTotalByCategory(String category);

  @Query('SELECT SUM(amount) FROM expenses')
  Future<double?> getTotalExpense();
}


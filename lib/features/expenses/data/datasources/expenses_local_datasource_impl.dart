import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/core/database/app_database.dart';

import '../models/expense_model.dart';
import 'expenses_local_datasource.dart';

class ExpenseLocalDataSourceImpl implements ExpensesLocalDatasource {
  final AppDatabase database;

  ExpenseLocalDataSourceImpl(this.database);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await database.expenseDao.addExpense(expense);
    } catch (e, s) {
      throw DatabaseException('Failed to add expense: $e', s);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await database.expenseDao.deleteExpense(id);
    } catch (e, s) {
      throw DatabaseException('Failed to delete expense: $e', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenseByCategory(String category) async {
    try {
      return await database.expenseDao.getExpenseByCategory(category);
    } catch (e, s) {
      throw DatabaseException('Failed to get expense by category: $e', s);
    }
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    try {
      return await database.expenseDao.getExpenseById(id);
    } catch (e, s) {
      throw DatabaseException('Failed to get expense with id $id: $e', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    try {
      return await database.expenseDao.getExpenses();
    } catch (e, s) {
      throw DatabaseException('Failed to get expenses: $e', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await database.expenseDao.getExpensesByDateRange(start, end);
    } catch (e, s) {
      throw DatabaseException('Failed to get expense by date range: $e', s);
    }
  }

  @override
  Future<double?> getTotalByCategory(String category) async {
    try {
      return await database.expenseDao.getTotalByCategory(category);
    } catch (e, s) {
      throw DatabaseException('Failed to get total by category: $e', s);
    }
  }

  @override
  Future<double?> getTotalExpense() async {
    try {
      return await database.expenseDao.getTotalExpense();
    } catch (e, s) {
      throw DatabaseException('Failed to get total expenses: $e', s);
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await database.expenseDao.updateExpense(expense);
    } catch (e, s) {
      throw DatabaseException('Failed to update expense: $e', s);
    }
  }

  @override
  Future<void> softDeleteExpense(String id, DateTime updatedAt) async {
    try {
      await database.expenseDao.softDeleteExpense(id, updatedAt);
    } catch (e, s) {
      throw DatabaseException('Failed to soft delete expense: $e', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getByCategoryAndPeriod(
    String category,
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await database.expenseDao.getExpensesByCategoryAndPeriod(
        category,
        start,
        end,
      );
    } catch (e, s) {
      throw DatabaseException(
        'Failed to get expense by category and period: $e',
        s,
      );
    }
  }

  @override
  Future<List<ExpenseModel>> getAllExpensesIncludingDeleted() async {
    try {
      return await database.expenseDao.getAllExpensesIncludingDeleted();
    } catch (e, s) {
      throw DatabaseException('Failed to get all expenses: $e', s);
    }
  }

  @override
  Future<void> purgeSoftDeleted() async {
    try {
      await database.expenseDao.purgeSoftDeleted();
    } catch (e, s) {
      throw DatabaseException('Failed to purge soft deleted expenses: $e', s);
    }
  }
}

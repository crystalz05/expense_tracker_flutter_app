
import 'dart:math';

import 'package:expenses_tracker_app/features/expenses/data/datasources/expense_dao.dart';
import 'package:expenses_tracker_app/features/expenses/data/models/expense_model.dart';

abstract class ExpensesLocalDatasource {

  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenses();
  Future<ExpenseModel?> getExpenseById(String id);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  Future<void> softDeleteExpense(String id, DateTime updatedAt);
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<List<ExpenseModel>> getExpenseByCategory(String category);
  Future<double?> getTotalByCategory(String category);
  Future<double?> getTotalExpense();

}
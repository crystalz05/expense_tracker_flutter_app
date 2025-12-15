
import 'dart:math';

import 'package:expenses_tracker_app/features/expenses/data/datasources/expense_dao.dart';
import 'package:expenses_tracker_app/features/expenses/data/entities/expense_entity.dart';

abstract class ExpensesLocalDatasource {

  Future<void> addExpense(ExpenseEntity expense);
  Future<List<ExpenseEntity>> getExpenses();
  Future<ExpenseEntity?> getExpenseById(String id);
  Future<void> updateExpense(ExpenseEntity expense);
  Future<void> deleteExpense(String id);
  Future<List<ExpenseEntity>> getExpensesByDateRange(DateTime start, DateTime end);
  Future<List<ExpenseEntity>> getExpenseByCategory(String category);
  Future<double?> getTotalByCategory(String category);
  Future<double?> getTotalExpense();

}
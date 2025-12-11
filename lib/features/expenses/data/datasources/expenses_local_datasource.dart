
import 'dart:math';

import 'package:expenses_tracker_app/features/expenses/data/models/expense_model.dart';
import 'package:hive/hive.dart';

abstract class ExpensesLocalDatasource {

  Future<void> addExpense(ExpenseModel expense);
  Future<List<ExpenseModel>> getExpenses();
  Future<ExpenseModel?> getExpenseById(String id);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);

}

import 'dart:math';

import 'package:expenses_tracker_app/features/expenses/data/models/expense_model.dart';
import 'package:hive/hive.dart';

import 'expenses_local_datasource.dart';


class ExpenseLocalDataSourceImpl implements ExpensesLocalDatasource{

  final Box<ExpenseModel> box;

  ExpenseLocalDataSourceImpl(this.box);

  static const String boxName = "expenses";

  Future<Box<ExpenseModel>> getBox() async{
    return await Hive.openBox(boxName);
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await box.delete(id);
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    return box.get(id);
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    return box.values.toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await box.put(expense.id, expense);
  }
}

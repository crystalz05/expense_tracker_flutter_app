
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/app_database.dart';
import 'package:expenses_tracker_app/features/expenses/data/entities/expense_entity.dart';

import 'expenses_local_datasource.dart';

class ExpenseLocalDataSourceImpl implements ExpensesLocalDatasource{

  final AppDatabase database;
  ExpenseLocalDataSourceImpl(this.database);

  @override
  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      await database.expenseDao.addExpense(expense);
    }catch (e, s){
      throw DatabaseException('Failed to add expense: ${e.toString()}', s);
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await database.expenseDao.deleteExpense(id);
    }catch (e, s){
      throw DatabaseException('Failed to delete expense: ${e.toString()}', s);
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenseByCategory(String category) async {
    try{
      return await database.expenseDao.getExpenseByCategory(category);
    }catch (e, s){
      throw DatabaseException('Failed to get expense by category: ${e.toString()}', s);
    }
  }

  @override
  Future<ExpenseEntity?> getExpenseById(String id) async {
    try{
      return await database.expenseDao.getExpenseById(id);
    }catch (e, s){
      throw DatabaseException('Failed to get expense with id $id: ${e.toString()}', s);
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses() async {
    try{
      return await database.expenseDao.getExpenses();
    }catch (e, s){
      throw DatabaseException('Failed to get expense: ${e.toString()}', s);
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByDateRange(DateTime start, DateTime end) async {
    try{
      return await database.expenseDao.getExpensesByDateRange(start, end);
    }catch(e, s){
      throw DatabaseException('Failed to get expense by date range: ${e.toString()}', s);
    }
  }

  @override
  Future<double?> getTotalByCategory(String category) async {
    try{
      return await database.expenseDao.getTotalByCategory(category);
    }catch (e, s){
      throw DatabaseException('Failed go get total by category ${e.toString()}', s);
    }
  }

  @override
  Future<double?> getTotalExpense() async {
    try{
      return await database.expenseDao.getTotalExpense();
    }catch (e, s) {
      throw DatabaseException('Failed to get total expenses ${e.toString()}', s);
    }
  }

  @override
  Future<void> updateExpense(ExpenseEntity expense) async {
    try{
      await database.expenseDao.updateExpense(expense);
    }catch (e, s){
      throw DatabaseException('Failed to update expense ${e.toString()}', s);
    }
  }
}

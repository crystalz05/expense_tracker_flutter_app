
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/core/database/app_database.dart';

import '../models/expense_model.dart';
import 'expenses_local_datasource.dart';

class ExpenseLocalDataSourceImpl implements ExpensesLocalDatasource{

  final AppDatabase database;
  ExpenseLocalDataSourceImpl(this.database);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
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
  Future<List<ExpenseModel>> getExpenseByCategory(String category) async {
    try{
      return await database.expenseDao.getExpenseByCategory(category);
    }catch (e, s){
      throw DatabaseException('Failed to get expense by category: ${e.toString()}', s);
    }
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    try{
      return await database.expenseDao.getExpenseById(id);
    }catch (e, s){
      throw DatabaseException('Failed to get expense with id $id: ${e.toString()}', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    try{
      return await database.expenseDao.getExpenses();
    }catch (e, s){
      throw DatabaseException('Failed to get expense: ${e.toString()}', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getExpensesByDateRange(DateTime start, DateTime end) async {
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
  Future<void> updateExpense(ExpenseModel expense) async {
    try{
      await database.expenseDao.updateExpense(expense);
    }catch (e, s){
      throw DatabaseException('Failed to update expense ${e.toString()}', s);
    }
  }

  @override
  Future<void> softDeleteExpense(String id, DateTime updatedAt) async {
    try {
      await database.expenseDao.softDeleteExpense(id, updatedAt);
    }catch (e, s){
      throw DatabaseException('Failed to delete expense: ${e.toString()}', s);
    }
  }

  @override
  Future<List<ExpenseModel>> getByCategoryAndPeriod(String category, DateTime start, DateTime end) async {
    try{
      return await database.expenseDao.getExpensesByCategoryAndPeriod(category, start, end);
    }catch(e, s){
      throw DatabaseException('Failed to get expense by category and period: ${e.toString()}', s);
    }
  }
}
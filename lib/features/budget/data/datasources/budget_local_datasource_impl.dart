import '../models/budget_model.dart';
import 'budget_dao.dart';
import 'budget_local_datasource.dart';

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final BudgetDao dao;

  BudgetLocalDataSourceImpl(this.dao);

  @override
  Future<List<BudgetModel>> getBudgets() => dao.getAllBudgets();

  @override
  Future<BudgetModel?> getBudgetById(String id) => dao.getBudgetById(id);

  @override
  Future<void> createBudget(BudgetModel budget) =>
      dao.insertBudget(budget);

  @override
  Future<void> updateBudget(BudgetModel budget) =>
      dao.updateBudget(budget);

  @override
  Future<void> deleteBudget(String id) =>
      dao.deleteBudget(id);
}

// final AppDatabase database;
// ExpenseLocalDataSourceImpl(this.database);
//
// @override
// Future<void> addExpense(ExpenseModel expense) async {
//   try {
//     await database.expenseDao.addExpense(expense);
//   }catch (e, s){
//     throw DatabaseException('Failed to add expense: ${e.toString()}', s);
//   }
// }
//
// @override
// Future<void> deleteExpense(String id) async {
//   try {
//     await database.expenseDao.deleteExpense(id);
//   }catch (e, s){
//     throw DatabaseException('Failed to delete expense: ${e.toString()}', s);
//   }
// }
//
// @override
// Future<List<ExpenseModel>> getExpenseByCategory(String category) async {
//   try{
//     return await database.expenseDao.getExpenseByCategory(category);
//   }catch (e, s){
//     throw DatabaseException('Failed to get expense by category: ${e.toString()}', s);
//   }
// }
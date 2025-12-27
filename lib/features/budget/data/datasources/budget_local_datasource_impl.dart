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
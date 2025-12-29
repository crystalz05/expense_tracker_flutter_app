import '../models/budget_model.dart';
import 'budget_dao.dart';
import 'budget_local_datasource.dart';

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final BudgetDao dao;

  BudgetLocalDataSourceImpl(this.dao);

  @override
  Future<List<BudgetModel>> getBudgets(String userId) => dao.getAllBudgets(userId);

  @override
  Future<BudgetModel?> getBudgetById(String id) => dao.getBudgetById(id);

  @override
  Future<void> createBudget(BudgetModel budget) => dao.insertBudget(budget);

  @override
  Future<void> updateBudget(BudgetModel budget) => dao.updateBudget(budget);

  @override
  Future<void> deleteBudget(String id) => dao.deleteBudget(id);

  @override
  Future<List<BudgetModel>> getBudgetsNeedingSync(String userId) => dao.getBudgetsNeedingSync(userId);

  @override
  Future<List<BudgetModel>> getDeletedBudgets(String userId) => dao.getDeletedBudgets(userId);

  @override
  Future<void> permanentlyDeleteBudgets(List<String> ids) => dao.permanentlyDeleteBudgets(ids);

  @override
  Future<void> clearUserData(String userId) => dao.clearUserData(userId);
}
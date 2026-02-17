import '../models/monthly_budget_model.dart';
import 'monthly_budget_dao.dart';
import 'monthly_budget_local_datasource.dart';

class MonthlyBudgetLocalDataSourceImpl implements MonthlyBudgetLocalDataSource {
  final MonthlyBudgetDao dao;

  MonthlyBudgetLocalDataSourceImpl(this.dao);

  @override
  Future<List<MonthlyBudgetModel>> getMonthlyBudgets(String userId) =>
      dao.getAllMonthlyBudgets(userId);

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudgetById(String id) =>
      dao.getMonthlyBudgetById(id);

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudgetByMonthYear(
    String userId,
    int month,
    int year,
  ) => dao.getMonthlyBudgetByMonthYear(userId, month, year);

  @override
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsByYear(
    String userId,
    int year,
  ) => dao.getMonthlyBudgetsByYear(userId, year);

  @override
  Future<void> createMonthlyBudget(MonthlyBudgetModel monthlyBudget) =>
      dao.insertMonthlyBudget(monthlyBudget);

  @override
  Future<void> updateMonthlyBudget(MonthlyBudgetModel monthlyBudget) =>
      dao.updateMonthlyBudget(monthlyBudget);

  @override
  Future<void> deleteMonthlyBudget(String id) => dao.deleteMonthlyBudget(id);

  @override
  Future<List<MonthlyBudgetModel>> getMonthlyBudgetsNeedingSync(
    String userId,
  ) => dao.getMonthlyBudgetsNeedingSync(userId);

  @override
  Future<List<MonthlyBudgetModel>> getDeletedMonthlyBudgets(String userId) =>
      dao.getDeletedMonthlyBudgets(userId);

  @override
  Future<void> permanentlyDeleteMonthlyBudgets(List<String> ids) =>
      dao.permanentlyDeleteMonthlyBudgets(ids);

  @override
  Future<void> clearUserData(String userId) => dao.clearUserData(userId);
}

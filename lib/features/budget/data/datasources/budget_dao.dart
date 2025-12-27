import 'package:floor/floor.dart';

import '../models/budget_model.dart';

@dao
abstract class BudgetDao {

  @Query('SELECT * FROM budgets')
  Future<List<BudgetModel>> getAllBudgets();

  @Query('SELECT * FROM budgets WHERE id = :id')
  Future<BudgetModel?> getBudgetById(String id);

  @insert
  Future<void> insertBudget(BudgetModel budget);

  @update
  Future<void> updateBudget(BudgetModel budget);

  @Query('DELETE FROM budgets WHERE id = :id')
  Future<void> deleteBudget(String id);
}
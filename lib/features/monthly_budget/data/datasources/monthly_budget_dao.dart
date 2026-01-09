
import 'package:expenses_tracker_app/features/monthly_budget/data/models/monthly_budget_model.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';
import 'package:floor/floor.dart';

import '../../../../core/usecases/usecase.dart';

@dao
abstract class MonthlyBudgetDao {

  @Query('SELECT * FROM monthly_budgets WHERE month = :month AND year = :year')
  Future<MonthlyBudgetModel> getMonthlyBudgetByDate(String month, String year);
  
  @Query('SELECT * FROM monthly_budgets')
  Future<List<MonthlyBudgetModel>> getAllMonthlyBudgets();

  @update
  Future<MonthlyBudgetModel> updateMonthlyBudget(MonthlyBudgetModel model);

  @Query('DELETE FROM monthly_budgets where month = :month AND year = :year')
  Future<void> deleteMonthlyBudgetByDate(String month, String year);

  Future<void> syncMonthlyBudgets();

}



// Future<Either<Failure, MonthlyBudget>> getMonthlyBudgetByDate(BudgetDateParams param);
// Future<Either<Failure, List<MonthlyBudget>>> getAllMonthlyBudgets();
// Future<Either<Failure, MonthlyBudget>> updateMonthlyBudget(BudgetDateParams param);
// Future<Either<Failure, MonthlyBudget>> updateMonthlyBudgetById(String id);
// Future<Either<Failure, void>> deleteMonthlyBudgetByDate(BudgetDateParams param);
//
// Future<Either<Failure, void>> syncMonthlyBudgets();
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';

import '../../../../core/error/failures.dart';

abstract class MonthlyBudgetRepository {

  Future<Either<Failure, MonthlyBudget>> addMonthlyBudget(MonthlyBudget monthlyBudget);
  Future<Either<Failure, MonthlyBudget>> getMonthlyBudgetByDate(BudgetDateParams param);
  Future<Either<Failure, List<MonthlyBudget>>> getAllMonthlyBudgets();
  Future<Either<Failure, MonthlyBudget>> updateMonthlyBudget(MonthlyBudget monthlyBudget);
  Future<Either<Failure, void>> deleteMonthlyBudgetByDate(BudgetDateParams param);

  Future<Either<Failure, void>> syncMonthlyBudgets();
}
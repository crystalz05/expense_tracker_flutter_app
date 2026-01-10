import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';

import '../../../../core/error/failures.dart';

abstract class MonthlyBudgetRepository {
  Future<Either<Failure, List<MonthlyBudget>>> getMonthlyBudgets();
  Future<Either<Failure, MonthlyBudget>> getMonthlyBudgetById(String id);
  Future<Either<Failure, MonthlyBudget?>> getMonthlyBudgetByMonthYear(int month, int year);
  Future<Either<Failure, List<MonthlyBudget>>> getMonthlyBudgetsByYear(int year);
  Future<Either<Failure, void>> createMonthlyBudget(MonthlyBudget monthlyBudget);
  Future<Either<Failure, void>> updateMonthlyBudget(MonthlyBudget monthlyBudget);
  Future<Either<Failure, void>> deleteMonthlyBudget(String id);

  Future<Either<Failure, void>> syncMonthlyBudgets();
  Future<Either<Failure, void>> purgeSoftDeletedMonthlyBudgets();
  Future<Either<Failure, void>> clearUserData();
}
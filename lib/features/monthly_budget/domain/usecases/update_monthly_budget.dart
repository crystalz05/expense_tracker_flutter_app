
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/repositories/monthly_budget_repository.dart';

class UpdateMonthlyBudget extends UseCase<MonthlyBudget, MonthlyBudget> {

  final MonthlyBudgetRepository repository;

  UpdateMonthlyBudget(this.repository);

  @override
  Future<Either<Failure, MonthlyBudget>> call(MonthlyBudget param) {
    return repository.updateMonthlyBudget(param);
  }
}


import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/repositories/monthly_budget_repository.dart';

class SyncMonthlyBudgets extends UseCase<void, NoParams> {

  final MonthlyBudgetRepository repository;

  SyncMonthlyBudgets(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams param) {
    return repository.syncMonthlyBudgets();
  }
}
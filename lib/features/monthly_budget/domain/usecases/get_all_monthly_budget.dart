
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/entities/monthly_budget.dart';
import 'package:expenses_tracker_app/features/monthly_budget/domain/repositories/monthly_budget_repository.dart';

class GetAllMonthlyBudget extends UseCase<List<MonthlyBudget>, NoParams> {

  final MonthlyBudgetRepository repository;

  GetAllMonthlyBudget(this.repository);

  @override
  Future<Either<Failure, List<MonthlyBudget>>> call(NoParams param) {
    return repository.getAllMonthlyBudgets();
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monthly_budget.dart';
import '../repositories/monthly_budget_repository.dart';

class GetMonthlyBudgetsByYear implements UseCase<List<MonthlyBudget>, YearParams> {
  final MonthlyBudgetRepository repository;

  GetMonthlyBudgetsByYear(this.repository);

  @override
  Future<Either<Failure, List<MonthlyBudget>>> call(YearParams params) async {
    return await repository.getMonthlyBudgetsByYear(params.year);
  }
}
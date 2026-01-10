import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monthly_budget.dart';
import '../repositories/monthly_budget_repository.dart';

class GetMonthlyBudgets implements UseCase<List<MonthlyBudget>, NoParams> {
  final MonthlyBudgetRepository repository;

  GetMonthlyBudgets(this.repository);

  @override
  Future<Either<Failure, List<MonthlyBudget>>> call(NoParams params) async {
    return await repository.getMonthlyBudgets();
  }
}
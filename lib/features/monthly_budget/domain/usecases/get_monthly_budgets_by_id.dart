import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monthly_budget.dart';
import '../repositories/monthly_budget_repository.dart';

class GetMonthlyBudgetById implements UseCase<MonthlyBudget, IdParams> {
  final MonthlyBudgetRepository repository;

  GetMonthlyBudgetById(this.repository);

  @override
  Future<Either<Failure, MonthlyBudget>> call(IdParams params) async {
    return await repository.getMonthlyBudgetById(params.id);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/monthly_budget_repository.dart';

class UpdateMonthlyBudget implements UseCase<void, MonthlyBudgetParams> {
  final MonthlyBudgetRepository repository;

  UpdateMonthlyBudget(this.repository);

  @override
  Future<Either<Failure, void>> call(MonthlyBudgetParams params) async {
    return await repository.updateMonthlyBudget(params.monthlyBudget);
  }
}

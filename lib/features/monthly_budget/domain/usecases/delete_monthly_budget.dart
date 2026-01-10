import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/monthly_budget_repository.dart';

class DeleteMonthlyBudget implements UseCase<void, IdParams> {
  final MonthlyBudgetRepository repository;

  DeleteMonthlyBudget(this.repository);

  @override
  Future<Either<Failure, void>> call(IdParams params) async {
    return await repository.deleteMonthlyBudget(params.id);
  }
}
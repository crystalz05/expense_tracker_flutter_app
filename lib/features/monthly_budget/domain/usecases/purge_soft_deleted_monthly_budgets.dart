import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/monthly_budget_repository.dart';

class PurgeSoftDeletedMonthlyBudgets implements UseCase<void, NoParams> {
  final MonthlyBudgetRepository repository;

  PurgeSoftDeletedMonthlyBudgets(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.purgeSoftDeletedMonthlyBudgets();
  }
}
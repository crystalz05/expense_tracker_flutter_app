import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class GetBudgets implements UseCase<List<Budget>, NoParams> {
  final BudgetRepository repository;

  GetBudgets(this.repository);

  @override
  Future<Either<Failure, List<Budget>>> call(NoParams params) async {
    return await repository.getBudgets();
  }
}
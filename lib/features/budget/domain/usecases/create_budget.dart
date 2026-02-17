import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class CreateBudget implements UseCase<void, CreateOrUpdateBudgetParams> {
  final BudgetRepository repository;

  CreateBudget(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateOrUpdateBudgetParams param) async {
    return await repository.createBudget(param.budget);
  }
}

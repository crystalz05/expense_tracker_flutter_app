import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class UpdateBudget implements UseCase<void, CreateOrUpdateBudgetParams> {
  final BudgetRepository repository;

  UpdateBudget(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateOrUpdateBudgetParams param) async {
    return await repository.updateBudget(param.budget);
  }
}

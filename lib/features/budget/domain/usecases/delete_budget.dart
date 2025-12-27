
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class DeleteBudget implements UseCase<void, IdParams> {

  final BudgetRepository repository;

  DeleteBudget(this.repository);

  @override
  Future<Either<Failure, void>> call(IdParams param) async {
    return await repository.deleteBudget(param.id);
  }
}
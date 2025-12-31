import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class PurgeSoftDeletedBudgets extends UseCase<void, NoParams> {
  final BudgetRepository repository;

  PurgeSoftDeletedBudgets(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.purgeSoftDeletedBudgets();
  }
}
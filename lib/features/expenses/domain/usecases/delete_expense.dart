import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class DeleteExpense extends UseCase<void, IdParams> {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(IdParams param) {
    return repository.deleteExpense(param.id);
  }
}

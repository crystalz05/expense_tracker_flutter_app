
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class SoftDeleteExpense extends UseCase<void, IdParams> {

  final ExpenseRepository repository;

  SoftDeleteExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(IdParams param) {
    return repository.softDeleteExpense(param.id, param.updatedAt);
  }
}
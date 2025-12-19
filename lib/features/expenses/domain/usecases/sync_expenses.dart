import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class SyncExpenses extends UseCase<void, NoParams> {

  ExpenseRepository repository;

  SyncExpenses(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams param) {
    return repository.syncExpenses();
  }
}

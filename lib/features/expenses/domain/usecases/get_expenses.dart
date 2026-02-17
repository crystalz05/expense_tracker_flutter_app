import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class GetExpenses extends UseCase<List<Expense>, NoParams> {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams param) {
    return repository.getExpenses();
  }
}

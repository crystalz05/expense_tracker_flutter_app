import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class UpdateExpense extends UseCase<void, Expense> {
  ExpenseRepository repository;

  UpdateExpense(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(Expense expense) {
    return repository.updateExpense(expense);
  }
}

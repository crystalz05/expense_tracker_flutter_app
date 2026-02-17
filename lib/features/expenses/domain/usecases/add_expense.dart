import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends UseCase<void, ExpenseParams> {
  final ExpenseRepository repository;

  AddExpense(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(ExpenseParams params) {
    final expense = Expense(
      id: Uuid().v4(),
      amount: params.amount,
      category: params.category,
      description: params.description,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      paymentMethod: params.paymentMethod,
    );

    return repository.addExpense(expense);
  }
}

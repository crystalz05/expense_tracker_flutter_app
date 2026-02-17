import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class GetExpenseById extends UseCase<Expense, IdParams> {
  final ExpenseRepository repository;

  GetExpenseById(this.repository);

  @override
  Future<Either<Failure, Expense>> call(IdParams param) {
    return repository.getExpenseById(param.id);
  }
}

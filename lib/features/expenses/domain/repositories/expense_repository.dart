
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {

  Future<Either<Failure, void>> addExpense(Expense expense);
  Future<Either<Failure, List<Expense>>> getExpenses();
  Future<Either<Failure, Expense>> getExpenseById(String id);
  Future<Either<Failure, void>> updateExpense(Expense expense);
  Future<Either<Failure, void>> deleteExpense(String id);
}
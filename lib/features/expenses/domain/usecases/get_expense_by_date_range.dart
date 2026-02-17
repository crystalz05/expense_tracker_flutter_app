import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class GetExpenseByDateRange extends UseCase<List<Expense>, DateRangeParams> {
  final ExpenseRepository repository;

  GetExpenseByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(DateRangeParams param) {
    return repository.getExpensesByDateRange(param.start, param.end);
  }
}

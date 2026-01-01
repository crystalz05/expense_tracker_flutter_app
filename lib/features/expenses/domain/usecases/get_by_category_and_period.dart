
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

class GetByCategoryAndPeriod extends UseCase<List<Expense>, CategoryDateRangeParams> {

  final ExpenseRepository repository;

  GetByCategoryAndPeriod(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(CategoryDateRangeParams param) {
    return repository.getByCategoryAndPeriod(param.category, param.start, param.end);
  }
}
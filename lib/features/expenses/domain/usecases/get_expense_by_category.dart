import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';

import '../repositories/expense_repository.dart';

class GetExpenseByCategory extends UseCase<List<Expense>, CategoryParams> {
  final ExpenseRepository repository;

  GetExpenseByCategory(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(CategoryParams param) async {
    final result = await repository.getExpenses();

    return result.map(
      (expenses) =>
          expenses.where((e) => e.category == param.category).toList(),
    );
  }
}

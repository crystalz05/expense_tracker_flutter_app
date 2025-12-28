import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget_progress.dart';

import '../../../expenses/domain/repositories/expense_repository.dart';
import '../repositories/budget_repository.dart';

class GetAllBudgetProgress {
  final BudgetRepository budgetRepo;
  final ExpenseRepository expenseRepo;

  GetAllBudgetProgress(this.budgetRepo, this.expenseRepo);

  Future<Either<Failure, List<BudgetProgress>>> call() async {
    final budgetsEither = await budgetRepo.getBudgets();

    if (budgetsEither.isLeft()) {
      return budgetsEither.fold(
            (failure) => Left(failure),
            (_) => throw Exception('Unreachable'),
      );
    }

    final budgets = budgetsEither.getOrElse(() => []);

    // Process all budgets in parallel
    final futures = budgets.map((budget) async {
      final expensesEither = await expenseRepo.getByCategoryAndPeriod(
        budget.category,
        budget.startDate,
        budget.endDate,
      );

      return expensesEither.fold(
            (failure) => Left<Failure, BudgetProgress>(failure),
            (expenses) {
          final spent = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
          final percentage = budget.amount == 0 ? 0.0 : (spent / budget.amount) * 100;

          return Right<Failure, BudgetProgress>(BudgetProgress(
            budget: budget,
            spent: spent,
            remaining: budget.amount - spent,
            percentageUsed: percentage,
            isOverBudget: spent > budget.amount,
            shouldAlert: percentage >= (budget.alertThreshold ?? 80),
          ));
        },
      );
    }).toList();

    final results = await Future.wait(futures);

    // Check if any failed - fail fast
    for (final result in results) {
      if (result.isLeft()) {
        return result.fold(
              (failure) => Left(failure),
              (_) => throw Exception('Unreachable'),
        );
      }
    }

    // All succeeded - extract values
    final progressList = results
        .map((either) => either.getOrElse(() => throw Exception('Unexpected Left')))
        .toList();

    return Right(progressList);
  }
}
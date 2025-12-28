
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget_progress.dart';
import 'package:expenses_tracker_app/features/budget/domain/repositories/budget_repository.dart';

import '../../../expenses/domain/repositories/expense_repository.dart';

class GetBudgetProgress {
  final BudgetRepository budgetRepo;
  final ExpenseRepository expenseRepo;

  GetBudgetProgress(this.budgetRepo, this.expenseRepo);

  Future<Either<Failure, BudgetProgress>> call(String budgetId) async {
    final budgetEither = await budgetRepo.getBudgetById(budgetId);

    return budgetEither.fold(
          (failure) => Left(failure),
          (budget) async {
        final expensesEither = await expenseRepo.getByCategoryAndPeriod(
          budget.category,
          budget.startDate,
          budget.endDate,
        );

        return expensesEither.fold(
              (failure) => Left(failure),
              (expenses) {
            final spent = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
            final percentage = budget.amount == 0 ? 0.0 : (spent / budget.amount) * 100;

            return Right(BudgetProgress(
              budget: budget,
              spent: spent,
              remaining: budget.amount - spent,
              percentageUsed: percentage,
              isOverBudget: spent > budget.amount,
              shouldAlert: percentage >= (budget.alertThreshold ?? 80),
              // No expenses - just calculations
            ));
          },
        );
      },
    );
  }
}
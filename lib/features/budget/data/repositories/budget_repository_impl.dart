import 'package:dartz/dartz.dart';

import 'package:expenses_tracker_app/core/error/failures.dart';

import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';

import 'package:expenses_tracker_app/features/budget/domain/entities/budget_progress.dart';

import '../../../expenses/data/datasources/expense_dao.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;
  final ExpenseDao expenseDao;

  BudgetRepositoryImpl({
    required this.localDataSource,
    required this.expenseDao,
  });

  @override
  Future<Either<Failure, void>> createBudget(Budget budget) async {
    try {
      await localDataSource.createBudget(
        BudgetModel.fromEntity(budget),
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateBudget(Budget budget) async {
    try {
      await localDataSource.updateBudget(
        BudgetModel.fromEntity(budget),
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await localDataSource.deleteBudget(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final budgets = await localDataSource.getBudgets();
      return Right(budgets);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById(String id) async {
    try {
      final budget = await localDataSource.getBudgetById(id);
      if (budget == null) return Left(NotFoundFailure());
      return Right(budget);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, BudgetProgress>> getBudgetProgress(String budgetId) async {
    try {
      final budget = await localDataSource.getBudgetById(budgetId);
      if (budget == null) return Left(NotFoundFailure());

      final expenses = await expenseDao.getExpensesByCategoryAndPeriod(
        budget.category,
        budget.startDate,
        budget.endDate,
      );

      final spent = expenses.fold<double>(
        0,
            (sum, e) => sum + e.amount,
      );

      final remaining = budget.amount - spent;
      final percentageUsed = (spent / budget.amount) * 100;

      return Right(
        BudgetProgress(
          budget: budget,
          spent: spent,
          remaining: remaining,
          percentageUsed: percentageUsed,
          isOverBudget: spent > budget.amount,
          shouldAlert: percentageUsed >= (budget.alertThreshold ?? 80),
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<BudgetProgress>>> getAllBudgetProgress() async {
    try {
      final budgets = await localDataSource.getBudgets();

      final List<BudgetProgress> progressList = [];

      for (final budget in budgets) {
        final expenses = await expenseDao.getExpensesByCategoryAndPeriod(
          budget.category,
          budget.startDate,
          budget.endDate,
        );

        final spent = expenses.fold<double>(
          0,
              (sum, expense) => sum + expense.amount,
        );

        final remaining = budget.amount - spent;
        final double percentageUsed =
        budget.amount == 0 ? 0 : (spent / budget.amount) * 100;

        progressList.add(
          BudgetProgress(
            budget: budget,
            spent: spent,
            remaining: remaining,
            percentageUsed: percentageUsed,
            isOverBudget: spent > budget.amount,
            shouldAlert:
            percentageUsed >= (budget.alertThreshold ?? 80),
          ),
        );
      }

      return Right(progressList);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }


}
import 'package:dartz/dartz.dart';

import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/features/budget/data/mappers/budget_mappers.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget_progress.dart';

import '../../../expenses/data/datasources/expense_dao.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> createBudget(Budget budget) async {
    try {
      await localDataSource.createBudget(budget.toModel());
      return const Right(null);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateBudget(Budget budget) async {
    try {
      await localDataSource.updateBudget(budget.toModel());
      return const Right(null);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      await localDataSource.deleteBudget(id);
      return const Right(null);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final budgets = await localDataSource.getBudgets();
      final entities = budgets.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById(String id) async {
    try {
      final budget = await localDataSource.getBudgetById(id);
      if (budget == null) return Left(NotFoundFailure());
      final entity = budget.toEntity();
      return Right(entity);
    } catch (_) {
      return Left(DatabaseFailure());
    }
  }

}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/budget_progress.dart';
import '../entities/budget.dart';

abstract class BudgetRepository {
  Future<Either<Failure, List<Budget>>> getBudgets();
  Future<Either<Failure, Budget>> getBudgetById(String id);
  Future<Either<Failure, void>> createBudget(Budget budget);
  Future<Either<Failure, void>> updateBudget(Budget budget);
  Future<Either<Failure, void>> deleteBudget(String id);
}


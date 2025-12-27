
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget_progress.dart';
import 'package:expenses_tracker_app/features/budget/domain/repositories/budget_repository.dart';

class GetBudgetProgress implements UseCase<BudgetProgress, IdParams> {
  
  final BudgetRepository repository;
  
  GetBudgetProgress(this.repository);

  @override
  Future<Either<Failure, BudgetProgress>> call(IdParams param) async {
    return await repository.getBudgetProgress(param.id);
  }
  
}
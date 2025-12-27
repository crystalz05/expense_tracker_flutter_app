import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/budget/domain/entities/budget_progress.dart';

import '../repositories/budget_repository.dart';

class GetAllBudgetProgress implements UseCase<List<BudgetProgress>, NoParams> {

  final BudgetRepository repository;
  GetAllBudgetProgress(this.repository);

  @override
  Future<Either<Failure, List<BudgetProgress>>> call(NoParams param) async {
    return await repository.getAllBudgetProgress();
  }
}
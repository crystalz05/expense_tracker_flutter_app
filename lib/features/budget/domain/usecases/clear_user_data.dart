import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import '../repositories/budget_repository.dart';

class ClearUserData extends UseCase<void, NoParams> {
  final BudgetRepository repository;

  ClearUserData(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearUserData();
  }
}

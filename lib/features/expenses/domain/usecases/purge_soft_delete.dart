import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';

/// Permanently removes soft-deleted expenses from both local and remote storage
///
/// This should be called periodically (e.g., monthly) or when user explicitly
/// wants to clean up deleted records. Requires network connection.
class PurgeSoftDeleted extends UseCase<void, NoParams> {
  final ExpenseRepository repository;

  PurgeSoftDeleted(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams param) {
    return repository.purgeSoftDeletedExpenses();
  }
}
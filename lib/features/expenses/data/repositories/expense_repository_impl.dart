import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/network/network_info.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:expenses_tracker_app/features/expenses/data/datasources/expenses_local_datasource.dart';
import 'package:expenses_tracker_app/features/expenses/data/mappers/expense_mappers.dart';
import 'package:expenses_tracker_app/features/expenses/domain/entities/expense.dart';
import 'package:expenses_tracker_app/features/expenses/domain/repositories/expense_repository.dart';
import '../../../auth/domain/user_session/user_session.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpensesLocalDatasource localDatasource;
  final ExpenseRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  final UserSession userSession;

  ExpenseRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.networkInfo,
    required this.userSession,
  });

  // Core principle: Online = sync first, then operate. Offline = operate locally only.

  @override
  Future<Either<Failure, void>> addExpense(Expense expense) async {
    try {
      final model = expense.toModel();
      final userId = userSession.userId;

      if (await networkInfo.isConnected) {
        // Online: Save to remote first, then local
        await remoteDatasource.addExpense(model, userId);
        await localDatasource.addExpense(model);
      } else {
        // Offline: Save locally only
        await localDatasource.addExpense(model);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      final model = expense.toModel();
      final userId = userSession.userId;

      if (await networkInfo.isConnected) {
        // Online: Update remote first, then local
        await remoteDatasource.addExpense(
          model,
          userId,
        ); // Upsert handles updates
        await localDatasource.updateExpense(model);
      } else {
        // Offline: Update locally only
        await localDatasource.updateExpense(model);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteExpense(
    String id,
    DateTime updatedAt,
  ) async {
    try {
      final userId = userSession.userId;

      if (await networkInfo.isConnected) {
        // Online: Soft delete on remote first, then local
        await remoteDatasource.softDeleteExpense(id, userId, updatedAt);
        await localDatasource.softDeleteExpense(id, updatedAt);
      } else {
        // Offline: Soft delete locally only
        await localDatasource.softDeleteExpense(id, updatedAt);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      final userId = userSession.userId;

      if (await networkInfo.isConnected) {
        // Online: Hard delete from remote first, then local
        await remoteDatasource.deleteExpense(id, userId);
        await localDatasource.deleteExpense(id);
      } else {
        // Offline: Hard delete locally only
        await localDatasource.deleteExpense(id);
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String id) async {
    try {
      // Always fetch from local for speed
      final model = await localDatasource.getExpenseById(id);
      if (model == null) {
        return Left(DatabaseFailure("Expense not found"));
      }
      return Right(model.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      // Sync before fetching if online
      if (await networkInfo.isConnected) {
        await _fullSync();
      }

      final models = await localDatasource.getExpenses();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenseByCategory(
    String category,
  ) async {
    try {
      final models = await localDatasource.getExpenseByCategory(category);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await localDatasource.getExpensesByDateRange(start, end);
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getByCategoryAndPeriod(
    String category,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await localDatasource.getByCategoryAndPeriod(
        category,
        start,
        end,
      );
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncExpenses() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      await _fullSync();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Sync failed: $e'));
    }
  }

  // NEW: Permanently delete soft-deleted records
  @override
  Future<Either<Failure, void>> purgeSoftDeletedExpenses() async {
    try {
      final userId = userSession.userId;

      if (await networkInfo.isConnected) {
        // Get all soft-deleted expenses from local
        final allLocal = await localDatasource.getAllExpensesIncludingDeleted();
        final softDeleted = allLocal.where((e) => e.isDeleted).toList();

        // Hard delete from remote
        for (final expense in softDeleted) {
          await remoteDatasource.deleteExpense(expense.id, userId);
        }

        // Hard delete from local
        await localDatasource.purgeSoftDeleted();
      } else {
        return Left(NetworkFailure());
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Purge failed: $e'));
    }
  }

  // Private method for full bidirectional sync
  Future<void> _fullSync() async {
    final userId = userSession.userId;

    // 1. Get all local expenses (including soft-deleted for conflict resolution)
    final localExpenses = await localDatasource
        .getAllExpensesIncludingDeleted();

    // 2. Get all remote expenses
    final remoteExpenses = await remoteDatasource.getExpenses(userId);

    // 3. Build maps for efficient lookup
    final localMap = {for (var e in localExpenses) e.id: e};
    final remoteMap = {for (var e in remoteExpenses) e.id: e};

    // 4. Sync logic using last-write-wins based on updated_at
    final toUpload = <String>[];
    final toDownload = <String>[];

    // Check local items
    for (final local in localExpenses) {
      final remote = remoteMap[local.id];

      if (remote == null) {
        // Exists locally but not remotely - upload
        toUpload.add(local.id);
      } else {
        // Exists in both - compare timestamps (last write wins)
        if (local.updatedAt.isAfter(remote.updatedAt)) {
          toUpload.add(local.id);
        } else if (remote.updatedAt.isAfter(local.updatedAt)) {
          toDownload.add(remote.id);
        }
        // If equal, no action needed
      }
    }

    // Check for remote items not in local
    for (final remote in remoteExpenses) {
      if (!localMap.containsKey(remote.id)) {
        toDownload.add(remote.id);
      }
    }

    // 5. Upload local changes to remote
    if (toUpload.isNotEmpty) {
      final expensesToUpload = toUpload.map((id) => localMap[id]!).toList();
      await remoteDatasource.upsertExpenses(expensesToUpload, userId);
    }

    // 6. Download remote changes to local
    if (toDownload.isNotEmpty) {
      final expensesToDownload = toDownload
          .map((id) => remoteMap[id]!)
          .toList();

      for (final expense in expensesToDownload) {
        // Check if exists locally to determine update vs insert
        if (localMap.containsKey(expense.id)) {
          await localDatasource.updateExpense(expense);
        } else {
          await localDatasource.addExpense(expense);
        }
      }
    }
  }
}

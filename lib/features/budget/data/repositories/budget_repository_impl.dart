import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/domain/user_session/user_session.dart';
import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../datasources/budget_local_datasource.dart';
import '../datasources/budget_remote_datasource.dart';
import '../mappers/budget_mappers.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;
  final BudgetRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserSession userSession;

  BudgetRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.userSession,
  });

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      // Sync first if online
      if (await networkInfo.isConnected) {
        await _fullSync();
      }

      final localBudgets = await localDataSource.getBudgets(userSession.userId);
      final entities = localBudgets.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure('Failed to load budgets'));
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById(String id) async {
    try {
      final budget = await localDataSource.getBudgetById(id);
      if (budget == null) return Left(NotFoundFailure());

      if (budget.userId != userSession.userId) {
        return Left(PermissionFailure());
      }

      return Right(budget.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to load budget'));
    }
  }

  @override
  Future<Either<Failure, void>> createBudget(Budget budget) async {
    try {
      final model = budget.toModel().copyWith(
        userId: userSession.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (await networkInfo.isConnected) {
        // Online: Save remote first, then local
        await remoteDataSource.createBudget(model);
        await localDataSource.createBudget(model.copyWith(needsSync: false));
      } else {
        // Offline: Save locally only
        await localDataSource.createBudget(model.copyWith(needsSync: true));
      }

      return const Right(null);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return Left(DuplicateFailure());
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create budget'));
    }
  }

  @override
  Future<Either<Failure, void>> updateBudget(Budget budget) async {
    try {
      final existing = await localDataSource.getBudgetById(budget.id);
      if (existing == null) return Left(NotFoundFailure());
      if (existing.userId != userSession.userId) {
        return Left(PermissionFailure());
      }

      final model = budget.toModel().copyWith(
        userId: userSession.userId,
        updatedAt: DateTime.now(),
      );

      if (await networkInfo.isConnected) {
        // Online: Update remote first, then local
        await remoteDataSource.updateBudget(model);
        await localDataSource.updateBudget(model.copyWith(needsSync: false));
      } else {
        // Offline: Update locally only
        await localDataSource.updateBudget(model.copyWith(needsSync: true));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update budget'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBudget(String id) async {
    try {
      final existing = await localDataSource.getBudgetById(id);
      if (existing == null) return Left(NotFoundFailure());
      if (existing.userId != userSession.userId) {
        return Left(PermissionFailure());
      }

      final model = existing.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );

      if (await networkInfo.isConnected) {
        // Online: Delete from remote first, then local
        await remoteDataSource.deleteBudget(id);
        await localDataSource.updateBudget(model.copyWith(needsSync: false));
      } else {
        // Offline: Mark deleted locally
        await localDataSource.updateBudget(model.copyWith(needsSync: true));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete budget'));
    }
  }

  @override
  Future<Either<Failure, void>> syncBudgets() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      await _fullSync();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Sync failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> purgeSoftDeletedBudgets() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      final userId = userSession.userId;
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
      final deletedBudgets = await localDataSource.getDeletedBudgets(userId);

      final idsToDelete = deletedBudgets
          .where((b) {
            final deleteTime = b.updatedAt ?? b.createdAt;
            return deleteTime.isBefore(cutoffDate);
          })
          .map((b) => b.id)
          .toList();

      if (idsToDelete.isNotEmpty) {
        // Delete from remote first
        await remoteDataSource.permanentlyDeleteBudgets(idsToDelete);

        // Then from local
        await localDataSource.permanentlyDeleteBudgets(idsToDelete);
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Cleanup failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearUserData() async {
    try {
      await localDataSource.clearUserData(userSession.userId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to clear user data'));
    }
  }

  // Private method for full bidirectional sync
  Future<void> _fullSync() async {
    final userId = userSession.userId;

    // 1. Get all local budgets (including deleted for conflict resolution)
    final localBudgets = await localDataSource.getBudgets(userId);
    final deletedBudgets = await localDataSource.getDeletedBudgets(userId);
    final allLocalBudgets = [...localBudgets, ...deletedBudgets];

    // 2. Get all remote budgets
    final remoteBudgets = await remoteDataSource.getBudgets(userId);

    // 3. Build maps for efficient lookup
    final localMap = {for (var b in allLocalBudgets) b.id: b};
    final remoteMap = {for (var b in remoteBudgets) b.id: b};

    // 4. Sync logic using last-write-wins
    final toUpload = <String>[];
    final toDownload = <String>[];

    // Check local items
    for (final local in allLocalBudgets) {
      final remote = remoteMap[local.id];

      if (remote == null) {
        // Exists locally but not remotely - upload
        toUpload.add(local.id);
      } else {
        // Exists in both - compare timestamps
        final localTime = local.updatedAt ?? local.createdAt;
        final remoteTime = remote.updatedAt ?? remote.createdAt;

        if (localTime.isAfter(remoteTime)) {
          toUpload.add(local.id);
        } else if (remoteTime.isAfter(localTime)) {
          toDownload.add(remote.id);
        }
      }
    }

    // Check for remote items not in local
    for (final remote in remoteBudgets) {
      if (!localMap.containsKey(remote.id)) {
        toDownload.add(remote.id);
      }
    }

    // 5. Upload local changes to remote
    if (toUpload.isNotEmpty) {
      for (final id in toUpload) {
        final budget = localMap[id]!;
        try {
          if (budget.isDeleted) {
            await remoteDataSource.deleteBudget(id);
          } else {
            final remote = await remoteDataSource.getBudgetById(id);
            if (remote == null) {
              await remoteDataSource.createBudget(budget);
            } else {
              await remoteDataSource.updateBudget(budget);
            }
          }

          // Mark as synced
          await localDataSource.updateBudget(
            budget.copyWith(needsSync: false, lastSyncedAt: DateTime.now()),
          );
        } catch (e) {
          // Silent fail - sync will retry on next attempt
        }
      }
    }

    // 6. Download remote changes to local
    if (toDownload.isNotEmpty) {
      for (final id in toDownload) {
        final remote = remoteMap[id]!;
        try {
          final local = localMap[id];

          if (local == null) {
            await localDataSource.createBudget(
              remote.copyWith(needsSync: false, lastSyncedAt: DateTime.now()),
            );
          } else {
            await localDataSource.updateBudget(
              remote.copyWith(needsSync: false, lastSyncedAt: DateTime.now()),
            );
          }
        } catch (e) {
          // Silent fail - sync will retry on next attempt
        }
      }
    }
  }
}

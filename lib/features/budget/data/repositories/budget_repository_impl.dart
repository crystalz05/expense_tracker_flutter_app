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
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;
  final BudgetRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserSession userSession;

  bool _isSyncing = false;
  DateTime? _lastSyncAttempt;
  static const _minSyncInterval = Duration(seconds: 30);

  BudgetRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.userSession,
  });

  @override
  Future<Either<Failure, List<Budget>>> getBudgets() async {
    try {
      final localBudgets = await localDataSource.getBudgets(userSession.userId);
      final entities = localBudgets.map((e) => e.toEntity()).toList();

      _syncInBackground();

      return Right(entities);
    } catch (e) {
      print('Error in getExpenses(): $e');
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Budget>> getBudgetById(String id) async {
    try {
      final budget = await localDataSource.getBudgetById(id);
      if (budget == null) return Left(NotFoundFailure());

      // Verify budget belongs to current user
      if (budget.userId != userSession.userId) {
        return Left(PermissionFailure());
      }

      return Right(budget.toEntity());
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createBudget(Budget budget) async {
    try {
      final model = budget.toModel().copyWith(
        userId: userSession.userId,
        needsSync: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await localDataSource.createBudget(model);

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.createBudget(model);
          await _markAsSynced(model.id);
        } on PostgrestException catch (e) {
          _handlePostgrestError(e, 'create');
        } on TimeoutException {
          // Will retry in background
        } catch (e) {
          print('Sync error: $e');
        }
      }

      return const Right(null);
    } on DatabaseException catch (e) {
      if (e.toString().contains('UNIQUE constraint')) {
        return Left(DuplicateFailure());
      }
      return Left(DatabaseFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
        needsSync: true,
        updatedAt: DateTime.now(),
      );

      await localDataSource.updateBudget(model);

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.updateBudget(model);
          await _markAsSynced(model.id);
        } on PostgrestException catch (e) {
          _handlePostgrestError(e, 'update');
        } catch (e) {
          print('Sync error: $e');
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
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
        needsSync: true,
        updatedAt: DateTime.now(),
      );

      await localDataSource.updateBudget(model);

      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.deleteBudget(id);
          await _markAsSynced(id);
        } catch (e) {
          print('Sync error: $e');
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  Future<Either<Failure, void>> clearUserData() async {
    try {
      await localDataSource.clearUserData(userSession.userId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  Future<void> syncWithRemote() async {
    if (!await networkInfo.isConnected) return;

    try {
      await _pushLocalChanges();
      await _pullRemoteChanges();
      await _cleanupDeletedRecords();
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  Future<void> _pushLocalChanges() async {
    final unsyncedBudgets = await localDataSource.getBudgetsNeedingSync(
        userSession.userId
    );

    for (final budget in unsyncedBudgets) {
      await _syncSingleBudget(budget);
    }
  }

  Future<void> _syncSingleBudget(BudgetModel budget) async {
    var retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        if (budget.isDeleted) {
          await remoteDataSource.deleteBudget(budget.id);
        } else {
          final remote = await remoteDataSource.getBudgetById(budget.id);
          if (remote == null) {
            await remoteDataSource.createBudget(budget);
          } else {
            await remoteDataSource.updateBudget(budget);
          }
        }
        await _markAsSynced(budget.id);
        return;
      } on TimeoutException {
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 2 * retryCount));
        }
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          await _markAsSynced(budget.id);
          return;
        }
        break; // Don't retry other errors
      } catch (e) {
        print('Sync failed for ${budget.id}: $e');
        break;
      }
    }
  }

  Future<void> _pullRemoteChanges() async {
    final remoteBudgets = await remoteDataSource.getBudgets(userSession.userId);

    for (final remote in remoteBudgets) {
      try {
        final local = await localDataSource.getBudgetById(remote.id);

        if (local == null) {
          await localDataSource.createBudget(remote.copyWith(
            needsSync: false,
            lastSyncedAt: DateTime.now(),
          ));
        } else {
          final remoteTime = remote.updatedAt ?? remote.createdAt;
          final localTime = local.updatedAt ?? local.createdAt;

          if (remoteTime.isAfter(localTime) && !local.needsSync) {
            await localDataSource.updateBudget(remote.copyWith(
              needsSync: false,
              lastSyncedAt: DateTime.now(),
            ));
          }
        }
      } catch (e) {
        print('Failed to pull budget ${remote.id}: $e');
      }
    }
  }

  Future<void> _cleanupDeletedRecords() async {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    final deletedBudgets = await localDataSource.getDeletedBudgets(
        userSession.userId
    );

    final idsToDelete = deletedBudgets
        .where((b) {
      final deleteTime = b.updatedAt ?? b.createdAt;
      return deleteTime.isBefore(cutoffDate);
    })
        .map((b) => b.id)
        .toList();

    if (idsToDelete.isNotEmpty) {
      await localDataSource.permanentlyDeleteBudgets(idsToDelete);
      try {
        await remoteDataSource.permanentlyDeleteBudgets(idsToDelete);
      } catch (e) {
        print('Failed to cleanup remote records: $e');
      }
    }
  }

  Future<void> _markAsSynced(String id) async {
    final budget = await localDataSource.getBudgetById(id);
    if (budget != null) {
      await localDataSource.updateBudget(budget.copyWith(
        needsSync: false,
        lastSyncedAt: DateTime.now(),
      ));
    }
  }

  void _syncInBackground() {
    if (_isSyncing) return;

    if (_lastSyncAttempt != null) {
      final timeSinceLastSync = DateTime.now().difference(_lastSyncAttempt!);
      if (timeSinceLastSync < _minSyncInterval) return;
    }

    _lastSyncAttempt = DateTime.now();

    Future.microtask(() async {
      if (_isSyncing) return;

      _isSyncing = true;
      try {
        await syncWithRemote();
      } catch (e) {
        print('Background sync failed: $e');
      } finally {
        _isSyncing = false;
      }
    });
  }

  void _handlePostgrestError(PostgrestException e, String operation) {
    switch (e.code) {
      case '23505':
        print('Duplicate entry during $operation');
      case '42501':
        print('Permission denied during $operation');
      case 'PGRST301':
        print('Row not found during $operation');
      default:
        print('Postgrest error during $operation: ${e.message}');
    }
  }
}
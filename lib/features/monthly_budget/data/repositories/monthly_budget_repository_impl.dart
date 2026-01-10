import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/domain/user_session/user_session.dart';
import '../../domain/entities/monthly_budget.dart';
import '../../domain/repositories/monthly_budget_repository.dart';
import '../datasources/monthly_budget_local_datasource.dart';
import '../datasources/monthly_budget_remote_datasource.dart';
import '../mappers/monthly_budget_mappers.dart';

class MonthlyBudgetRepositoryImpl implements MonthlyBudgetRepository {
  final MonthlyBudgetLocalDataSource localDataSource;
  final MonthlyBudgetRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final UserSession userSession;

  MonthlyBudgetRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.userSession,
  });

  @override
  Future<Either<Failure, List<MonthlyBudget>>> getMonthlyBudgets() async {
    try {
      // Sync first if online
      if (await networkInfo.isConnected) {
        await _fullSync();
      }

      final localBudgets = await localDataSource.getMonthlyBudgets(userSession.userId);
      final entities = localBudgets.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      print('Error in getMonthlyBudgets(): $e');
      return Left(DatabaseFailure('Failed to load monthly budgets'));
    }
  }

  @override
  Future<Either<Failure, MonthlyBudget>> getMonthlyBudgetById(String id) async {
    try {
      final budget = await localDataSource.getMonthlyBudgetById(id);
      if (budget == null) return Left(NotFoundFailure());

      if (budget.userId != userSession.userId) {
        return Left(PermissionFailure());
      }

      return Right(budget.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to load monthly budget'));
    }
  }

  @override
  Future<Either<Failure, MonthlyBudget?>> getMonthlyBudgetByMonthYear(int month, int year) async {
    try {
      final budget = await localDataSource.getMonthlyBudgetByMonthYear(
        userSession.userId,
        month,
        year,
      );

      return Right(budget?.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Failed to load monthly budget'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyBudget>>> getMonthlyBudgetsByYear(int year) async {
    try {
      final budgets = await localDataSource.getMonthlyBudgetsByYear(
        userSession.userId,
        year,
      );
      final entities = budgets.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure('Failed to load monthly budgets'));
    }
  }

  @override
  Future<Either<Failure, void>> createMonthlyBudget(MonthlyBudget monthlyBudget) async {
    try {
      // Check if budget for this month/year already exists
      final existing = await localDataSource.getMonthlyBudgetByMonthYear(
        userSession.userId,
        monthlyBudget.month,
        monthlyBudget.year,
      );

      if (existing != null && !existing.isDeleted) {
        return Left(DuplicateFailure());
      }

      final model = monthlyBudget.toModel().copyWith(
        userId: userSession.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (await networkInfo.isConnected) {
        // Online: Save remote first, then local
        await remoteDataSource.createMonthlyBudget(model);
        await localDataSource.createMonthlyBudget(model.copyWith(needsSync: false));
      } else {
        // Offline: Save locally only
        await localDataSource.createMonthlyBudget(model.copyWith(needsSync: true));
      }

      return const Right(null);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return Left(DuplicateFailure());
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create monthly budget'));
    }
  }

  @override
  Future<Either<Failure, void>> updateMonthlyBudget(MonthlyBudget monthlyBudget) async {
    try {
      final existing = await localDataSource.getMonthlyBudgetById(monthlyBudget.id);
      if (existing == null) return Left(NotFoundFailure());
      if (existing.userId != userSession.userId) {
        return Left(PermissionFailure());
      }

      final model = monthlyBudget.toModel().copyWith(
        userId: userSession.userId,
        updatedAt: DateTime.now(),
      );

      if (await networkInfo.isConnected) {
        // Online: Update remote first, then local
        await remoteDataSource.updateMonthlyBudget(model);
        await localDataSource.updateMonthlyBudget(model.copyWith(needsSync: false));
      } else {
        // Offline: Update locally only
        await localDataSource.updateMonthlyBudget(model.copyWith(needsSync: true));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to update monthly budget'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMonthlyBudget(String id) async {
    try {
      final existing = await localDataSource.getMonthlyBudgetById(id);
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
        await remoteDataSource.deleteMonthlyBudget(id);
        await localDataSource.updateMonthlyBudget(model.copyWith(needsSync: false));
      } else {
        // Offline: Mark deleted locally
        await localDataSource.updateMonthlyBudget(model.copyWith(needsSync: true));
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete monthly budget'));
    }
  }

  @override
  Future<Either<Failure, void>> syncMonthlyBudgets() async {
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
  Future<Either<Failure, void>> purgeSoftDeletedMonthlyBudgets() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      final userId = userSession.userId;
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
      final deletedBudgets = await localDataSource.getDeletedMonthlyBudgets(userId);

      final idsToDelete = deletedBudgets
          .where((b) {
        final deleteTime = b.updatedAt ?? b.createdAt;
        return deleteTime.isBefore(cutoffDate);
      })
          .map((b) => b.id)
          .toList();

      if (idsToDelete.isNotEmpty) {
        await remoteDataSource.permanentlyDeleteMonthlyBudgets(idsToDelete);
        await localDataSource.permanentlyDeleteMonthlyBudgets(idsToDelete);
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

    final localBudgets = await localDataSource.getMonthlyBudgets(userId);
    final deletedBudgets = await localDataSource.getDeletedMonthlyBudgets(userId);
    final allLocalBudgets = [...localBudgets, ...deletedBudgets];

    final remoteBudgets = await remoteDataSource.getMonthlyBudgets(userId);

    final localMap = {for (var b in allLocalBudgets) b.id: b};
    final remoteMap = {for (var b in remoteBudgets) b.id: b};

    final toUpload = <String>[];
    final toDownload = <String>[];

    for (final local in allLocalBudgets) {
      final remote = remoteMap[local.id];

      if (remote == null) {
        toUpload.add(local.id);
      } else {
        final localTime = local.updatedAt ?? local.createdAt;
        final remoteTime = remote.updatedAt ?? remote.createdAt;

        if (localTime.isAfter(remoteTime)) {
          toUpload.add(local.id);
        } else if (remoteTime.isAfter(localTime)) {
          toDownload.add(remote.id);
        }
      }
    }

    for (final remote in remoteBudgets) {
      if (!localMap.containsKey(remote.id)) {
        toDownload.add(remote.id);
      }
    }

    if (toUpload.isNotEmpty) {
      for (final id in toUpload) {
        final budget = localMap[id]!;
        try {
          if (budget.isDeleted) {
            await remoteDataSource.deleteMonthlyBudget(id);
          } else {
            final remote = await remoteDataSource.getMonthlyBudgetById(id);
            if (remote == null) {
              await remoteDataSource.createMonthlyBudget(budget);
            } else {
              await remoteDataSource.updateMonthlyBudget(budget);
            }
          }

          await localDataSource.updateMonthlyBudget(
            budget.copyWith(
              needsSync: false,
              lastSyncedAt: DateTime.now(),
            ),
          );
        } catch (e) {
          print('Failed to upload monthly budget $id: $e');
        }
      }
    }

    if (toDownload.isNotEmpty) {
      for (final id in toDownload) {
        final remote = remoteMap[id]!;
        try {
          final local = localMap[id];

          if (local == null) {
            await localDataSource.createMonthlyBudget(
              remote.copyWith(
                needsSync: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
          } else {
            await localDataSource.updateMonthlyBudget(
              remote.copyWith(
                needsSync: false,
                lastSyncedAt: DateTime.now(),
              ),
            );
          }
        } catch (e) {
          print('Failed to download monthly budget $id: $e');
        }
      }
    }
  }
}
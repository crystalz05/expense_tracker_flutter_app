import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:expenses_tracker_app/features/auth/domain/user_session/user_session.dart';
import 'package:expenses_tracker_app/features/user_profile/data/data_sources/user_profile_cache_datasource.dart';
import 'package:expenses_tracker_app/features/user_profile/data/mappers/profile_mappers.dart';
import 'package:expenses_tracker_app/features/user_profile/data/models/user_profile_model.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../data_sources/user_profile_remote_datasource.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDatasource remoteDataSource;
  final UserProfileCacheDataSource cacheDataSource;
  final NetworkInfo networkInfo;
  final UserSession userSession;

  UserProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheDataSource,
    required this.networkInfo,
    required this.userSession,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      if (await networkInfo.isConnected) {
        final remoteProfile = await remoteDataSource.getUserProfile(
          userSession.userId,
        );

        await cacheDataSource.cacheProfile(remoteProfile);

        return Right(remoteProfile.toEntity());
      }
      return await _getProfileFromCache();
    } on ServerException catch (e, stack) {
      _logError('Remote profile fetch failed', e, stack);
      return await _getProfileFromCacheOrFail(e.message);
    } on CacheException catch (e, stack) {
      _logError('Cache error', e, stack);
      return Left(CacheFailure(e.message));
    } catch (e, stack) {
      _logError('Unexpected error', e, stack);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> createUserProfile() async {
    try {
      final profile = UserProfile(
        userId: userSession.userId,
        createAt: DateTime.now(),
      );

      if (await networkInfo.isConnected) {
        final profileModel = UserProfileModel.fromEntity(profile);
        final createdProfile = await remoteDataSource.createUserProfile(
          profileModel,
        );
        await cacheDataSource.cacheProfile(createdProfile);

        return Right(createdProfile.toEntity());
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } on ServerException catch (e, stack) {
      _logError('Remote profile fetch failed', e, stack);
      return Left(ServerFailure(e.message));
    } catch (e, stack) {
      _logError('Unexpected error', e, stack);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile(
    UserProfile profile,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      final model = UserProfileModel.fromEntity(profile);
      final updated = await remoteDataSource.updateUserProfile(model);

      await cacheDataSource.cacheProfile(updated);

      return Right(updated.toEntity());
    } on ServerException catch (e, stack) {
      _logError('Update profile failed', e, stack);
      return Left(ServerFailure(e.message));
    } catch (e, stack) {
      _logError('Unexpected error', e, stack);
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> uploadProfilePhoto(
    File photoFile,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      final profileModel = await remoteDataSource.uploadProfilePhoto(
        userSession.userId,
        photoFile,
      );
      await cacheDataSource.cacheProfile(profileModel);
      return Right(profileModel.toEntity());
    } on ServerException catch (e, stack) {
      _logError("Profile photo upload failed", e, stack);
      return Left(ServerFailure(e.message));
    } catch (e, stack) {
      _logError("Unexpected error", e, stack);
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserProfile>> _getProfileFromCache() async {
    final cached = await cacheDataSource.getCachedProfile(userSession.userId);
    if (cached != null) {
      return Right(cached.toEntity());
    }
    return Left(CacheFailure('No cached profile available'));
  }

  Future<Either<Failure, UserProfile>> _getProfileFromCacheOrFail(
    String reason,
  ) async {
    final cached = await cacheDataSource.getCachedProfile(userSession.userId);
    if (cached != null) {
      return Right(cached.toEntity());
    }
    return Left(ServerFailure(reason));
  }

  void _logError(String message, Object error, StackTrace stack) {
    debugPrint(message);
    debugPrint('Error: $error');
    debugPrintStack(stackTrace: stack);
  }

  @override
  Future<Either<Failure, void>> deleteProfilePhoto(String photoUrl) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.deleteProfilePhoto(userSession.userId, photoUrl);
      await cacheDataSource.clearCache();
      return const Right(null);
    } on ServerException catch (e, stack) {
      _logError('Delete profile photo failed', e, stack);
      return Left(ServerFailure(e.message));
    } catch (e, stack) {
      _logError('Unexpected error', e, stack);
      return Left(UnknownFailure(e.toString()));
    }
  }
}

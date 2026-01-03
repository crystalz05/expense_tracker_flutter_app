import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';

import '../../../../core/error/failures.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, UserProfile>> createUserProfile(UserProfile profile);
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, UserProfile>> uploadProfilePhoto(File photoFile);
  Future<Either<Failure, void>> deleteProfilePhoto(String photoUrl);
}
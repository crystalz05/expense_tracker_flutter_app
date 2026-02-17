import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/repositories/user_profile_repository.dart';

class DeleteProfilePhoto extends UseCase<void, String> {
  final UserProfileRepository repository;

  DeleteProfilePhoto(this.repository);

  @override
  Future<Either<Failure, void>> call(String param) async {
    return await repository.deleteProfilePhoto(param);
  }
}

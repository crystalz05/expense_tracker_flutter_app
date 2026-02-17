import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateUserProfile extends UseCase<UserProfile, UserProfile> {
  final UserProfileRepository repository;

  UpdateUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UserProfile param) async {
    return repository.updateUserProfile(param);
  }
}

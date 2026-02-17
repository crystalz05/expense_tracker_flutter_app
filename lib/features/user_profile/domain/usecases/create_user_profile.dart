import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:expenses_tracker_app/features/user_profile/domain/repositories/user_profile_repository.dart';

class CreateUserProfile extends UseCase<UserProfile, NoParams> {
  final UserProfileRepository repository;

  CreateUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams param) async {
    return await repository.createUserProfile();
  }
}

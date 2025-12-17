import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user.dart';

class GetCurrentUser extends UseCase<User?, NoParams> {

  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams param) async {
    return await repository.getCurrentUser();
  }
}
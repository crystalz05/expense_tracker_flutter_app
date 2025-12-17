import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/auth/domain/entities/user.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class SignUp implements UseCase<User, SignUpParams> {

  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams param) async {
    return await repository.signUp(param.email, param.password, param.displayName);
  }

}
import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordResetEmail implements UseCase<void, EmailParams> {
  final AuthRepository repository;

  SendPasswordResetEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(EmailParams param) async {
    return await repository.sendPasswordResetEmail(param.email);
  }
}

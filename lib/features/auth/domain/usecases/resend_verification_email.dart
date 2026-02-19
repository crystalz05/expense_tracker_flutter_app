import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class ResendVerificationEmail implements UseCase<void, EmailParams> {
  final AuthRepository repository;

  ResendVerificationEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(EmailParams param) async {
    return await repository.resendVerificationEmail(param.email);
  }
}

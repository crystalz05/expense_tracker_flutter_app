import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(
    String email,
    String password,
    String? displayName,
  );
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> get authStateChanges;
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> resetPassword(String newPassword);
  Future<Either<Failure, void>> resendVerificationEmail(String email);
}

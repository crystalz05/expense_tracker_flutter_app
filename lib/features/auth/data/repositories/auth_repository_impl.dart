import 'package:dartz/dartz.dart';
import 'package:expenses_tracker_app/core/error/exceptions.dart';
import 'package:expenses_tracker_app/core/error/failures.dart';
import 'package:expenses_tracker_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:expenses_tracker_app/features/auth/domain/entities/user.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{

  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);


  @override
  Stream<User?> get authStateChanges{
    return remoteDatasource.authStateChanges;
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try{
      final user = await remoteDatasource.getCurrentUser();
      return Right(user);
    }on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }catch(e) {
      return Left(AuthFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {

    try {
      final user =await remoteDatasource.signIn(email, password);
      return Right(user);
    }on AuthException catch (e){
      return Left(AuthFailure(e.message));
    }catch (e){
      return Left(AuthFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try{
      await remoteDatasource.signOut();
      return Right(null);
    }on AuthException catch (e){
      return Left(AuthFailure(e.message));
    }catch (e){
      return Left(AuthFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password, String? displayName) async {

    try{
      final user = await remoteDatasource.signUp(email, password, displayName);
      return Right(user);
    }on AuthException catch (e){
      return Left(AuthFailure(e.message));
    }catch(e){
      return Left(AuthFailure("Unexpected error: ${e.toString()}"));
    }
  }

}
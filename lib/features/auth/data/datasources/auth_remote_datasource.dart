

import '../models/user_model.dart';

abstract class AuthRemoteDatasource {

  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String? displayName);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
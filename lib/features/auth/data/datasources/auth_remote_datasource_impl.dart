
import 'package:expenses_tracker_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {

  final SupabaseClient supabase;
  AuthRemoteDatasourceImpl(this.supabase);

  @override
  Stream<UserModel?> get authStateChanges {
    return supabase.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      return user != null ? UserModel.fromSupabaseUser(user): null;
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try{
      final user = supabase.auth.currentUser;
      return user != null ? UserModel.fromSupabaseUser(user): null;
    }catch (e){
      throw AuthException("Failed to get current user: ${e.toString()}");
    }
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try{
      final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password);

      if(response.user == null){
        throw AuthException("Sign in failed");
      }
      return UserModel.fromSupabaseUser(response.user!);
    }on PostgrestException catch (e){
      throw AuthException(e.message);
    }catch (e){
      throw AuthException("Sign in failed: ${e.toString()}");
    }
  }

  @override
  Future<void> signOut() async {
    try{
      await supabase.auth.signOut();
    }catch (e){
      throw AuthException("Sign out Failed ${e.toString()}");
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String? displayName) async {

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );

      if (response.user == null) {
        throw AuthException("Sign up failed");
      }

      return UserModel.fromSupabaseUser(response.user!);
    }on PostgrestException catch (e){
      throw AuthException(e.message);
    }catch (e){
      throw AuthException("Sign up failed: ${e.toString()}");
    }
  }
}
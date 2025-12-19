import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_session.dart';

abstract class UserSession {
  String get userId;
}

class UserSessionImpl implements UserSession {
  final SupabaseClient supabase;

  UserSessionImpl(this.supabase);

  @override
  String get userId {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    return user.id;
  }
}
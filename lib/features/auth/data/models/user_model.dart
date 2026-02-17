import 'package:expenses_tracker_app/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    required super.createdAt,
  });

  factory UserModel.fromSupabaseUser(supabase.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? "",
      displayName: user.userMetadata?['display_name'] as String?,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

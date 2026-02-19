import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  final DateTime? emailConfirmedAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
    this.emailConfirmedAt,
  });

  bool get isEmailVerified => emailConfirmedAt != null;

  @override
  List<Object?> get props => [id, email, displayName, createdAt, emailConfirmedAt];
}

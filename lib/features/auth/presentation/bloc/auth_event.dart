import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class AuthSignOutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final dynamic user;

  AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthResetPasswordRequested extends AuthEvent {
  final String newPassword;

  AuthResetPasswordRequested({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class AuthResendVerificationRequested extends AuthEvent {
  final String email;

  AuthResendVerificationRequested({required this.email});

  @override
  List<Object?> get props => [email];
}


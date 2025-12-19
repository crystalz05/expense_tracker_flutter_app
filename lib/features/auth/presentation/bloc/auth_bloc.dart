import 'dart:async';

import 'package:expenses_tracker_app/core/usecases/usecase.dart';
import 'package:expenses_tracker_app/features/auth/domain/entities/user.dart';
import 'package:expenses_tracker_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:expenses_tracker_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:expenses_tracker_app/features/auth/domain/usecases/sign_in.dart';
import 'package:expenses_tracker_app/features/auth/domain/usecases/sign_out.dart';
import 'package:expenses_tracker_app/features/auth/domain/usecases/sign_up.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:expenses_tracker_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final AuthRepository authRepository;

  StreamSubscription<User?>? _authSubscription;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.getCurrentUser,
    required this.authRepository
  }): super(AuthInitial()){
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthUserChanged>(_onUserChanged);

    _authSubscription = authRepository.authStateChanges.listen((user){
      add(AuthUserChanged(user));
    });
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) {
          if(user != null){
            emit(AuthAuthenticated(user));
          }else {
            emit(AuthUnauthenticated());
          }
        }
    );
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signIn(SignInParams(email: event.email, password: event.password));

    result.fold(
            (failure) => emit(AuthError(failure.message)),
            (user) => emit(AuthAuthenticated(user))
    );
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signUp(
        SignUpParams(
            email: event.email,
            password: event.password,
            displayName: event.displayName
        )
    );
    result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user))
    );
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signOut(NoParams());

    result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(AuthUnauthenticated())
    );
  }

  void _onUserChanged(
      AuthUserChanged event,
      Emitter<AuthState> emit,
      ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
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
    on<AuthCheckRequested>();
    on<AuthSignInRequested>();
    on<AuthSignUpRequested>();
    on<AuthSignOutRequested>();
    on<AuthUserChanged>();

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
        (failure) => emit(AuthUnauthenticated()),
        (user) {
          if(user != null){
            emit(AuthAuthenticated(user));
          }else {
            emit(AuthUnauthenticated());
          }
        }
    );
  }


}
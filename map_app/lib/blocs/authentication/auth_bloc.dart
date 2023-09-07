import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const UnauthenticatedAuth()) {
    on<AccountDeleteRequested>(
      (event, emit) async {
        await _authRepository.deleteAccount();
        emit(const UnauthenticatedAuth());
      },
    );

    on<AuthenticationRequested>((event, emit) async {
      emit(LoadingAuth());
      User? user = await _authRepository.getCurrentUser().first;
      if (user != null) {
        emit(AuthenticatedAuth(firebaseUser: user));
      } else {
        emit(const UnauthenticatedAuth());
      }
    });

    on<SignUpRequested>(
      (event, emit) async {
        emit(LoadingAuth());
        try {
          await _authRepository.signUp(
              email: event.email, password: event.password);
          User? user = await _authRepository.getCurrentUser().first;
          if (user != null) {
            emit(AuthenticatedAuth(firebaseUser: user));
          }
        } on Exception catch (e) {
          emit(UnauthenticatedAuth(exception: e));
        }
      },
    );

    on<SignOutRequested>(
      (event, emit) async {
        await _authRepository.signOut();
        emit(const UnauthenticatedAuth());
      },
    );

    on<SignInRequested>(
      (event, emit) async {
        emit(LoadingAuth());
        try {
          await _authRepository.signIn(
              email: event.email, password: event.password);
          User? user = await _authRepository.getCurrentUser().first;
          if (user != null) {
            emit(AuthenticatedAuth(firebaseUser: user));
          }
        } on Exception catch (e) {
          emit(UnauthenticatedAuth(exception: e));
        }
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/repositories/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnauthenticatedAuth()) {
    on<AuthenticationRequested>((event, emit) async {
      emit(LoadingAuth());
      User? user = await authRepository.getCurrentUser().first;
      if (user != null) {
        emit(AuthenticatedAuth(firebaseUser: user));
      }
      emit(UnauthenticatedAuth());
    });

    on<SignUpRequested>(
      (event, emit) async {
        emit(LoadingAuth());
        try {
          await authRepository.signUp(
              email: event.email, password: event.password);
          User? user = await authRepository.getCurrentUser().first;
          if (user != null) {
            emit(AuthenticatedAuth(firebaseUser: user));
          }
        } catch (e) {
          emit(UnauthenticatedAuth());
        }
      },
    );

    on<SignOutRequested>(
      (event, emit) async {
        await authRepository.signOut();
        emit(UnauthenticatedAuth());
      },
    );

    on<SignInRequested>(
      (event, emit) async {
        emit(LoadingAuth());
        try {
          await authRepository.signIn(
              email: event.email, password: event.password);
          User? user = await authRepository.getCurrentUser().first;
          if (user != null) {
            emit(AuthenticatedAuth(firebaseUser: user));
          }
        } catch (e) {
          emit(UnauthenticatedAuth());
        }
      },
    );
  }
}

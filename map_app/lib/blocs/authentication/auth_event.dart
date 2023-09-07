import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationRequested extends AuthEvent {
  const AuthenticationRequested();

  @override
  List<Object> get props => [];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested(this.email, this.password);

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [];
}

class AccountDeleteRequested extends AuthEvent {
  const AccountDeleteRequested();

  @override
  List<Object> get props => [];
}

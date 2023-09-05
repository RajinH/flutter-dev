import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class LoadingAuth extends AuthState {
  @override
  List<Object?> get props => [];
}

class UnauthenticatedAuth extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthenticatedAuth extends AuthState {
  final User? firebaseUser;

  const AuthenticatedAuth({this.firebaseUser});

  @override
  List<Object?> get props => [firebaseUser];
}

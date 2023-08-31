import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // listening to current user state
  Stream<User?> get user => _firebaseAuth.userChanges();

  // sign up using firebase auth
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      return user;
    } catch (_) {
      throw Exception('user creation problem');
    }
  }

  // log in using firebase auth
  Future<User?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      return user;
    } catch (_) {
      throw Exception('user log in problem');
    }
  }

  // sign out using firebase auth
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

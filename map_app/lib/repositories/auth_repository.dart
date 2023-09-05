import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> getCurrentUser() {
    return _firebaseAuth.authStateChanges();
  }

  // firebase sign in
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else if (e.code == 'user-disabled') {
        throw UserDisabledException();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // firebase sign up
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailInUseException();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // firebase sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}

class WrongPasswordException implements Exception {}

class UserDisabledException implements Exception {}

class UserNotFoundException implements Exception {}

class EmailInUseException implements Exception {}

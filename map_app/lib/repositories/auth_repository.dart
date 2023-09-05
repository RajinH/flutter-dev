import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> getCurrentUser() {
    return _firebaseAuth.authStateChanges();
  }

  // firebase sign in
  Future<void> signIn({required String email, required String password}) async {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Account does not exist');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // firebase sign up
  Future<void> signUp({required String email, required String password}) async {
    try {
      _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Weak password');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The email is in use');
      }
    } catch (e) {
      throw Exception(e.toString());
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

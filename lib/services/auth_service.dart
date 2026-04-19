import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> signInWithGoogle() async {
    // TODO: Add Google sign-in implementation.
  }

  Future<void> signInWithFacebook() async {
    // TODO: Add Facebook sign-in implementation.
  }
}

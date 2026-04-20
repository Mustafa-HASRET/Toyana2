import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Google ile giriş işlemi iptal edildi.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success && result.accessToken != null) {
      final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      return _firebaseAuth.signInWithCredential(credential);
    }

    if (result.status == LoginStatus.cancelled) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Facebook ile giriş işlemi iptal edildi.',
      );
    }

    throw FirebaseAuthException(
      code: 'ERROR_FACEBOOK_LOGIN_FAILED',
      message: result.message ?? 'Facebook ile giriş yapılamadı.',
    );
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService authService;
  bool _isLoading = false;
  String? errorMessage;

  LoginViewModel({AuthService? authService})
      : authService = authService ?? AuthService();

  bool get isLoading => _isLoading;

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await authService.signInWithEmailAndPassword(email, password);
      errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Giriş sırasında hata oluştu.';
      return false;
    } catch (_) {
      errorMessage = 'Beklenmeyen bir hata oluştu.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginAsGuest() async {
    _setLoading(true);
    try {
      await authService.signInAnonymously();
      errorMessage = null;
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Misafir girişi başarısız oldu.';
      return false;
    } catch (_) {
      errorMessage = 'Beklenmeyen bir hata oluştu.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoggedIn = false;
  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = FirebaseAuth.instance.currentUser;
    isLoggedIn = user != null;
    notifyListeners();
  }

  bool isLoading = false;

  bool isLoginPasswordObscure = true;
  bool isRegisterPasswordObscure = true;
  bool isRegisterConfirmPasswordObscure = true;

  void toggleLoginPassword() {
    isLoginPasswordObscure = !isLoginPasswordObscure;
    notifyListeners();
  }

  void toggleRegisterPassword() {
    isRegisterPasswordObscure = !isRegisterPasswordObscure;
    notifyListeners();
  }

  void toggleRegisterConfirmPassword() {
    isRegisterConfirmPasswordObscure = !isRegisterConfirmPasswordObscure;
    notifyListeners();
  }

  Future<String> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();
      await Future.delayed(Duration(seconds: 2));
      await _authService.login(email, password);
      return 'Login Successful';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (_) {
      return 'Something went wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> register(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.register(email, password);
      return 'Registration Successful';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (_) {
      return 'Something went wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> signOut() async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.logout();
      return 'Logout Successful';
    } catch (_) {
      return 'Something went wrong';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

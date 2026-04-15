import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthStatus _status = AuthStatus.initial;
  User?      _firebaseUser;
  String?    _backendToken;
  String?    _errorMessage;
  String?    _tempEmail;
  String?    _tempPassword;

  AuthStatus get status       => _status;
  User?      get firebaseUser => _firebaseUser;
  String?    get backendToken => _backendToken;
  String?    get errorMessage => _errorMessage;
  bool       get isLoading    => _status == AuthStatus.loading;

  void _setLoading() {
    _status = AuthStatus.loading;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _setLoading();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;

      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();

      _tempEmail = email;
      _tempPassword = password;

      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }
}

//wywolanie funkcji odpowiedzialnych za zalogowanie sie i zwrocenie danych
//wywolanie funkcji pobierajacych dane uzytkownikow i zwracajace bledy

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  // ignore: prefer_final_fields
  FirebaseAuth _auth = FirebaseAuth.instance;
  //final AuthService _authService = AuthService();

  Stream<User?> get userStream {
    return _auth.authStateChanges();
  }

  Future<void> logOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw SignInEmailPasswordError.fromCode(e.code);
    }
  }

  Future<void> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String displayName}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_auth.currentUser!.displayName == null) {
        await _auth.currentUser!.updateDisplayName(displayName);
      }
    } on FirebaseAuthException catch (e) {
      throw SignUpEmailPasswordError.fromCode(e.code);
    }
  }
}

class SignInEmailPasswordError implements Exception {
  SignInEmailPasswordError([this.message = 'Unknown exception occured!']);

  final String message;

  factory SignInEmailPasswordError.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return SignInEmailPasswordError('Invalid email!');
      case 'user-disabled':
        return SignInEmailPasswordError('User account is disabled!');
      case 'user-not-found':
        return SignInEmailPasswordError(
            'User not found! Create account first!');
      case 'wrong-password':
        return SignInEmailPasswordError('Invalid password!');
      default:
        return SignInEmailPasswordError();
    }
  }
}

class SignUpEmailPasswordError implements Exception {
  SignUpEmailPasswordError([this.message = 'Unknown exception occured']);

  final String message;

  factory SignUpEmailPasswordError.fromCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return SignUpEmailPasswordError('Account already exists!');
      case 'invalid-email':
        return SignUpEmailPasswordError('Email is invalid!');
      case 'operation-not-allowed':
        return SignUpEmailPasswordError(
            'Operation not allowed! Try login with provider!');
      case 'weak-password':
        return SignUpEmailPasswordError(
            'Password is weak, choose better password!');
      default:
        return SignUpEmailPasswordError();
    }
  }
}

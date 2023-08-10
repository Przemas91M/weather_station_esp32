import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // ignore: prefer_final_fields
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user {
    return _auth.currentUser;
  }

  Stream<User?> get userStream {
    return _auth.authStateChanges();
  }

// sign in with email
  Future<void> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code.toString());
    }
  }
// sign in with google

//sign up with email
  Future<void> signUpWithEmailPassword(
      String email, String password, String displayName) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_auth.currentUser!.displayName == null) {
        await _auth.currentUser?.updateDisplayName(displayName);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code.toString());
    }
  }
//sign up with google

// logout
  Future<void> logOut() async {
    try {
      _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }
}

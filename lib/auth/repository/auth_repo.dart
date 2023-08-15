//wywolanie funkcji odpowiedzialnych za zalogowanie sie i zwrocenie danych
//wywolanie funkcji pobierajacych dane uzytkownikow i zwracajace bledy

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_station_esp32/auth/repository/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Stream<User?> get userStream {
    return _authService.userStream;
  }

  Future<void> logOut() async {
    try {
      _authService.logOut();
    } catch (e) {
      //TODO zwracac kod bledu stringiem albo klasa
      print(e.toString());
    }
  }

  Future<void> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      _authService.signInWithEmailPassword(email, password);
    } catch (e) {
      //TODO zwracac stan bledu z kodem
      print(e.toString());
    }
  }

  Future<void> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String displayName}) async {
    try {
      await _authService.signUpWithEmailPassword(email, password, displayName);
    } catch (e) {
      //TODO zwracac stan bledu
      print(e.toString());
    }
  }
}

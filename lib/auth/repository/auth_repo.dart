//wywolanie funkcji odpowiedzialnych za zalogowanie sie i zwrocenie danych
//wywolanie funkcji pobierajacych dane uzytkownikow i zwracajace bledy

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_station_esp32/auth/repository/auth_service.dart';

class AuthRepository {
  AuthService authService = AuthService();

  Stream<User?> get userStream {
    return authService.userStream;
  }

  Future<void> logOut() async {
    try {
      authService.logOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      authService.signInWithEmailPassword(email, password);
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
      await authService.signUpWithEmailPassword(email, password, displayName);
    } catch (e) {
      //TODO zwracac stan bledu
      print(e.toString());
    }
  }
}

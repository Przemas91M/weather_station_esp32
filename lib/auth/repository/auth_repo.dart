//wywolanie funkcji odpowiedzialnych za zalogowanie sie i zwrocenie danych
//wywolanie funkcji pobierajacych dane uzytkownikow i zwracajace bledy

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_station_esp32/auth/repository/auth_service.dart';

import '../models/user.dart';

class AuthRepository {
  UserModel? _currentUser;
  AuthService authService = AuthService();

  //TODO zobaczyc czy bedzie mi to potrzebne
  User? get user {
    return authService.user;
  }

  // TODO to mozna by przetlumaczyc w samym bloc-u i przekazywac do stanu
  UserModel? get currentUser {
    return _currentUser;
  }

  Stream<User?> get userStream {
    return authService.userStream;
  }

  Future<void> signInWithEmailPassword(
      {required String email, required String password}) async {
    try {
      authService.signInWithEmailPassword(email, password);
      final User? user = authService.user;
      //zastanowic sie czy to jest jeszcze potrzebne
      if (user != null) {
        _currentUser =
            UserModel(name: user.displayName, uid: user.uid, email: user.email);
      }
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

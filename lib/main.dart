import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';

import 'bloc/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepository = AuthRepository();
  runApp(App(authRepository: authRepository));
}

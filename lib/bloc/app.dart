import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/auth/bloc/auth_bloc.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';
import 'package:weather_station_esp32/auth/view/sign_in_page.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:weather_station_esp32/weather/view/weather_main_page.dart';

import 'app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key, required AuthRepository authRepository})
      : _authRepository = authRepository;

  final AuthRepository _authRepository;
// tutaj bedzie wybierany screen startowy - albo zaczynamy od login albo od razu przechodzimy do podgladu pogody
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<AppBloc>(
          create: (context) => AppBloc(authRepository: _authRepository))
    ], child: const AppView());
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            textTheme: const TextTheme(
                bodyLarge:
                    TextStyle(color: ColorPalette.midBlue, fontSize: 20.0),
                bodyMedium: TextStyle(color: ColorPalette.midBlue))),
        home: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => current.status != AuthStatus.error,
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return const WeatherMainPage();
            } else if (state.status == AuthStatus.loading) {
              return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: CircularProgressIndicator(),
                  ));
            }
            return const SignInPage();
          },
        ));
  }
}

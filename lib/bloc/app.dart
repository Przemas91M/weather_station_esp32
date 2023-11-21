import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';
import 'package:weather_station_esp32/auth/view/sign_in_page.dart';
import 'package:weather_station_esp32/auth/view/sign_up_page.dart';
import 'package:weather_station_esp32/settings/repository/settings_repo.dart';
import 'package:weather_station_esp32/settings/view/settings_screen.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
import 'package:weather_station_esp32/weather/view/weather_main_page.dart';

import '../settings/bloc/settings_bloc.dart';
import 'app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

// tutaj bedzie wybierany screen startowy - albo zaczynamy od login albo od razu przechodzimy do podgladu pogody
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => SettingsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
              create: (context) =>
                  AppBloc(authRepository: context.read<AuthRepository>())),
          BlocProvider<SettingsBloc>(
              create: (context) =>
                  SettingsBloc(settingsRepo: context.read<SettingsRepository>())
                    ..add(Initialize()))
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    bool theme =
        context.watch<SettingsBloc>().settingsMap['darkTheme'] ?? false;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/signIn': (context) => const SignInPage(),
          '/signUp': (context) => const SignUpPage(),
          '/homePage': (context) => const WeatherMainPage(),
          '/settings': (context) => const SettingsScreen()
        },
        theme: ThemeData(
            textTheme: const TextTheme(
                bodyLarge:
                    TextStyle(color: ColorPalette.midBlue, fontSize: 20.0),
                bodyMedium: TextStyle(color: ColorPalette.midBlue))),
        themeMode: theme ? ThemeMode.dark : ThemeMode.light,
        home: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
          if (state is Authenticated) {
            return RepositoryProvider(
              create: (context) => WeatherRepository(),
              child: const WeatherMainPage(),
            );
          } else {
            return const SignInPage();
          }
        }));
  }
}

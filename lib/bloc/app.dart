import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:weather_station_esp32/auth/repository/auth_repo.dart';
import 'package:weather_station_esp32/auth/view/sign_in_page.dart';
import 'package:weather_station_esp32/auth/view/sign_up_page.dart';
import 'package:weather_station_esp32/settings/repository/settings_repo.dart';
import 'package:weather_station_esp32/settings/view/settings_screen.dart';
import 'package:weather_station_esp32/style/styling.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
import 'package:weather_station_esp32/weather/view/weather_main_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('pl'), // Polish
        ],
        routes: {
          '/signIn': (context) => const SignInPage(),
          '/signUp': (context) => const SignUpPage(),
          '/homePage': (context) => const WeatherMainPage(),
          '/settings': (context) => const SettingsScreen()
        },
        theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light().copyWith(
                primary: ColorPalette.lightBlue,
                background: Colors.grey.shade300,
                outline: ColorPalette.lightBlue,
                secondary: ColorPalette.lightBlue,
                surface: Colors.white),
            iconTheme: const IconThemeData(color: ColorPalette.lightBlue),
            dividerColor: Colors.grey,
            appBarTheme: AppBarTheme(
                surfaceTintColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 5.0,
                shadowColor: ColorPalette.lightBlue,
                iconTheme: const IconThemeData(color: ColorPalette.lightBlue),
                titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500)),
            textTheme: const TextTheme().copyWith(
              //text used in card titles, bold text
              displayMedium:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              //text used to show big temperature readings
              displayLarge: const TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.normal),
              //text used to show condition text,
              displaySmall: const TextStyle(fontSize: 20.0),
              //normal text to show readings
              bodyLarge: const TextStyle(fontWeight: FontWeight.w500),
              bodyMedium:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
            )),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          iconTheme: const IconThemeData(color: Colors.white),
          colorScheme: const ColorScheme.dark().copyWith(
              primary: Colors.black,
              secondary: Colors.white,
              outline: Colors.white,
              background: Colors.blueGrey.shade900),
          appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.black,
              shadowColor: Colors.white,
              elevation: 5.0,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500)),
          dividerColor: Colors.white,
          textTheme: const TextTheme().copyWith(
              //text used in card titles, bold text
              displayMedium: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
              //text used to show big temperature readings
              displayLarge: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.normal),
              //text used to show condition text,
              displaySmall:
                  const TextStyle(color: Colors.white, fontSize: 20.0),
              //normal text to show readings
              bodyLarge: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
              bodySmall: const TextStyle(color: Colors.white)),
        ),
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

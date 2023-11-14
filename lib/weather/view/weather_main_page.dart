import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:weather_station_esp32/weather/bloc/weather_bloc.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
import 'package:weather_station_esp32/weather/widgets/forecast_card.dart';
import 'package:weather_station_esp32/weather/widgets/forecast_list.dart';
import 'package:weather_station_esp32/weather/widgets/station_readings.dart';
import 'package:weather_station_esp32/weather/widgets/summary_card.dart';

import '../../bloc/app_bloc.dart';

class WeatherMainPage extends StatelessWidget {
  const WeatherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          WeatherBloc(weatherRepository: context.read<WeatherRepository>())
            ..add(InitializeWeather()),
      child: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    User user = context.select((AppBloc bloc) => bloc.state.user!);

    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(
              child:
                  CircularProgressIndicator()); // TODO add better loading animation
        } else if (state is WeatherLoadError) {
          return const Text('App loading error!');
        } else if (state is WeatherLoadSuccess) {
          return Scaffold(
            drawer: _Drawer(user: user), //TODO add drawer items and widgets
            appBar: AppBar(
              flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10))),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: ColorPalette.midBlue,
              actions: [
                IconButton(
                    onPressed: () =>
                        context.read<AppBloc>().add(AppLogOutRequested()),
                    icon: const Icon(Icons.exit_to_app))
              ],
              title: const Text(
                'Koszalin',
              ),
              titleTextStyle: const TextStyle(
                  color: ColorPalette.midBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              centerTitle: true,
            ),
            body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white,
                Color.fromARGB(255, 208, 208, 208)
              ], begin: Alignment.topCenter, end: Alignment.bottomRight)),
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10.0, right: 25.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  //big widget showing current weather from station
                  StationReadingsCard(reading: state.stationReadings.last),
                  const SizedBox(height: 30.0),
                  const WeatherSummaryCard(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  //second big widget with weather from forecast
                  //next a list with weather forecast for 7 days, depending on location selected

                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3.5),
                    child: const Text('7 day forecast:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  const SizedBox(height: 5),
                  const ForecastList(),
                  const SizedBox(height: 5),
                  //big cards with auxiliary readings (UV index, rain cubics, wind direction)
                  //depending on screen size - everything should be scrollable
                ],
              ),
            ),
          );
        } else {
          return const Text('Unknown error!');
        }
      }),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({Key? key, required this.user}) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: ColorPalette.lightBlue),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      child: Text(
                        user!.displayName?.substring(0, 1) ?? 'U',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36.0,
                            color: ColorPalette.lightBlue),
                      )),
                  const SizedBox(height: 5),
                  Text(
                    user!.displayName ?? 'None',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user!.email ?? 'None',
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  )
                ],
              )),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home',
                  style: TextStyle(color: ColorPalette.lightBlue)),
              onTap: () {
                Navigator.pop(context);
              }),
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('Location 1',
                style: TextStyle(color: ColorPalette.lightBlue)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(
            height: 2.0,
            color: ColorPalette.darkBlue,
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out',
                  style: TextStyle(color: ColorPalette.lightBlue)),
              onTap: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}

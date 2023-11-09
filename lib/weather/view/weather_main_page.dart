import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:weather_station_esp32/weather/bloc/weather_bloc.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
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
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    String username = context
        .select((AppBloc bloc) => bloc.state.user?.displayName ?? 'None');

    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(
              child:
                  CircularProgressIndicator()); // TODO add better loading animation
        } else if (state is WeatherLoadError) {
          return const Text('App loading error!');
        } else if (state is WeatherLoadSuccess) {
          return SliderDrawer(
            key: _sliderDrawerKey,
            slider: _Drawer(),
            appBar: AppBar(
              elevation: 5.0,
              backgroundColor: Colors.white,
              foregroundColor: ColorPalette.midBlue,
              shadowColor: ColorPalette.midBlue,
              actions: [
                IconButton(
                    onPressed: () =>
                        context.read<AppBloc>().add(AppLogOutRequested()),
                    icon: const Icon(Icons.exit_to_app))
              ],
              leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    setState(() {
                      _sliderDrawerKey.currentState?.toggle();
                    });
                  }),
              title: const Text(
                'Koszalin',
              ),
              titleTextStyle: const TextStyle(
                  color: ColorPalette.midBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              centerTitle: true,
            ),
            child: Container(
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
                    height: 20.0,
                  ),
                  //second big widget with weather from forecast
                  //next a list with weather forecast for 7 days, depending on location selected
                  const Text('7 day forecast:'),
                  const ForecastList(),
                  //big cards with auxiliary readings (UV index, rain cubics, wind direction)
                  //depending on screen size - everything should be scrollable
                  const Text('Logged in as:'),
                  Text(context.select((AppBloc bloc) =>
                      bloc.state.user?.displayName ?? 'None')),
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
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

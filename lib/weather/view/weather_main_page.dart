import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:weather_station_esp32/weather/widgets/forecast_list.dart';
import 'package:weather_station_esp32/weather/widgets/summary_card.dart';

import '../../bloc/app_bloc.dart';

class WeatherMainPage extends StatelessWidget {
  const WeatherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainPage();
  }
}

class _MainPage extends StatelessWidget {
  const _MainPage();

  @override
  Widget build(BuildContext context) {
    String username = context
        .select((AppBloc bloc) => bloc.state.user?.displayName ?? 'None');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () =>
                  context.read<AppBloc>().add(AppLogOutRequested()),
              icon: const Icon(Icons.exit_to_app))
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: ColorPalette.midBlue,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap:
              () {}, //TODO: implement user screen (change name, location, password, maybe theme? - night or day)
          child: Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.only(top: 12.0),
            decoration: BoxDecoration(
                color: ColorPalette.yellow,
                shape: BoxShape.circle,
                border: Border.all(color: ColorPalette.midBlue, width: 3.0)),
            child: Text(
              username[
                  0], //showing only first letter of username, inside of circular avatar
              style: const TextStyle(color: ColorPalette.darkBlue),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
            left: 10.0, top: 10.0, right: 15.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello $username, here\'s your today weather:',
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5.0),
            //big widget showing current weather with station readings
            const WeatherSummaryCard(),
            //next a list with weather forecast for 5 days, depending on location selected
            const ForecastList(),
            //big cards with auxiliary readings (UV index, rain cubics, wind direction)
            //depending on screen size - everything should be scrollable
            const Text('Logged in as:'),
            Text(context.select(
                (AppBloc bloc) => bloc.state.user?.displayName ?? 'None')),
          ],
        ),
      ),
    );
  }
}

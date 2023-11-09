import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:weather_station_esp32/weather/models/forecast.dart';
import 'package:weather_station_esp32/weather/widgets/forecast_card.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Forecast> weatherForecast = [
      const Forecast(
          date: 'Today',
          temperature: 23.0,
          icon: Icon(Icons.sunny, color: ColorPalette.yellow)),
      const Forecast(
          date: 'Tuesday',
          temperature: 18.0,
          icon: Icon(Icons.cloud, color: ColorPalette.midBlue)),
      const Forecast(
          date: 'Wednesday',
          temperature: 19.0,
          icon: Icon(Icons.foggy, color: ColorPalette.lightBlue)),
      const Forecast(
          date: 'Thursday',
          temperature: 16.0,
          icon: Icon(Icons.sunny, color: ColorPalette.yellow)),
      const Forecast(
          date: 'Friday',
          temperature: 24.0,
          icon: Icon(Icons.sunny, color: ColorPalette.yellow)),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 110,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        ...weatherForecast
            .map((data) => ForecastCard(
                date: data.date,
                temperature: data.temperature,
                icon: data.icon))
            .toList()
      ]),
    );
  }
}

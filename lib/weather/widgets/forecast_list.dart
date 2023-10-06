import 'package:flutter/material.dart';
import 'package:weather_station_esp32/weather/models/forecast.dart';
import 'package:weather_station_esp32/weather/widgets/forecast_card.dart';

class ForecastList extends StatelessWidget {
  const ForecastList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Forecast> weatherForecast = [
      const Forecast(date: 'Today', temperature: 23.0, icon: Icons.sunny),
      const Forecast(date: 'Tuesday', temperature: 18.0, icon: Icons.cloud),
      const Forecast(date: 'Wednesday', temperature: 19.0, icon: Icons.foggy),
      const Forecast(date: 'Thursday', temperature: 16.0, icon: Icons.sunny),
      const Forecast(date: 'Friday', temperature: 24.0, icon: Icons.sunny),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
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

import 'package:flutter/material.dart';
import 'package:weather_station_esp32/weather/models/forecast.dart';
import 'package:weather_station_esp32/weather/widgets/forecast_card.dart';

class ForecastHorizontalList extends StatelessWidget {
  final List<Forecast> forecastList;
  const ForecastHorizontalList({super.key, required this.forecastList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView(scrollDirection: Axis.horizontal, children: [
        ...forecastList.map((data) => ForecastCard(
            dateEpoch: data.dateEpoch,
            temperature: data.avgTempC,
            icon: data.condition.icon))
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import '../../weather/models/models.dart';
import '../../weather/widgets/widgets.dart';

class ForecastHorizontalList extends StatelessWidget {
  final List<Forecast> forecastList;
  final bool temperatureUnits;
  const ForecastHorizontalList(
      {super.key, required this.forecastList, required this.temperatureUnits});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView(scrollDirection: Axis.horizontal, children: [
        ...forecastList.map((data) => ForecastCard(
            dateEpoch: data.dateEpoch,
            temperature: temperatureUnits ? data.avgTempC : data.avgTempF,
            temperatureUnits: temperatureUnits,
            icon: data.condition.icon))
      ]),
    );
  }
}

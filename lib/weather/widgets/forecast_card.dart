import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../style/styling.dart';

class ForecastCard extends StatelessWidget {
  final int dateEpoch;
  final double temperature;
  final IconData icon;
  final bool temperatureUnits;
  const ForecastCard(
      {required this.dateEpoch,
      required this.temperature,
      required this.icon,
      required this.temperatureUnits,
      super.key});

  @override
  Widget build(BuildContext context) {
    String dateString;
    DateTime nowFromEpoch =
        DateTime.fromMillisecondsSinceEpoch(dateEpoch * 1000);
    DateTime now = DateTime.now();
    if (nowFromEpoch.day == now.day &&
        nowFromEpoch.month == now.month &&
        nowFromEpoch.year == now.year) {
      dateString = 'Today';
    } else {
      dateString = DateFormat('EEEE').format(nowFromEpoch);
    }
    return Container(
      margin:
          const EdgeInsets.only(left: 5.0, bottom: 30.0, right: 5.0, top: 5.0),
      padding: const EdgeInsets.all(10.0),
      width: 150,
      height: 180,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          //border: Border.all(color: ColorPalette.midBlue, width: 3.0),
          borderRadius: BorderRadius.circular(15.0),
          border: CardStyle.thinBorder(
              color: Theme.of(context).colorScheme.outline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              dateString,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 5.0),
          Expanded(
            child: BoxedIcon(
              icon,
              size: 36,
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
              child: Text(
            '$temperature${temperatureUnits ? '°C' : ' F'}',
            style: Theme.of(context).textTheme.bodyLarge,
          )),
        ],
      ),
    );
  }
}

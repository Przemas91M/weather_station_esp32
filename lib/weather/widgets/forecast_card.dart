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
          const EdgeInsets.only(left: 5.0, bottom: 10.0, right: 5.0, top: 5.0),
      padding: const EdgeInsets.all(10.0),
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: ColorPalette.midBlue, width: 3.0),
          borderRadius: BorderRadius.circular(15.0),
          border: CardStyle.thinBorder()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateString,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5.0),
          BoxedIcon(
            icon,
            color: ColorPalette.lightBlue,
            size: 36,
          ),
          const SizedBox(height: 10.0),
          Text('$temperature${temperatureUnits ? '°C' : ' F'}'),
        ],
      ),
    );
  }
}

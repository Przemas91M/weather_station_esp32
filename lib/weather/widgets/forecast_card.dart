import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class ForecastCard extends StatelessWidget {
  final String date;
  final double temperature;
  final IconData icon;
  const ForecastCard(
      {required this.date,
      required this.temperature,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ColorPalette.midBlue, width: 3.0),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                offset: Offset(5.0, 5.0),
                color: ColorPalette.midBlue,
                blurStyle: BlurStyle.normal,
                blurRadius: 5.0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(date),
          const SizedBox(height: 5.0),
          Icon(icon),
          const SizedBox(height: 5.0),
          Text('$temperature°C'),
        ],
      ),
    );
  }
}

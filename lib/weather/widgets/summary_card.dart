import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class WeatherSummaryCard extends StatelessWidget {
  const WeatherSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorPalette.midBlue,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(color: ColorPalette.midBlue, offset: Offset(5.0, 5.0))
          ]),
      child: const Column(children: [
        Text(
          'KOSZALIN',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text('Pogodnie'),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '22°C',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '95% RH',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        )
      ]),
    );
  }
}

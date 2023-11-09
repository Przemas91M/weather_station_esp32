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
            color: ColorPalette.lightBlue,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            /*BoxShadow(
              color: ColorPalette.lightBlue,
              offset: Offset(5.0, 5.0),
            ),*/
            BoxShadow(
                color: ColorPalette.lightBlue,
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0,
                blurStyle: BlurStyle.normal)
          ]),
      child: const Column(children: [
        Text(
          'Forecast',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.0,
        ),
        Icon(
          Icons.sunny,
          color: ColorPalette.yellow,
          size: 30.0,
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
            Text('95%', style: TextStyle(fontSize: 20.0)),
            Text('22°C', style: TextStyle(fontSize: 20.0)),
            Text('UV 2', style: TextStyle(fontSize: 20.0)),
          ],
        )
      ]),
    );
  }
}

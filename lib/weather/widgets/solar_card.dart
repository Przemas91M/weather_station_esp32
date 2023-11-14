import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class SolarCard extends StatelessWidget {
  final double volts;
  const SolarCard({required this.volts, super.key});
  static const Map<String, Color> chargeLevel = {
    'Charging': Colors.green,
    'Off': Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    int charging = (((volts - 3.75) * 100) ~/ (6.4 - 3.75)).toInt();
    String level = 'Low';
    switch (charging) {
      case > 0:
        level = 'Charging';
        break;
      default:
        level = 'Off';
        break;
    }
    return Container(
      margin:
          const EdgeInsets.only(left: 5.0, bottom: 10.0, right: 5.0, top: 3.0),
      padding: const EdgeInsets.all(15.0),
      width: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          //border: Border.all(color: ColorPalette.midBlue, width: 3.0),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                //offset: Offset(0.0, 5.0),
                color: ColorPalette.midBlue,
                blurStyle: BlurStyle.outer,
                blurRadius: 5.0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('Solar cell', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 7.0),
          Icon(Icons.solar_power_rounded, color: chargeLevel[level], size: 36),
          const SizedBox(height: 7.0),
          Text('$volts V'),
          const SizedBox(height: 7),
          charging > 0 ? Text('$charging %') : const Text('Off')
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:intl/intl.dart';

import '../models/reading.dart';

class StationReadingsCard extends StatelessWidget {
  const StationReadingsCard({super.key, required this.reading});

  final StationReading reading;

  @override
  Widget build(BuildContext context) {
    //DateTime dateTime = DateTime.now();
    DateTime readTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (reading.timestamp /*+ dateTime.timeZoneOffset.inSeconds)*/ * 1000));
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorPalette.lightBlue,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: ColorPalette.lightBlue,
                offset: Offset(5.0, 5.0),
                blurRadius: 10.0,
                blurStyle: BlurStyle.normal),
            /*BoxShadow(
              color: ColorPalette.lightBlue,
              offset: Offset(5.0, 5.0),*/
            //)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Latest station readings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Icon(Icons.landscape, color: ColorPalette.yellow),
              const SizedBox(width: 5),
              Text('${reading.outsideTemperature}°C',
                  style: const TextStyle(fontSize: 18)),
            ]),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Icon(Icons.house_rounded, color: ColorPalette.yellow),
              const SizedBox(width: 5),
              Text('${reading.insideTemperature}°C',
                  style: const TextStyle(fontSize: 18)),
            ]),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const BoxedIcon(WeatherIcons.humidity,
                  color: ColorPalette.yellow),
              Text('${reading.humidity}%', style: const TextStyle(fontSize: 18))
            ]),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const BoxedIcon(WeatherIcons.barometer,
                  color: ColorPalette.yellow),
              Text('${reading.pressure.toStringAsPrecision(4)} hPa',
                  style: const TextStyle(fontSize: 18)),
            ]),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Icon(Icons.sunny, color: ColorPalette.yellow),
              const SizedBox(width: 5),
              Text('UV${reading.uvIndex}',
                  style: const TextStyle(fontSize: 18)),
            ]),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Icon(Icons.lightbulb, color: ColorPalette.yellow),
              const SizedBox(width: 5),
              Text('${reading.lux} lux', style: const TextStyle(fontSize: 18))
            ]),
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Icon(Icons.battery_full, color: ColorPalette.yellow),
              const SizedBox(width: 5),
              Text('${reading.batteryVoltage.toStringAsPrecision(3)} V',
                  style: const TextStyle(fontSize: 18)),
            ]),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Icon(Icons.solar_power, color: ColorPalette.yellow),
              const SizedBox(width: 5),
              Text('${reading.solarVoltage.toStringAsFixed(2)} V',
                  style: const TextStyle(fontSize: 18)),
            ]),
          ]),
          const SizedBox(height: 20),
          Text(
            'Last reading: ${DateFormat('d MMMM y HH:mm:ss').format(readTimestamp)}',
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

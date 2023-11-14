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
          /*border: Border.all(
            color: ColorPalette.lightBlue,
            width: 3.0,
          ),*/
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: ColorPalette.lightBlue,
                //offset: Offset(5.0, 5.0),
                blurRadius: 15.0,
                blurStyle: BlurStyle.outer),
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
            'Current weather',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          const Divider(color: Colors.black, height: 2.0),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //TODO Wrap this with Gesture Detector and show details after tap
            //(show graph with reading history!)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${reading.insideTemperature}°C',
                    style: const TextStyle(fontSize: 24.0)),
                const SizedBox(height: 15),
                const Icon(
                  Icons.sunny,
                  size: 35,
                  color: ColorPalette.yellow,
                ),
                const SizedBox(height: 15),
                const Text('Sunny', style: TextStyle(fontSize: 24.0))
              ],
            ),
            //TODO wrap this with gesture detector
            //show each parameter as a graph with latest readings
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // humidity reading
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const BoxedIcon(WeatherIcons.humidity,
                            color: ColorPalette.yellow),
                        Text('${reading.humidity.toStringAsFixed(1)} %')
                      ]),
                  const SizedBox(height: 5),
                  // pressure reading
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const BoxedIcon(WeatherIcons.barometer,
                            color: ColorPalette.yellow),
                        Text('${reading.pressure.toStringAsFixed(1)} hPa')
                      ]),
                  const SizedBox(height: 5),
                  //UV index reading
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const BoxedIcon(WeatherIcons.sunrise,
                            color: ColorPalette.yellow),
                        Text(' UV: ${reading.uvIndex.toStringAsFixed(1)}')
                      ]),
                  const SizedBox(height: 5),
                  //LUX light reading
                  Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 6.0),
                          child:
                              Icon(Icons.lightbulb, color: ColorPalette.yellow),
                        ),
                        Text('  ${reading.lux.toStringAsFixed(0)} LUX')
                      ]),
                ])
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

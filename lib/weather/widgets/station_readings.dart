import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

import '../../style/styling.dart';
import '../models/models.dart';

class StationReadingsCard extends StatelessWidget {
  const StationReadingsCard(
      {super.key,
      required this.reading,
      required this.currentWeather,
      required this.temperatureUnits});

  final StationReading reading;
  final CurrentWeather currentWeather;
  final bool temperatureUnits;

  @override
  Widget build(BuildContext context) {
    //DateTime dateTime = DateTime.now();
    DateTime readTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (reading.timestamp /*+ dateTime.timeZoneOffset.inSeconds)*/ * 1000));
    //Fahrenheits
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: CardStyle.thinBorder(),
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Current weather',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const Divider(color: Colors.black, height: 10.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            //TODO Wrap this with Gesture Detector and show details after tap
            //(show graph with reading history!)
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '${temperatureUnits ? reading.insideTemperature.toStringAsFixed(1) : reading.insideTemperatureF.toStringAsFixed(1)}${temperatureUnits ? '°C' : 'F'}',
                      style: const TextStyle(fontSize: 24.0)),
                  const SizedBox(height: 10),
                  BoxedIcon(
                    currentWeather.weatherCondition.icon,
                    size: 35,
                    color: currentWeather.weatherCondition.iconColor,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    currentWeather.weatherCondition.condition,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            //TODO wrap this with gesture detector
            //show each parameter as a graph with latest readings
            Expanded(
              flex: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // humidity reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const BoxedIcon(WeatherIcons.humidity,
                              color: ColorPalette.yellow),
                          Text('${reading.humidity.toStringAsFixed(1)}%')
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
                            child: Icon(Icons.lightbulb,
                                color: ColorPalette.yellow),
                          ),
                          Text('  ${reading.lux.toStringAsFixed(0)} LUX')
                        ]),
                  ]),
            )
          ]),
          const SizedBox(height: 20),
          Text(
            'Updated: ${DateFormat('d MMMM y HH:mm').format(readTimestamp)}',
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

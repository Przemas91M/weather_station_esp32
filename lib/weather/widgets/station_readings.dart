import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    ThemeData theme = Theme.of(context);
    var local = AppLocalizations.of(context);
    //DateTime dateTime = DateTime.now();
    DateTime readTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (reading.timestamp /*+ dateTime.timeZoneOffset.inSeconds)*/ * 1000));
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    String updateDate = DateFormat('dd.MM.y').format(readTimestamp);
    if (readTimestamp.day == now.day &&
        readTimestamp.month == now.month &&
        readTimestamp.year == now.year) {
      updateDate = local!.today;
    } else if (readTimestamp.day == yesterday.day &&
        readTimestamp.month == yesterday.month &&
        readTimestamp.year == yesterday.year) {
      updateDate = local!.yesterday;
    }
    //Fahrenheits
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(top: 15, bottom: 30),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            local!.currentWeather,
            style: theme.textTheme.displayMedium,
          ),
          const Divider(height: 15.0),
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
                      style: Theme.of(context).textTheme.displayLarge),
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
                    style: Theme.of(context).textTheme.displaySmall,
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
                          const BoxedIcon(WeatherIcons.humidity),
                          Text('${reading.humidity.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ]),
                    const SizedBox(height: 5),
                    // pressure reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const BoxedIcon(WeatherIcons.barometer),
                          Text('${reading.pressure.toStringAsFixed(1)} hPa',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                    const SizedBox(height: 5),
                    //UV index reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const BoxedIcon(WeatherIcons.sunrise,
                              color: ColorPalette.yellow),
                          Text(' UV: ${reading.uvIndex.toStringAsFixed(1)}',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                    const SizedBox(height: 5),
                    //LUX light reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Icon(Icons.lightbulb)),
                          Text('  ${reading.lux.toStringAsFixed(0)} LUX',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                  ]),
            )
          ]),
          const SizedBox(height: 20),
          Text(
            '${local.updated}: $updateDate ${DateFormat('HH:mm').format(readTimestamp)}',
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_station_esp32/weather/models/models.dart';

import '../../style/styling.dart';

/**
 *Displays card with current weather readings
 *It is displayed when there is no station present in location
 *Takes current weather readings from API
 */
///
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather currentWeather;
  final bool temperatureUnits;
  const CurrentWeatherCard(
      {super.key,
      required this.currentWeather,
      required this.temperatureUnits});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations? localVocabulary = AppLocalizations.of(context);
    DateTime readTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (currentWeather.lastUpdated /*+ dateTime.timeZoneOffset.inSeconds)*/ *
            1000));
    final DateTime now = DateTime.now();
    final DateTime yesterday = now.subtract(const Duration(days: 1));
    String updateDate = DateFormat('dd.MM.y').format(readTimestamp);
    if (readTimestamp.day == now.day &&
        readTimestamp.month == now.month &&
        readTimestamp.year == now.year) {
      updateDate = localVocabulary!.today;
    } else if (readTimestamp.day == yesterday.day &&
        readTimestamp.month == yesterday.month &&
        readTimestamp.year == yesterday.year) {
      updateDate = localVocabulary!.yesterday;
    }
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
            localVocabulary!.currentWeather,
            style: theme.textTheme.displayMedium,
          ),
          const Divider(height: 15.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '${temperatureUnits ? currentWeather.temperatureC.toStringAsFixed(1) : currentWeather.temperatureF.toStringAsFixed(1)}${temperatureUnits ? '°C' : 'F'}',
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
                          Text('${currentWeather.humidity.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ]),
                    const SizedBox(height: 5),
                    // pressure reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const BoxedIcon(WeatherIcons.barometer),
                          Text(
                              '${currentWeather.pressure.toStringAsFixed(1)} hPa',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                    const SizedBox(height: 5),
                    //UV index reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const BoxedIcon(WeatherIcons.sunrise,
                              color: ColorPalette.yellow),
                          Text(
                              ' UV: ${currentWeather.uvIndex.toStringAsFixed(1)}',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                    const SizedBox(height: 5),
                    //LUX light reading
                    Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Icon(Icons.cloud)),
                          Text(
                              '  ${currentWeather.cloudCoverage.toStringAsFixed(0)} %',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ]),
                  ]),
            )
          ]),
          const SizedBox(height: 20),
          Text(
            '${localVocabulary.updated}: $updateDate ${DateFormat('HH:mm').format(readTimestamp)}',
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}

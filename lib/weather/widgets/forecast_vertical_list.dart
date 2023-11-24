import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_station_esp32/style/styling.dart';
import 'package:weather_station_esp32/weather/extensions/capitalize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../weather/models/models.dart';

class ForecastVerticalList extends StatelessWidget {
  final List<Forecast> forecastList;
  final bool temperatureUnits;
  const ForecastVerticalList(
      {super.key, required this.forecastList, required this.temperatureUnits});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: const EdgeInsets.only(bottom: 30.0),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline)),
      child: Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.weatherForecast}:',
            style: theme.textTheme.displayMedium,
          ),
          const Divider(height: 15),
          Expanded(
              child: ListView(scrollDirection: Axis.vertical, children: [
            ...forecastList.skip(1).map((data) => SizedBox(
                height: 50,
                child: Column(
                  children: [
                    //main row
                    Expanded(
                      child: Row(
                        children: [
                          //row starting from left
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 70,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      DateFormat.EEEE()
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  data.dateEpoch * 1000))
                                          .capitalize(),
                                    ),
                                  ),
                                ),
                                //row with remaining widgets
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: 60,
                                          child:
                                              BoxedIcon(data.condition.icon)),
                                      SizedBox(
                                          width: 85,
                                          child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                const BoxedIcon(WeatherIcons
                                                    .thermometer_exterior),
                                                Text(
                                                    '${temperatureUnits ? data.minTempC : data.minTempF}${temperatureUnits ? '°C' : 'F'}'),
                                              ])),
                                      SizedBox(
                                        width: 85,
                                        child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              const BoxedIcon(
                                                  WeatherIcons.thermometer),
                                              Text(
                                                  '${temperatureUnits ? data.maxTempC : data.maxTempF}${temperatureUnits ? '°C' : 'F'}')
                                            ]),
                                      ),
                                      const SizedBox(width: 5),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider()
                  ],
                )))
          ]))
        ],
      ),
    );
  }
}
/*dateEpoch: data.dateEpoch,
                temperature: temperatureUnits ? data.avgTempC : data.avgTempF,
                temperatureUnits: temperatureUnits,
                icon: data.condition.icon*/

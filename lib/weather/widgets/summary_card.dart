import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/styling.dart';
import '../models/models.dart';

class TodaySummaryCard extends StatelessWidget {
  final Forecast? today;
  final bool temperatureUnits;
  final bool rainUnits;
  final bool windUnits;
  const TodaySummaryCard(
      {super.key,
      required this.today,
      required this.rainUnits,
      required this.temperatureUnits,
      required this.windUnits});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var local = AppLocalizations.of(context);
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.only(bottom: 30.0),
        decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(local!.today, style: theme.textTheme.displayMedium),
          const Divider(height: 15.0),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${temperatureUnits ? today?.avgTempC : today?.avgTempF}${temperatureUnits ? '°C' : ' F'}',
                          style: theme.textTheme.displayLarge,
                        ),
                        BoxedIcon(today?.condition.icon ?? Icons.close,
                            color: today?.condition.iconColor, size: 35),
                        const SizedBox(height: 10),
                        Text('${today?.condition.condition}',
                            style: theme.textTheme.displaySmall,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center)
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const BoxedIcon(
                                WeatherIcons.thermometer,
                              ),
                              Text(
                                  '${temperatureUnits ? today?.maxTempC : today?.maxTempF}${temperatureUnits ? '°C' : ' F'}',
                                  style: theme.textTheme.bodyLarge)
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const BoxedIcon(
                                WeatherIcons.thermometer_exterior,
                              ),
                              Text(
                                  '${temperatureUnits ? today?.minTempC : today?.minTempF}${temperatureUnits ? '°C' : ' F'}',
                                  style: theme.textTheme.bodyLarge)
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const BoxedIcon(
                                WeatherIcons.humidity,
                              ),
                              Text('${today?.avgHumidity.toStringAsFixed(0)}%',
                                  style: theme.textTheme.bodyLarge)
                            ],
                          ),
                        ])),
              ]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.end,
                  children: [
                    const BoxedIcon(
                      WeatherIcons.strong_wind,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${windUnits ? today?.maxWindKph : today?.maxWindMph}${windUnits ? ' km/h' : ' mph'}',
                      style: theme.textTheme.bodyMedium,
                    )
                  ]),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                const BoxedIcon(
                  WeatherIcons.rain_mix,
                ),
                const SizedBox(width: 2),
                Text(
                    '${rainUnits ? today?.totalPrecipMM : today?.totalPrecipIN}${rainUnits ? ' mm' : ' in'}')
              ]),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                const BoxedIcon(
                  WeatherIcons.sunrise,
                  color: ColorPalette.yellow,
                ),
                const SizedBox(width: 5),
                Text('UV: ${today?.uvIndex.toStringAsFixed(1)}')
              ]),
            ],
          )
        ]));
  }
}

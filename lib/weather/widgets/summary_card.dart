import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
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
    return Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: CardStyle.thinBorder()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text('Today',
              style: TextStyle(
                  fontSize: 20,
                  color: ColorPalette.lightBlue,
                  fontWeight: FontWeight.w500)),
          const Divider(color: Colors.black, height: 10.0),
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
                          style: const TextStyle(
                              color: ColorPalette.lightBlue, fontSize: 24.0),
                        ),
                        BoxedIcon(today?.condition.icon ?? Icons.close,
                            color: today?.condition.iconColor, size: 35),
                        const SizedBox(height: 10),
                        Text('${today?.condition.condition}',
                            style: const TextStyle(
                                color: ColorPalette.lightBlue, fontSize: 20.0),
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
                                color: ColorPalette.yellow,
                              ),
                              Text(
                                  '${temperatureUnits ? today?.maxTempC : today?.maxTempF}${temperatureUnits ? '°C' : ' F'}')
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const BoxedIcon(
                                WeatherIcons.thermometer_exterior,
                                color: ColorPalette.lightBlue,
                              ),
                              Text(
                                  '${temperatureUnits ? today?.minTempC : today?.minTempF}${temperatureUnits ? '°C' : ' F'}')
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const BoxedIcon(
                                WeatherIcons.humidity,
                                color: ColorPalette.lightBlue,
                              ),
                              Text('${today?.avgHumidity.toStringAsFixed(0)}%')
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
                      color: ColorPalette.lightBlue,
                    ),
                    Text(
                        '${windUnits ? today?.maxWindKph : today?.maxWindMph}${windUnits ? ' km/h' : ' mph'}')
                  ]),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                const BoxedIcon(
                  WeatherIcons.rain_mix,
                  color: ColorPalette.lightBlue,
                ),
                Text(
                    '${rainUnits ? today?.totalPrecipMM : today?.totalPrecipIN}${rainUnits ? ' mm' : ' in'}')
              ]),
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                const BoxedIcon(
                  WeatherIcons.sunrise,
                  color: ColorPalette.yellow,
                ),
                Text('UV: ${today?.uvIndex.toStringAsFixed(1)}')
              ]),
            ],
          )
        ]));
  }
}

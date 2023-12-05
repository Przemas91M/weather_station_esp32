import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_station_esp32/style/styling.dart';
import 'package:weather_station_esp32/weather/widgets/station_bottom_sheet/cubit/station_sheet_cubit.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../../models/models.dart';

/// Selected weather information to be displayed in the chart.
enum InputDataType {
  temperatureInside,
  temperatureOutSide,
  humidity,
  pressure,
  uv,
  lux,
}

/// Displays bottom sheet containing further details about weather read from weather station.
/// Each graph shows different weather information based on [InputDataType].
/// Creates a [StationSheetCubit], which requires access to [WeatherRepository]
/// ```dart
/// StationBottomModalSheet(weatherRepository: WeatherRepository repository);
/// ```
class StationBottomModalSheet extends StatelessWidget {
  const StationBottomModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StationSheetCubit(
          weatherRepository: context.read<WeatherRepository>()),
      child: _BottomSheet(),
    );
  }
}

/// Builds widgets based on [StationSheetCubit] state.
class _BottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationSheetCubit, StationSheetCubitState>(
      builder: (context, state) {
        if (state.status == StationSheetStatus.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: ColorPalette.lightBlue,
          ));
        } else if (state.status == StationSheetStatus.loaded) {
          return SingleChildScrollView(
            child: _DataChartsView(
              data: state.stationHistoricalData ?? [],
            ),
          );
        } else if (state.status == StationSheetStatus.initial) {
          Future.wait(
              [context.read<StationSheetCubit>().getStationHistoricalData(50)]);
          return Container();
        } else {
          return Container();
        }
      },
    );
  }
}

/// Shows charts containing past reading data from weather station.
/// Requires [data] to generate charts.
/// Every weather parameter is displayed in a separate chart.
/// User can tap on a chart to read more detail from a single reading.
class _DataChartsView extends StatelessWidget {
  const _DataChartsView({
    required this.data,
  });

  /// Data from weather station to show in chart.
  final List<StationReading> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data to show!'));
    }
    List<double> insideTemperatures = [];
    List<double> outsideTemperatures = [];
    List<double> insideTemperaturesF = [];
    List<double> outsideTemperaturesF = [];
    List<double> humidity = [];
    List<double> pressure = [];
    List<double> timestamps = [];
    for (var value in data) {
      insideTemperatures.add(value.insideTemperature);
      outsideTemperatures.add(value.outsideTemperature);
      insideTemperaturesF.add(value.insideTemperatureF);
      outsideTemperaturesF.add(value.outsideTemperatureF);
      humidity.add(value.humidity);
      pressure.add(value.pressure);
      timestamps.add(value.timestamp * 1.0);
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
              child: _DataChart(
            data: insideTemperatures,
            timestamp: timestamps,
            title: 'Temperatura',
            dataType: InputDataType.temperatureInside,
          )),
          Expanded(
              child: _DataChart(
            data: humidity,
            timestamp: timestamps,
            title: 'Wilgotność',
            dataType: InputDataType.humidity,
          )),
        ],
      ),
    );
  }
}

class _DataChart extends StatelessWidget {
  const _DataChart(
      {required this.data,
      required this.timestamp,
      required this.title,
      required this.dataType});
  final List<double> data;
  final List<double> timestamp;
  final String title;
  final InputDataType dataType;
  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    double maxValue = data.reduce((value, element) => value > element
        ? value
        : element); // just to be sure it will be overriden
    double minValue = data.reduce(
        (value, element) => value < element ? value : element); // same here
    double interval = 1.0; //minimal interval for slight data changes
    //get desired data from given readings
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(timestamp[i], data[i]));
    }
    var intervalCalc = ((maxValue).abs() + (minValue).abs()) / 5.0;
    if (intervalCalc > 1) {
      interval = intervalCalc;
    }
    return Container(
      height: 350,
      padding: const EdgeInsets.only(left: 20, top: 10, right: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.outline,
                offset: const Offset(3.0, 3.0),
                blurRadius: 5)
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          title, //change this to insert automatically
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Divider(height: 20, endIndent: 10),
        const SizedBox(height: 20),
        Expanded(
          child: LineChart(LineChartData(
              borderData: FlBorderData(
                  show: true, border: Border.all(color: Colors.white)),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: interval,
                verticalInterval: (spots.last.x - spots[0].x) / 6,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                      color: Colors.white.withOpacity(0.5), strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                      color: Colors.white.withOpacity(0.5), strokeWidth: 1);
                },
              ),
              maxY: maxValue + 1.0,
              minY: minValue - 1.0,
              minX: spots[0].x,
              maxX: spots.last.x,
              backgroundColor: Colors.black,
              lineBarsData: [
                LineChartBarData(
                    color: ColorPalette.lightBlue,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                    barWidth: 5.0,
                    belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                            colors: [
                              ColorPalette.lightBlue.withOpacity(0.5),
                              ColorPalette.yellow.withOpacity(0.5)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    spots: spots)
              ],
              titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      if (value <= (minValue - 1).toInt() ||
                          value >= (maxValue + 1).toInt()) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide, child: const Text(''));
                      }
                      return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text('${value.toStringAsFixed(0)}°C'));
                    },
                  )),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: (spots.last.x - spots[0].x) / 6,
                        reservedSize: 30,
                        getTitlesWidget: ((value, meta) {
                          if (value.toInt() < spots[0].x + 900 ||
                              value.toInt() > spots.last.x - 500) {
                            return SideTitleWidget(
                                axisSide: meta.axisSide, child: const Text(''));
                          }
                          var formattedDate = DateFormat('HH:00').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  value.toInt() * 1000));
                          return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(formattedDate));
                        })),
                  )))),
        ),
      ]),
    );
  }
}

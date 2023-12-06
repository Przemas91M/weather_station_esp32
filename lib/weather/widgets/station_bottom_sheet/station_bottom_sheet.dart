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
              weatherData: state.stationHistoricalData ?? [],
              selectedData: state.selectedData,
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
/// User can tap on a chart line to read more detail from a single reading.
///
// TODO: change this screen to show only one chart, user selects data, then rebuild only chart.
//
class _DataChartsView extends StatelessWidget {
  const _DataChartsView(
      {required this.weatherData, required this.selectedData});

  /// Data from weather station to show in chart.
  final List<StationReading> weatherData;
  final SelectedChartData selectedData;

  @override
  Widget build(BuildContext context) {
    if (weatherData.isEmpty) {
      return const Center(child: Text('No data to show!'));
    }
    List<double> insideTemperatures = [];
    List<double> outsideTemperatures = [];
    List<double> insideTemperaturesF = [];
    List<double> outsideTemperaturesF = [];
    List<double> humidity = [];
    List<double> pressure = [];
    List<double> timestamps = [];
    for (var value in weatherData) {
      insideTemperatures.add(value.insideTemperature);
      outsideTemperatures.add(value.outsideTemperature);
      insideTemperaturesF.add(value.insideTemperatureF);
      outsideTemperaturesF.add(value.outsideTemperatureF);
      humidity.add(value.humidity);
      pressure.add(value.pressure);
      timestamps.add(value.timestamp * 1.0);
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                  tooltip: 'Close this dialog',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(20)),
                child: BlocBuilder<StationSheetCubit, StationSheetCubitState>(
                  builder: (context, state) {
                    return DropdownButtonFormField<SelectedChartData>(
                        onChanged: (SelectedChartData? value) => context
                            .read<StationSheetCubit>()
                            .changeChartData(
                                value ?? SelectedChartData.temperatureInside),
                        isExpanded: true,
                        value: state.selectedData,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          prefixIcon: Icon(state.selectedData.icon),
                        ),
                        items: SelectedChartData.values.map(
                          (value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value.label),
                            );
                          },
                        ).toList());
                  },
                ),
              )
            ],
          ),
          _DataChart(
            data: insideTemperatures,
            timestamp: timestamps,
            dataType: InputDataType.temperatureInside,
          ),
        ],
      ),
    );
  }
}

/// Line data chart widget.
/// Takes list of [data] points and reading [timestamp].
/// Chart title and measurement units are set based on input [dataType].
class _DataChart extends StatelessWidget {
  const _DataChart._(
      {required this.data,
      required this.timestamp,
      required this.dataType,
      required String title,
      required String units})
      : _title = title,
        _units = units;

  /// Takes data and timestamps and sets coresponding chart title and measurement units
  /// Initialize final internal fields.
  factory _DataChart(
      {required List<double> data,
      required List<double> timestamp,
      required InputDataType dataType}) {
    //TODO: change labels to translated ones!
    String title = switch (dataType) {
      InputDataType.temperatureInside => 'Temperature Inside',
      InputDataType.temperatureOutSide => 'Temperature Outside',
      InputDataType.humidity => 'Humidity',
      InputDataType.pressure => 'Pressure',
      InputDataType.lux => 'Light intensity',
      InputDataType.uv => 'UV index'
    };
    String units = switch (dataType) {
      InputDataType.temperatureInside => '°C',
      InputDataType.temperatureOutSide => '°C',
      InputDataType.humidity => '%',
      InputDataType.pressure => 'hPa',
      InputDataType.lux => 'Lux',
      InputDataType.uv => 'UV:'
    };
    return _DataChart._(
      data: data,
      timestamp: timestamp,
      dataType: dataType,
      title: title,
      units: units,
    );
  }

  /// Weather data to show.
  final List<double> data;

  /// Timestamps when weather data was aquired.
  final List<double> timestamp;

  /// Chart title.
  final String _title;

  /// Units of measurement.
  final String _units;

  /// Weather data type - used to set chart title and measurement units.
  final InputDataType dataType;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    // Maximum data point
    double maxValue =
        data.reduce((value, element) => value > element ? value : element);
    // Minimal data point
    double minValue =
        data.reduce((value, element) => value < element ? value : element);
    // Minimal interval value
    double interval = 1.0;
    // Get desired data from given readings
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(timestamp[i], data[i]));
    }
    // Calculate data interval value
    var intervalCalc = ((maxValue).abs() + (minValue).abs()) / 6.0;
    if (intervalCalc > 1) {
      interval = intervalCalc;
    }

    return Container(
      padding: const EdgeInsets.only(left: 20, top: 15, right: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        /*boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.outline,
                offset: const Offset(3.0, 3.0),
                blurRadius: 5)
          ]*/
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*Text(
          _title, //change this to insert automatically
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Divider(height: 20, endIndent: 10),
        const SizedBox(height: 20),*/
            AspectRatio(
              aspectRatio: 1.5,
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
                              child:
                                  Text('${value.toStringAsFixed(0)}$_units'));
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
                                    axisSide: meta.axisSide,
                                    child: const Text(''));
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

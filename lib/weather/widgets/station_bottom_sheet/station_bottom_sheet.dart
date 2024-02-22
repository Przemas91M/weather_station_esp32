import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_station_esp32/locations_management/models/location.dart';
import 'package:weather_station_esp32/style/styling.dart';
import 'package:weather_station_esp32/weather/widgets/station_bottom_sheet/cubit/station_sheet_cubit.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  const StationBottomModalSheet({super.key, required this.currentLocation});

  final Location currentLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StationSheetCubit(
          weatherRepository: context.read<WeatherRepository>()),
      child: _BottomSheet(
        currentLocation: currentLocation,
      ),
    );
  }
}

/// Builds widgets based on [StationSheetCubit] state.
class _BottomSheet extends StatelessWidget {
  const _BottomSheet({required this.currentLocation});

  final Location currentLocation;

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
          Future.wait([
            context
                .read<StationSheetCubit>()
                .getStationHistoricalData(50, currentLocation)
          ]);
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
class _DataChartsView extends StatelessWidget {
  const _DataChartsView(
      {required this.weatherData, required this.selectedData});

  /// Data from weather station to show in chart.
  final List<StationReading> weatherData;
  final SelectedChartData selectedData;

  @override
  Widget build(BuildContext context) {
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
                              child: Text(LocalizationHelper.translate(
                                  context: context, dataType: value)),
                            );
                          },
                        ).toList());
                  },
                ),
              )
            ],
          ),
          BlocBuilder<StationSheetCubit, StationSheetCubitState>(
            builder: (context, state) {
              return _DataChart(
                inputData: weatherData,
                dataType: state.selectedData,
              );
            },
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
      {required List<double> data,
      required this.timestamp,
      required this.dataType,
      required String units})
      : _data = data,
        _units = units;

  /// Takes data and timestamps and sets coresponding chart title and measurement units.
  /// Initialize final internal fields.
  factory _DataChart(
      {required List<StationReading> inputData,
      required SelectedChartData dataType}) {
    //TODO: change labels to translated ones!
    String units;
    List<double> weatherData;
    switch (dataType) {
      case SelectedChartData.temperatureInside:
        {
          units = '°C';
          weatherData =
              inputData.map((reading) => reading.insideTemperature).toList();
          break;
        }
      case SelectedChartData.temperatureOutside:
        {
          units = '°C';
          weatherData =
              inputData.map((reading) => reading.outsideTemperature).toList();
          break;
        }
      case SelectedChartData.humidity:
        {
          units = '%';
          weatherData = inputData.map((reading) => reading.humidity).toList();
          break;
        }
      case SelectedChartData.pressure:
        {
          units = 'hPa';
          weatherData = inputData.map((reading) => reading.pressure).toList();
          break;
        }
      case SelectedChartData.lux:
        {
          units = 'lux';
          weatherData = inputData.map((reading) => reading.lux).toList();
          break;
        }
      case SelectedChartData.uv:
        {
          units = 'UV';
          weatherData = inputData.map((reading) => reading.uvIndex).toList();
          break;
        }
    }
    return _DataChart._(
      data: weatherData,
      timestamp: inputData.map((reading) => reading.timestamp * 1.0).toList(),
      dataType: dataType,
      units: units,
    );
  }

  /// Weather data to show.
  final List<double> _data;

  /// Timestamps when weather data was aquired.
  final List<double> timestamp;

  /// Units of measurement.
  final String _units;

  /// Weather data type - used to set chart title and measurement units.
  final SelectedChartData dataType;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    // Maximum data point
    double maxValue =
        _data.reduce((value, element) => value > element ? value : element);
    // Minimal data point
    double minValue =
        _data.reduce((value, element) => value < element ? value : element);
    // Minimal interval value
    double interval = 1.0;
    // Get desired data from given readings
    for (int i = 0; i < _data.length; i++) {
      spots.add(FlSpot(timestamp[i], _data[i]));
    }
    // Calculate data interval value
    interval =
        (((maxValue).abs() - (minValue).abs()) / 5).clamp(1.0, double.infinity);

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
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 20.0,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            return LineTooltipItem(
                                spots[touchedSpot.spotIndex]
                                    .y
                                    .toStringAsFixed(1),
                                const TextStyle(fontSize: 10));
                          }).toList();
                        },
                      )),
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
                  maxY: maxValue + 1,
                  minY: minValue - 1,
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
                        reservedSize: 85,
                        getTitlesWidget: (value, meta) {
                          if (value < (minValue - 0.6) ||
                              value > (maxValue + 0.6)) {
                            return SideTitleWidget(
                                axisSide: meta.axisSide, child: const Text(''));
                          }
                          return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child:
                                  Text('${value.toStringAsFixed(1)}$_units'));
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

abstract class LocalizationHelper {
  static String translate(
      {required BuildContext context, required SelectedChartData dataType}) {
    switch (dataType) {
      case SelectedChartData.temperatureInside:
        return AppLocalizations.of(context)!.tempInside;
      case SelectedChartData.temperatureOutside:
        return AppLocalizations.of(context)!.tempOutside;
      case SelectedChartData.humidity:
        return AppLocalizations.of(context)!.humidity;
      case SelectedChartData.uv:
        return AppLocalizations.of(context)!.uvIndex;
      case SelectedChartData.pressure:
        return AppLocalizations.of(context)!.pressure;
      case SelectedChartData.lux:
        return AppLocalizations.of(context)!.lux;
    }
  }
}

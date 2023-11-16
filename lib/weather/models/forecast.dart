import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/weather/models/weather_condition.dart';

///This class gathers all forecast data for one day
///Later this is aggregated into list of forecasts for specific day

class Forecast extends Equatable {
  final String date;
  final int dateEpoch;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final double maxWindKph;
  final double maxWindMph;
  final double totalPrecipMM;
  final double totalPrecipIN;
  final double avgHumidity;
  final WeatherCondition condition;
  final List<Map<String, dynamic>> hourlyTempC;
  final List<Map<String, dynamic>> hourlyTempF;
  final List<Map<String, dynamic>> hourlyPressure;
  final List<Map<String, dynamic>> hourlyPrecipMM;
  final List<Map<String, dynamic>> hourlyPrecipIN;
  final List<Map<String, dynamic>> hourlyHumidity;

  const Forecast({
    required this.date,
    required this.dateEpoch,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindKph,
    required this.maxWindMph,
    required this.totalPrecipMM,
    required this.totalPrecipIN,
    required this.avgHumidity,
    required this.condition,
    required this.hourlyTempC,
    required this.hourlyTempF,
    required this.hourlyPressure,
    required this.hourlyPrecipMM,
    required this.hourlyPrecipIN,
    required this.hourlyHumidity,
  });

  @override
  List<Object?> get props => [
        date,
        maxTempC,
        maxTempF,
        minTempC,
        minTempF,
        avgTempC,
        avgTempF,
        maxWindKph,
        maxWindMph,
        totalPrecipMM,
        totalPrecipIN,
        avgHumidity,
        condition,
        hourlyTempC,
        hourlyTempF,
        hourlyPressure,
        hourlyPrecipMM,
        hourlyPrecipIN,
        hourlyHumidity,
      ];
}

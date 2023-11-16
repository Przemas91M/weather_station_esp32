import 'package:weather_station_esp32/weather/models/weather_condition.dart';

/// Class containing every current weather data that the station cannot read

class CurrentWeather {
  double temperatureC;
  double temperatureF;
  double feelsLikeC;
  double feelsLikeF;
  double windKph;
  double windMph;
  double precipitationMm;
  double precipitationIn;
  int cloudCoverage;
  int lastUpdated;

  WeatherCondition weatherCondition;

  CurrentWeather(
      {required this.temperatureC,
      required this.temperatureF,
      required this.weatherCondition,
      required this.feelsLikeC,
      required this.feelsLikeF,
      required this.precipitationIn,
      required this.precipitationMm,
      required this.windKph,
      required this.windMph,
      required this.cloudCoverage,
      required this.lastUpdated});

  factory CurrentWeather.fromJson(Map json) {
    return CurrentWeather(
        temperatureC: json['temp_c'],
        temperatureF: json['temp_f'],
        feelsLikeC: json['feelslike_c'],
        feelsLikeF: json['feelslike_f'],
        precipitationMm: json['precip_mm'],
        precipitationIn: json['precip_in'],
        windKph: json['wind_kph'],
        windMph: json['wind_mph'],
        cloudCoverage: json['cloud'],
        lastUpdated: json['last_updated_epoch'],
        weatherCondition: WeatherCondition.fromCode(json['condition']['code']));
  }
}

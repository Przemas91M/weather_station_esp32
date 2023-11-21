part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final List<StationReading>? stationReadings;
  final CurrentWeather? currentWeather;
  final List<Forecast>? weatherForecast;
  const WeatherState(
      {required this.status,
      required this.currentWeather,
      required this.stationReadings,
      required this.weatherForecast});

  //initial state constructor
  static WeatherState initial() => const WeatherState(
      currentWeather: null,
      status: WeatherStatus.initial,
      stationReadings: null,
      weatherForecast: null);

  WeatherState copyWith(
          {WeatherStatus? status,
          CurrentWeather? currentWeather,
          List<StationReading>? stationReadings,
          List<Forecast>? weatherForecast}) =>
      WeatherState(
          status: status ?? this.status,
          currentWeather: currentWeather ?? this.currentWeather,
          stationReadings: stationReadings ?? this.stationReadings,
          weatherForecast: weatherForecast ?? this.weatherForecast);

  @override
  List<Object?> get props =>
      [status, currentWeather, stationReadings, weatherForecast];
}

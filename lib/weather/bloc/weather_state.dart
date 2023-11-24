part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final List<StationReading>? newestStationReadings;
  final List<StationReading>? historicalStationData;
  final CurrentWeather? currentWeather;
  final List<Forecast>? weatherForecast;
  const WeatherState(
      {required this.status,
      required this.currentWeather,
      required this.newestStationReadings,
      required this.historicalStationData,
      required this.weatherForecast});

  //initial state constructor
  static WeatherState initial() => const WeatherState(
      currentWeather: null,
      status: WeatherStatus.initial,
      newestStationReadings: null,
      historicalStationData: null,
      weatherForecast: null);

  WeatherState copyWith(
          {WeatherStatus? status,
          CurrentWeather? currentWeather,
          List<StationReading>? newestStationReadings,
          List<StationReading>? historicalStationData,
          List<Forecast>? weatherForecast}) =>
      WeatherState(
          status: status ?? this.status,
          currentWeather: currentWeather ?? this.currentWeather,
          newestStationReadings:
              newestStationReadings ?? this.newestStationReadings,
          historicalStationData:
              historicalStationData ?? this.historicalStationData,
          weatherForecast: weatherForecast ?? this.weatherForecast);

  @override
  List<Object?> get props =>
      [status, currentWeather, newestStationReadings, weatherForecast];
}

part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  locationChanged,
  loading,
  loaded,
  loadedStation,
  loadedWithoutStation,
  loadedEmpty,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Location? currentLocation;
  final List<StationReading>? newestStationReadings;
  final List<StationReading>? historicalStationData;
  final CurrentWeather? currentWeather;
  final List<Forecast>? weatherForecast;
  const WeatherState(
      {required this.status,
      required this.currentLocation,
      required this.currentWeather,
      required this.newestStationReadings,
      required this.historicalStationData,
      required this.weatherForecast});

  //initial state constructor
  static WeatherState initial() => const WeatherState(
      currentLocation: null,
      currentWeather: null,
      status: WeatherStatus.initial,
      newestStationReadings: null,
      historicalStationData: null,
      weatherForecast: null);

  WeatherState copyWith(
          {WeatherStatus? status,
          Location? currentLocation,
          CurrentWeather? currentWeather,
          List<StationReading>? newestStationReadings,
          List<StationReading>? historicalStationData,
          List<Forecast>? weatherForecast}) =>
      WeatherState(
          status: status ?? this.status,
          currentLocation: currentLocation ?? this.currentLocation,
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

part of 'weather_bloc.dart';

///All weather screen states
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

/// Keeps all weather screen states and necessary data.
class WeatherState extends Equatable {
  final WeatherStatus status;

  /// City data describing currently selected location
  final Location? currentLocation;

  /// Last reading list uploaded by weather station in selected location.
  final List<StationReading>? newestStationReadings;

  /// List of past readings queued from database.
  final List<StationReading>? historicalStationData;

  /// Current weather data stored in [CurrentWeather] object.
  final CurrentWeather? currentWeather;

  /// Weather forecast list, sorted by day, requested from WeatherAPI, stored in [Forecast] object.
  final List<Forecast>? weatherForecast;

  const WeatherState(
      {required this.status,
      required this.currentLocation,
      required this.currentWeather,
      required this.newestStationReadings,
      required this.historicalStationData,
      required this.weatherForecast});

  /// Initial state constructor.
  /// Removes all data and sets state to initial.
  static WeatherState initial() => const WeatherState(
      currentLocation: null,
      currentWeather: null,
      status: WeatherStatus.initial,
      newestStationReadings: null,
      historicalStationData: null,
      weatherForecast: null);

  /// Creates a copy of this state with given fields.
  /// Only non null fields are replaced.
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

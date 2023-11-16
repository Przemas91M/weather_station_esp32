part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherLoadSuccess extends WeatherState {
  const WeatherLoadSuccess(
      {required this.stationReadings,
      required this.currentWeather,
      required this.forecastList});
  final List<StationReading> stationReadings;
  final CurrentWeather currentWeather;
  final List<Forecast> forecastList;
}

final class WeatherUpdateLoading extends WeatherState {}

final class WeatherUpdateSuccess extends WeatherState {
  const WeatherUpdateSuccess(
      {required this.stationReadings, required this.currentWeather});
  final List<StationReading> stationReadings;
  final CurrentWeather currentWeather;
}

final class WeatherLoadError extends WeatherState {}

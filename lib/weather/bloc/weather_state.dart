part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherLoadSuccess extends WeatherState {
  const WeatherLoadSuccess({required this.stationReadings});
  final List<StationReading> stationReadings;
}

final class WeatherLoadError extends WeatherState {}

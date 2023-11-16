part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class StationDataChanged extends WeatherEvent {
  final List<StationReading> data;

  const StationDataChanged({required this.data});
}

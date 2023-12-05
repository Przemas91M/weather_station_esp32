part of 'weather_bloc.dart';

/// All events linked to WeatherBloc.
sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

/// When weather station uploads new data to Database.
/// Contains list of [StationReading] with recent data from station.
class StationDataChanged extends WeatherEvent {
  final List<StationReading> data;

  const StationDataChanged({required this.data});
}

/// When user choses to change location and it has a weather station installed.
/// Passes [Location] chosen by user.
class SubscribeNewLocation extends WeatherEvent {
  final Location location;

  const SubscribeNewLocation({required this.location});
}

/// When user requests to refresh weather info.
class RefreshWeatherForecast extends WeatherEvent {}

/// When user requests to change location and it doesn't have a weather station installed.
/// Passes [Location] chosen by user.
class NewLocationWithoutStation extends WeatherEvent {
  final Location location;
  const NewLocationWithoutStation({required this.location});
}

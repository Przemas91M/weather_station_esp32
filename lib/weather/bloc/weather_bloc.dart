import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/locations_management/models/location.dart';
import 'package:weather_station_esp32/weather/models/current_weather.dart';
import 'package:weather_station_esp32/weather/models/reading.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../models/forecast.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required this.weatherRepository})
      : super(WeatherState.initial()) {
    on<StationDataChanged>(_stationDataChanged);
    on<SubscribeNewLocation>(_subscribeNewLocation);
    on<RefreshWeatherForecast>(_refreshWeatherForecast);
    on<NewLocationWithoutStation>(_newLocationWithoutStation);
  }

  /// Weather repository object for data saving and loading.
  final WeatherRepository weatherRepository;

  /// Controls stream from specific weather station.
  StreamController _streamController = StreamController();

  /// Stream subscription to read weather station data.
  late StreamSubscription<dynamic> _databaseSubscription;

  /// Called when weather station stores new data in Firebase
  /// and stream exposes new [event] containing station readings.
  ///
  /// Fetches current weather data from repository and stores recent station
  /// reading in [state] variable.
  FutureOr<void> _stationDataChanged(
      StationDataChanged event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather(state.currentLocation!.url);
    List<Forecast> weatherForecast = weatherRepository.getWeatherForecast();
    emit(state.copyWith(
        status: WeatherStatus.loadedStation,
        newestStationReadings: event.data,
        currentWeather: currentWeather,
        weatherForecast: weatherForecast));
  }

  /// Cancels current stream subscription and subscribes to new Firebase stream
  /// exposing data, when weather station from selected city uploads new data.
  ///
  /// Used when user selects new location and it has a weather station installed.
  FutureOr<void> _subscribeNewLocation(
      SubscribeNewLocation event, Emitter<WeatherState> emit) {
    emit(state.copyWith(status: WeatherStatus.locationChanged));
    if (_streamController.hasListener) {
      _databaseSubscription.cancel();
      _streamController.close();
    }
    _streamController = StreamController();
    _streamController.addStream(
        weatherRepository.databaseDataChanged(event.location.name, 10));
    //_databaseSubscription.cancel();
    _databaseSubscription = _streamController.stream
        .listen((data) => add(StationDataChanged(data: data)));
    //stay in loading state until first subscription event fires
    emit(state.copyWith(
        status: WeatherStatus.loading, currentLocation: event.location));
  }

  /// Requests for updated weather data and forecast from WeatherAPI.
  ///
  /// Used when location doesn't have installed weather station and user
  /// requests to refresh data.
  FutureOr<void> _refreshWeatherForecast(
      RefreshWeatherForecast event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather(state.currentLocation!.url);
    List<Forecast> weatherForecast = weatherRepository.getWeatherForecast();
    emit(state.copyWith(
        status: WeatherStatus.loadedWithoutStation,
        currentWeather: currentWeather,
        weatherForecast: weatherForecast));
  }

  /// Removes all stored weather data, closes stream and loads new weather and
  /// forecast data for selected location.
  ///
  /// Used when user requests location change and selected location doesn't have
  /// a weather station installed.
  FutureOr<void> _newLocationWithoutStation(
      event, Emitter<WeatherState> emit) async {
    //erase all station data and cancel current stream (if subscribed)
    emit(state.copyWith(
        status: WeatherStatus.loading,
        historicalStationData: List.empty(),
        newestStationReadings: List.empty(),
        currentWeather: null,
        currentLocation: event.location));
    if (_streamController.hasListener) {
      _databaseSubscription.cancel();
      _streamController.close();
    }
    //get only current weather and forecast for this location
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather(state.currentLocation!.url);
    List<Forecast> weatherForecast = weatherRepository.getWeatherForecast();
    emit(state.copyWith(
        status: WeatherStatus.loadedWithoutStation,
        currentWeather: currentWeather,
        weatherForecast: weatherForecast));
  }

  @override
  Future<void> close() {
    if (_streamController.hasListener) {
      _databaseSubscription.cancel();
    }
    _streamController.close();
    return super.close();
  }
}

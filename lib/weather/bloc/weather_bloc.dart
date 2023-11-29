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
    //subscribe to database stream - create new stream for each station - maybe do this in a initialisation event?
  }
  final WeatherRepository weatherRepository;
  final StreamController _streamController = StreamController();
  late final StreamSubscription<dynamic> _databaseSubscription;

  //since this is called only when we are subscribed to a location, currentLocation will be not null here
  FutureOr<void> _stationDataChanged(
      StationDataChanged event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather(state.currentLocation!.name);
    List<Forecast> weatherForecast =
        weatherRepository.getWeatherForecast(state.currentLocation!.name);
    emit(state.copyWith(
        status: WeatherStatus.loadedStation,
        newestStationReadings: event.data,
        currentWeather: currentWeather,
        weatherForecast: weatherForecast));
  }

  FutureOr<void> _subscribeNewLocation(
      SubscribeNewLocation event, Emitter<WeatherState> emit) {
    emit(state.copyWith(status: WeatherStatus.locationChanged));
    if (_streamController.hasListener) {
      _databaseSubscription.cancel();
      _streamController.close();
    }
    _streamController.addStream(
        weatherRepository.databaseDataChanged(event.location.name, 10));
    //_databaseSubscription.cancel();
    _databaseSubscription = _streamController.stream
        .listen((data) => add(StationDataChanged(data: data)));
    //stay in loading state until first subscription event fires
    emit(state.copyWith(
        status: WeatherStatus.loading, currentLocation: event.location));
  }

  //used only when station is not present
  FutureOr<void> _refreshWeatherForecast(
      RefreshWeatherForecast event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather(state.currentLocation!.name);
    List<Forecast> weatherForecast =
        weatherRepository.getWeatherForecast(state.currentLocation!.name);
    emit(state.copyWith(
        status: WeatherStatus.loadedWithoutStation,
        currentWeather: currentWeather,
        weatherForecast: weatherForecast));
  }

  FutureOr<void> _newLocationWithoutStation(
      event, Emitter<WeatherState> emit) async {
    //erase all station data and cancel current stream (if subscribed)
    emit(state.copyWith(
        status: WeatherStatus.loading,
        historicalStationData: List.empty(),
        newestStationReadings: List.empty(),
        currentWeather: null));
    if (_streamController.hasListener) {
      _databaseSubscription.cancel();
      _streamController.close();
    }
    //get only current weather and forecast for this location
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather(state.currentLocation!.name);
    List<Forecast> weatherForecast =
        weatherRepository.getWeatherForecast(state.currentLocation!.name);
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

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    //subscribe to database stream - create new stream for each station - maybe do this in a initialisation event?
    _databaseSubscription = weatherRepository
        .databaseDataChanged('Koszalin', 10)
        .listen((data) => add(StationDataChanged(data: data)));
  }
  final WeatherRepository weatherRepository;
  late final StreamSubscription<List<StationReading>> _databaseSubscription;

  FutureOr<void> _stationDataChanged(
      StationDataChanged event, Emitter<WeatherState> emit) async {
    //emit(WeatherUpdateLoading()); - think about this!
    emit(state.copyWith(status: WeatherStatus.loading));
    CurrentWeather currentWeather =
        await weatherRepository.getCurrentWeather('Koszalin');
    List<Forecast> weatherForecast =
        weatherRepository.getWeatherForecast('Koszalin');
    emit(state.copyWith(
        status: WeatherStatus.loaded,
        stationReadings: event.data,
        currentWeather: currentWeather,
        weatherForecast: weatherForecast));
  }

  @override
  Future<void> close() {
    _databaseSubscription.cancel();
    return super.close();
  }
}

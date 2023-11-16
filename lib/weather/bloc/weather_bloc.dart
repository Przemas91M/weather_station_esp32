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
  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherLoading()) {
    on<StationDataChanged>(_stationDataChanged);
    //subscribe to database stream - create new stream for each station - maybe do this in a initialisation event?
    _databaseSubscription = _weatherRepository
        .databaseDataChanged('Koszalin', 10)
        .listen((data) => add(StationDataChanged(data: data)));
  }
  final WeatherRepository _weatherRepository;
  late final StreamSubscription<List<StationReading>> _databaseSubscription;

  FutureOr<void> _stationDataChanged(
      StationDataChanged event, Emitter<WeatherState> emit) async {
    //emit(WeatherUpdateLoading()); - think about this!
    emit(WeatherLoading());
    CurrentWeather currentWeather =
        await _weatherRepository.getCurrentWeather('Koszalin');
    List<Forecast> forecastList =
        _weatherRepository.getWeatherForecast('Koszalin');
    emit(WeatherLoadSuccess(
        stationReadings: event.data,
        currentWeather: currentWeather,
        forecastList: forecastList));
  }

  @override
  Future<void> close() {
    _databaseSubscription.cancel();
    return super.close();
  }
}

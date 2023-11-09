import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/weather/models/reading.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherLoading()) {
    on<InitializeWeather>(_initializeWeather);
  }
  final WeatherRepository _weatherRepository;
  List<StationReading> _stationReadings = [];

  FutureOr<void> _initializeWeather(
      InitializeWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    _stationReadings =
        await _weatherRepository.getReadingsOnce('Readings/Koszalin', 5);
    if (_stationReadings.isEmpty) {
      emit(WeatherLoadError());
    } else {
      emit(WeatherLoadSuccess(stationReadings: _stationReadings));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../../models/location.dart';

part 'location_finder_state.dart';

class LocationFinderCubit extends Cubit<LocationFinderState> {
  final WeatherRepository _weatherRepository;
  LocationFinderCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(LocationFinderState.initial());

  Future<void> locationSearch(String query) async {
    emit(state.copyWith(status: FinderStatus.loading));
    List<Location> foundLocations = await _weatherRepository.locationFinder(
        query.trim()); //TODO replace all special characters from query string!
    emit(state.copyWith(
        status: FinderStatus.found, foundLocations: foundLocations));
  }
}

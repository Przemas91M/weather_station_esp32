import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../models/location.dart';

part 'location_management_state.dart';

class LocationManagementCubit extends Cubit<LocationManagementState> {
  final WeatherRepository _weatherRepository;
  LocationManagementCubit({required weatherRepository})
      : _weatherRepository = weatherRepository,
        super(LocationManagementState.initial()) {
    getSavedLocations();
  }

  Future<void> getSavedLocations() async {
    emit(state.copyWith(status: LocationStatus.loading));
    List<Location> locations = await _weatherRepository.getUserSavedLocations();
    emit(state.copyWith(
        status: LocationStatus.loaded, savedLocations: locations));
  }

  void reorderLocationsList(int oldIndex, int newIndex) {
    emit(state.copyWith(status: LocationStatus.loading));
    List<Location> locations = state.savedLocations;
    if (locations.isNotEmpty) {
      if (newIndex >= locations.length) {
        newIndex -= 1;
      }
      Location item = locations.removeAt(oldIndex);
      locations.insert(newIndex, item);
      emit(state.copyWith(
          status: LocationStatus.reordered, savedLocations: locations));
    }
  }

  void removeLocationFromList(int index) {
    emit(state.copyWith(status: LocationStatus.loading));
    List<Location> locations = state.savedLocations;
    if (locations.isNotEmpty) {
      locations.removeAt(index);
      _weatherRepository.saveUserSavedLocations(locations);
      emit(state.copyWith(
          status: LocationStatus.loaded, savedLocations: locations));
    }
  }

  void addAndSaveLocations(Location location) {
    List<Location> locations = state.savedLocations.toList();
    locations.add(location);
    emit(state.copyWith(savedLocations: locations));
    saveLocationsToDataBase();
  }

  void saveLocationsToDataBase() async {
    emit(state.copyWith(status: LocationStatus.loading));
    bool done =
        await _weatherRepository.saveUserSavedLocations(state.savedLocations);
    done
        ? emit(state.copyWith(status: LocationStatus.saved))
        : emit(state.copyWith(
            status: LocationStatus.error,
            errorMessage: 'Error while saving locations!'));
  }
}

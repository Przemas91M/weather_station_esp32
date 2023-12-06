import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../../../models/models.dart';

part 'station_sheet_cubit_state.dart';

/// Handles business logic of [StationBottomModalSheet] widget.
/// Requires access to [WeatherRepository] object.
class StationSheetCubit extends Cubit<StationSheetCubitState> {
  final WeatherRepository weatherRepository;

  StationSheetCubit({required this.weatherRepository})
      : super(StationSheetCubitState.initial());

  /// Requests past [limit] station readings of type [StationReading] from Firebase
  /// and stores it in state variable.
  Future<void> getStationHistoricalData(int limit) async {
    emit(state.copyWith(status: StationSheetStatus.loading));
    List<StationReading> data = await weatherRepository.getReadingsOnce(
        'Koszalin', limit); //TODO: get location from currently selected!
    emit(state.copyWith(
        status: StationSheetStatus.loaded, stationHistoricalData: data));
  }

  void changeChartData(SelectedChartData selectedData) {
    emit(state.copyWith(status: StationSheetStatus.loading));
    emit(state.copyWith(
        status: StationSheetStatus.loaded, selectedData: selectedData));
  }
}

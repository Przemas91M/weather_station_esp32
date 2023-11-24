import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../models/models.dart';

part 'station_sheet_cubit_state.dart';

class StationSheetCubit extends Cubit<StationSheetCubitState> {
  final WeatherRepository weatherRepository;

  StationSheetCubit({required this.weatherRepository})
      : super(StationSheetCubitState.initial());

  Future<void> getStationHistoricalData(int limit) async {
    emit(state.copyWith(status: StationSheetStatus.loading));
    List<StationReading> data =
        await weatherRepository.getReadingsOnce('Koszalin', limit);
    emit(state.copyWith(
        status: StationSheetStatus.loaded, stationHistoricalData: data));
  }
}

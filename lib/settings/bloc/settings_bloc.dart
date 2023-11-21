import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_station_esp32/settings/repository/settings_repo.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(SettingsState.initial()) {
    on<Initialize>(_initializeRepo);
    on<SetTheme>(_setTheme);
    on<SetPrecipUnits>(_setPrecipUnits);
    on<SetWindSpeedUnit>(_setWindSpeedUnits);
    on<SetTemperatureUnits>(_setTemperatureUnits);
  }
  final SettingsRepository _settingsRepo;
  Map<String, dynamic> settingsMap = {};

  FutureOr<void> _initializeRepo(
      Initialize event, Emitter<SettingsState> emit) async {
    await _settingsRepo.readAllSettings();
    settingsMap = _settingsRepo.getAllSettings();
    emit(state.copyWith(status: SettingsStatus.loaded, settings: settingsMap));
  }

  FutureOr<void> _setTheme(SetTheme event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loadingTheme));
    await _settingsRepo.setTheme(event.theme);
    settingsMap = _settingsRepo.getAllSettings();
    emit(state.copyWith(status: SettingsStatus.changed, settings: settingsMap));
  }

  FutureOr<void> _setPrecipUnits(
      SetPrecipUnits event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loadingPrecip));
    await _settingsRepo.setPrecipUnit(event.units);
    settingsMap = _settingsRepo.getAllSettings();
    emit(state.copyWith(status: SettingsStatus.changed, settings: settingsMap));
  }

  FutureOr<void> _setWindSpeedUnits(
      SetWindSpeedUnit event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loadingSpeed));
    await _settingsRepo.setWindSpeedUnit(event.units);
    settingsMap = _settingsRepo.getAllSettings();
    emit(state.copyWith(status: SettingsStatus.changed, settings: settingsMap));
  }

  FutureOr<void> _setTemperatureUnits(
      SetTemperatureUnits event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(status: SettingsStatus.loadingTemperature));
    await _settingsRepo.setTemperatureUnit(event.units);
    settingsMap = _settingsRepo.getAllSettings();
    emit(state.copyWith(status: SettingsStatus.changed, settings: settingsMap));
  }
}

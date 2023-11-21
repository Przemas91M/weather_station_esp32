part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();
}

class Initialize extends SettingsEvent {}

class ReadSettings extends SettingsEvent {}

class SetTheme extends SettingsEvent {
  final bool theme;
  const SetTheme({required this.theme});
}

class SetWindSpeedUnit extends SettingsEvent {
  final bool units;
  const SetWindSpeedUnit({required this.units});
}

class SetPrecipUnits extends SettingsEvent {
  final bool units;
  const SetPrecipUnits({required this.units});
}

class SetTemperatureUnits extends SettingsEvent {
  final bool units;
  const SetTemperatureUnits({required this.units});
}

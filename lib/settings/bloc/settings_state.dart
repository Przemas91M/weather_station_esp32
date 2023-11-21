part of 'settings_bloc.dart';

enum SettingsStatus {
  initial,
  loaded,
  loadingTheme,
  loadingSpeed,
  loadingPrecip,
  loadingTemperature,
  loading,
  changed,
}

class SettingsState extends Equatable {
  final SettingsStatus status;
  final Map<String, dynamic>? settings;
  const SettingsState({required this.status, required this.settings});

  static SettingsState initial() =>
      const SettingsState(settings: null, status: SettingsStatus.initial);

  SettingsState copyWith(
          {SettingsStatus? status, Map<String, dynamic>? settings}) =>
      SettingsState(
        status: status ?? this.status,
        settings: settings ?? this.settings,
      );

  @override
  List<Object?> get props => [settings, status];
}

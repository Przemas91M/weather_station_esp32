part of 'station_sheet_cubit.dart';

///All cubit states.
enum StationSheetStatus {
  initial,
  loading,
  loaded,
}

enum SelectedChartData {
  temperatureInside('Temperature inside', WeatherIcons.thermometer),
  temperatureOutside('Temperature outside', WeatherIcons.thermometer),
  humidity('Humidity', WeatherIcons.humidity),
  pressure('Pressure', WeatherIcons.barometer),
  uv('UV index', WeatherIcons.sunrise),
  lux('Light', Icons.lightbulb);

  const SelectedChartData(this.label, this.icon);
  final String label;
  final IconData icon;
}

///Contains all StationBottomModalSheet cubit states and necessary data.
class StationSheetCubitState extends Equatable {
  /// Current cubit state.
  final StationSheetStatus status;
  final SelectedChartData selectedData;

  /// Past station readings requested from database.
  final List<StationReading>? stationHistoricalData;

  const StationSheetCubitState(
      {required this.stationHistoricalData,
      required this.status,
      required this.selectedData});

  /// Initial state constructor.
  /// Removes all data and set state to initial.
  static StationSheetCubitState initial() => const StationSheetCubitState(
      status: StationSheetStatus.initial,
      stationHistoricalData: null,
      selectedData: SelectedChartData.temperatureInside);

  /// Creates a copy of this state with given fields.
  /// Only non null fields are replaced.
  StationSheetCubitState copyWith(
          {StationSheetStatus? status,
          List<StationReading>? stationHistoricalData,
          SelectedChartData? selectedData}) =>
      StationSheetCubitState(
          stationHistoricalData:
              stationHistoricalData ?? this.stationHistoricalData,
          status: status ?? this.status,
          selectedData: selectedData ?? this.selectedData);

  @override
  List<Object?> get props => [status, stationHistoricalData];
}

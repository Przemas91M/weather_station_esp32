part of 'station_sheet_cubit.dart';

///All cubit states.
enum StationSheetStatus {
  initial,
  loading,
  loaded,
}

///Contains all StationBottomModalSheet cubit states and necessary data.
class StationSheetCubitState extends Equatable {
  /// Current cubit state.
  final StationSheetStatus status;

  /// Past station readings requested from database.
  final List<StationReading>? stationHistoricalData;

  const StationSheetCubitState(
      {required this.stationHistoricalData, required this.status});

  /// Initial state constructor.
  /// Removes all data and set state to initial.
  static StationSheetCubitState initial() => const StationSheetCubitState(
      status: StationSheetStatus.initial, stationHistoricalData: null);

  /// Creates a copy of this state with given fields.
  /// Only non null fields are replaced.
  StationSheetCubitState copyWith(
          {StationSheetStatus? status,
          List<StationReading>? stationHistoricalData}) =>
      StationSheetCubitState(
          stationHistoricalData:
              stationHistoricalData ?? this.stationHistoricalData,
          status: status ?? this.status);

  @override
  List<Object?> get props => [status, stationHistoricalData];
}

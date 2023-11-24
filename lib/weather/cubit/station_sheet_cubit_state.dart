part of 'station_sheet_cubit.dart';

enum StationSheetStatus {
  initial,
  loading,
  loaded,
}

class StationSheetCubitState extends Equatable {
  final StationSheetStatus status;
  final List<StationReading>? stationHistoricalData;
  const StationSheetCubitState(
      {required this.stationHistoricalData, required this.status});

  static StationSheetCubitState initial() => const StationSheetCubitState(
      status: StationSheetStatus.initial, stationHistoricalData: null);

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

part of 'location_management_cubit.dart';

enum LocationStatus { initial, loading, loaded, error, reordered, saved }

class LocationManagementState extends Equatable {
  final LocationStatus status;
  final List<Location> savedLocations;
  final String errorMessage;
  const LocationManagementState(
      {required this.status,
      required this.savedLocations,
      required this.errorMessage});

  static LocationManagementState initial() => const LocationManagementState(
      status: LocationStatus.initial, savedLocations: [], errorMessage: '');

  LocationManagementState copyWith(
          {LocationStatus? status,
          List<Location>? savedLocations,
          String? errorMessage}) =>
      LocationManagementState(
          status: status ?? this.status,
          savedLocations: savedLocations ?? this.savedLocations,
          errorMessage: errorMessage ?? this.errorMessage);

  @override
  List<Object> get props => [status, savedLocations, errorMessage];
}

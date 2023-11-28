part of 'location_finder_cubit.dart';

enum FinderStatus { initial, loading, loaded, saved, found }

class LocationFinderState extends Equatable {
  final FinderStatus status;
  final List<Location> foundLocations;
  const LocationFinderState(
      {required this.status, required this.foundLocations});

  static LocationFinderState initial() => const LocationFinderState(
      status: FinderStatus.initial, foundLocations: []);

  LocationFinderState copyWith(
          {FinderStatus? status, List<Location>? foundLocations}) =>
      LocationFinderState(
          status: status ?? this.status,
          foundLocations: foundLocations ?? this.foundLocations);

  @override
  List<Object?> get props => [status, foundLocations];
}

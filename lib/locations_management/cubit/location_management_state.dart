part of 'location_management_cubit.dart';

sealed class LocationManagementState extends Equatable {
  const LocationManagementState();

  @override
  List<Object> get props => [];
}

final class LocationManagementInitial extends LocationManagementState {}

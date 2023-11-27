import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'location_management_state.dart';

class LocationManagementCubit extends Cubit<LocationManagementState> {
  LocationManagementCubit() : super(LocationManagementInitial());
}

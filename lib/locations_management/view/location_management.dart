import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/locations_management/cubit/location_management_cubit.dart';

import '../../weather/repository/weather_repo.dart';

class LocationManagement extends StatelessWidget {
  const LocationManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(),
      child: BlocProvider(
        create: (context) => LocationManagementCubit(),
        child: const _LocationView(),
      ),
    );
  }
}

class _LocationView extends StatelessWidget {
  const _LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

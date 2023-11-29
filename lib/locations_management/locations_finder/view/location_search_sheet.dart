import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/locations_management/cubit/location_management_cubit.dart';
import 'package:weather_station_esp32/locations_management/locations_finder/cubit/location_finder_cubit.dart';
import 'package:weather_station_esp32/locations_management/locations_finder/widgets/location_card.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';

import '../../models/location.dart';

class LocationSearchSheet extends StatelessWidget {
  const LocationSearchSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationFinderCubit(
          weatherRepository: context.read<WeatherRepository>()),
      child: const _LocationSearchSheetView(),
    );
  }
}

class _LocationSearchSheetView extends StatelessWidget {
  const _LocationSearchSheetView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10.0,
                  right: 10.0),
              child: SearchBar(
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.all(8.0)),
                leading: const Icon(Icons.search_rounded),
                onSubmitted: (value) =>
                    context.read<LocationFinderCubit>().locationSearch(value),
              ),
            ),
            const SizedBox(height: 30),
            BlocBuilder<LocationFinderCubit, LocationFinderState>(
              builder: (context, state) {
                if (state.status == FinderStatus.loading) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                if (state.status == FinderStatus.found) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Locations found:',
                        style: TextStyle(fontSize: 20),
                      ),
                      ListView(shrinkWrap: true, children: [
                        for (Location item in state.foundLocations)
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                context
                                    .read<LocationManagementCubit>()
                                    .addAndSaveLocations(item);
                              },
                              child: LocationCard(locationData: item))
                      ]),
                    ],
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}

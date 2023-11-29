import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_station_esp32/locations_management/cubit/location_management_cubit.dart';
import 'package:weather_station_esp32/locations_management/locations_finder/view/location_search_sheet.dart';

import '../../weather/repository/weather_repo.dart';
import '../models/location.dart';

class LocationManagement extends StatelessWidget {
  const LocationManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationManagementCubit(
          weatherRepository: context.read<WeatherRepository>()),
      child: const _LocationView(),
    );
  }
}

class _LocationView extends StatelessWidget {
  const _LocationView();
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LocationManagementCubit>(context);
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: const Text('Saved Locations'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => showModalBottomSheet(
                    showDragHandle: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return BlocProvider.value(
                          value: bloc, child: LocationSearchSheet());
                    }),
                icon: const Icon(Icons.add))
          ],
        ),
        body: BlocListener<LocationManagementCubit, LocationManagementState>(
          listener: (context, state) {
            if (state.status == LocationStatus.saved) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(
                    content: Text('Location saved successfuly!')));
            }
          },
          child: BlocBuilder<LocationManagementCubit, LocationManagementState>(
            builder: (context, state) {
              if (state.status == LocationStatus.initial) {
                Future.wait([
                  context.read<LocationManagementCubit>().getSavedLocations()
                ]);
                return Container();
              } else if (state.status == LocationStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == LocationStatus.loaded ||
                  state.status == LocationStatus.saved ||
                  state.status == LocationStatus.reordered) {
                return ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      context
                          .read<LocationManagementCubit>()
                          .reorderLocationsList(oldIndex, newIndex);
                    },
                    footer: state.status == LocationStatus.reordered
                        ? ElevatedButton(
                            onPressed: () => context
                                .read<LocationManagementCubit>()
                                .saveLocationsToDataBase(),
                            child: const Text('Save'))
                        : null,
                    children: [
                      for (Location item in state.savedLocations)
                        Dismissible(
                          key: Key(item.name.toString()),
                          onDismissed: (direction) {
                            int index = state.savedLocations.indexOf(item);
                            context
                                .read<LocationManagementCubit>()
                                .removeLocationFromList(index);
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Icon(Icons.delete),
                          ),
                          child: ListTile(
                              key: ValueKey(item.url.toString()),
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${item.name}, ${item.country}'),
                                  const SizedBox(width: 10),
                                  item.hasStation
                                      ? const Icon(Icons.location_on)
                                      : const Icon(Icons.location_off)
                                ],
                              ),
                              trailing: const Icon(Icons.menu)),
                        )
                    ]);
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}

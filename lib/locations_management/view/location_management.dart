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
    return /*BlocProvider(
      create: (context) => LocationManagementCubit(
          weatherRepository: context.read<WeatherRepository>()),
      child: const _LocationView(),
    );*/
        const _LocationView();
  }
}

class _LocationView extends StatelessWidget {
  const _LocationView();
  @override
  Widget build(BuildContext context) {
    //final bloc = BlocProvider.of<LocationManagementCubit>(context);
    //final repository = RepositoryProvider.of<WeatherRepository>(context);
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
                    builder: (locFindContext) {
                      return RepositoryProvider.value(
                        value:
                            RepositoryProvider.of<WeatherRepository>(context),
                        child: BlocProvider.value(
                            value: BlocProvider.of<LocationManagementCubit>(
                                context),
                            child: const LocationSearchSheet()),
                      );
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
              switch (state.status) {
                case LocationStatus.initial:
                  Future.wait([
                    context.read<LocationManagementCubit>().getSavedLocations()
                  ]);
                  return Container();

                case LocationStatus.error:
                  return const Center(child: Text('Error'));

                case LocationStatus.loading:
                  return const Center(child: CircularProgressIndicator());

                case LocationStatus.loaded ||
                      LocationStatus.saved ||
                      LocationStatus.reordered:
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
              }
            },
          ),
        ));
  }
}

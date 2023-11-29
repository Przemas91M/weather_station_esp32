import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_station_esp32/locations_management/cubit/location_management_cubit.dart';
import 'package:weather_station_esp32/locations_management/view/location_management.dart';
import 'package:weather_station_esp32/weather/bloc/weather_bloc.dart';
import 'package:weather_station_esp32/weather/repository/weather_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../settings/bloc/settings_bloc.dart';
import '../../weather/widgets/widgets.dart';
import '../../bloc/app_bloc.dart';

class WeatherMainPage extends StatelessWidget {
  const WeatherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
                weatherRepository: context.read<WeatherRepository>()),
            //..add(InitializeWeather()),
          ),
          BlocProvider(
              create: (context) => LocationManagementCubit(
                  weatherRepository: context.read<
                      WeatherRepository>()) //this gets the data on creation
              ),
        ],
        child: BlocListener<LocationManagementCubit, LocationManagementState>(
            listener: (context, state) {
              if (state.status == LocationStatus.loaded) {
                if (state.savedLocations.isEmpty) {
                  //call an event to weather bloc to show blank page with arrow pointing to add new direction
                } else {
                  //subscribe to the station - for now, later add station presence checking and react to that
                  context.read<WeatherBloc>().add(SubscribeNewLocation(
                      location: state.savedLocations.first));
                }
              }
            },
            child: const MainPage()));
  }
}

//here we are already subscribed and receiving weather data when station data changes.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final Locale locale = Localizations.localeOf(context);
    var localeVocabulary = AppLocalizations.of(context);
    Intl.defaultLocale = locale.languageCode;
    User? user = context.select((AppBloc bloc) => bloc.state.user);
    final locationManagementBloc =
        BlocProvider.of<LocationManagementCubit>(context);
    bool temperatureUnits =
        context.watch<SettingsBloc>().settingsMap['celsius'] ?? true;
    bool windSpeedUnits =
        context.watch<SettingsBloc>().settingsMap['kilometers'] ?? true;
    bool precipUnits =
        context.watch<SettingsBloc>().settingsMap['milimeters'] ?? true;

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Scaffold(
          drawer: BlocProvider.value(
              value: locationManagementBloc,
              child: _Drawer(
                user: user,
                localeVocabulary: localeVocabulary,
              )),
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            actions: [
              IconButton(
                  onPressed: () =>
                      context.read<AppBloc>().add(AppLogOutRequested()),
                  icon: const Icon(Icons.exit_to_app))
            ],
            title: Text(
              state.currentLocation?.name ?? '',
            ),
            centerTitle: true,
          ),
          body:
              BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
            if (state.status == WeatherStatus.loading) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // TODO add better loading animation
            } else if (state.status == WeatherStatus.error) {
              return const Center(
                  child:
                      Text('App loading error!\n Check internet connection!'));
            } else if (state.status == WeatherStatus.loadedStation) {
              return SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10.0, right: 25.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      //big widget showing current weather from station
                      GestureDetector(
                          child: StationReadingsCard(
                            currentWeather: state.currentWeather!,
                            reading: state.newestStationReadings!.last,
                            temperatureUnits: temperatureUnits,
                          ),
                          onTap: () => showModalBottomSheet(
                                backgroundColor: theme.colorScheme.background,
                                isScrollControlled: true,
                                enableDrag: true,
                                showDragHandle: true,
                                context: context,
                                builder: (context) => BlocProvider.value(
                                    value: locationManagementBloc,
                                    child: const StationBottomModalSheet()),
                              )),
                      TodaySummaryCard(
                          today: state.weatherForecast?.last,
                          rainUnits: precipUnits,
                          temperatureUnits: temperatureUnits,
                          windUnits: windSpeedUnits),
                      //second big widget with weather from forecast
                      //next a list with weather forecast for 7 days, depending on location selected
                      ForecastVerticalList(
                        forecastList: state.weatherForecast!,
                        temperatureUnits: temperatureUnits,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BatteryCard(
                              volts: state
                                  .newestStationReadings!.last.batteryVoltage),
                          SolarCard(
                              volts: state
                                  .newestStationReadings!.last.solarVoltage)
                        ],
                      ),

                      //big cards with auxiliary readings (UV index, rain cubics, wind direction)
                      //depending on screen size - everything should be scrollable
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
        );
      },
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({Key? key, required this.user, required this.localeVocabulary})
      : super(key: key);
  final AppLocalizations? localeVocabulary;
  final User? user;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.white,
                      child: Text(
                        user!.displayName?.substring(0, 1) ?? 'U',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0,
                            color: Colors.black),
                      )),
                  const SizedBox(height: 5),
                  Text(
                    user!.displayName ?? 'None',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user!.email ?? 'None',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300),
                  )
                ],
              )),
          ListTile(
              leading: const Icon(Icons.add),
              title: Text(localeVocabulary!.locations,
                  style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                            value: context.read<LocationManagementCubit>(),
                            child: const LocationManagement())));
              }),
          BlocBuilder<LocationManagementCubit, LocationManagementState>(
              builder: (context, state) {
            if (state.status == LocationStatus.initial) {
              Future.wait([
                context.read<LocationManagementCubit>().getSavedLocations()
              ]);
              return Container();
            } else if (state.status == LocationStatus.loading) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            } else if (state.status == LocationStatus.loaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var location in state.savedLocations)
                    ListTile(
                      leading: location.hasStation
                          ? const Icon(Icons.location_on)
                          : const Icon(Icons.location_off),
                      title:
                          Text(location.name, style: theme.textTheme.bodyLarge),
                      onTap: () {
                        Navigator.pop(
                            context); //TODO add new view with selected location
                      },
                    )
                ],
              );
            } else {
              return Container();
            }
          }),
          const Divider(
            height: 2.0,
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: Text(localeVocabulary!.settings,
                style: theme.textTheme.bodyLarge),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
              leading: const Icon(Icons.logout),
              title: Text(localeVocabulary!.logout,
                  style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                context.read<AppBloc>().add(AppLogOutRequested());
              }),
        ],
      ),
    );
  }
}

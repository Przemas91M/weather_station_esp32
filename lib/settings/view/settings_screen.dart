import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_paint,
                          color: ColorPalette.lightBlue,
                        ),
                        SizedBox(width: 20),
                        Text('Theme:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['darkTheme']
                            ? const Text('Dark')
                            : const Text('Light'),
                        Switch(
                            value: state.settings?['darkTheme'] ?? false,
                            onChanged: (value) => context
                                .read<SettingsBloc>()
                                .add(SetTheme(theme: value))),
                      ],
                    ),
                  ),
                ]),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.thermometer,
                          color: ColorPalette.lightBlue,
                        ),
                        SizedBox(width: 20),
                        Text('Temperature units:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['celsius']
                            ? const Text('°C')
                            : const Text('F'),
                        Switch(
                            value: state.settings?['celsius'] ?? false,
                            onChanged: (value) => context
                                .read<SettingsBloc>()
                                .add(SetTemperatureUnits(units: value))),
                      ],
                    ),
                  ),
                ]),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.strong_wind,
                          color: ColorPalette.lightBlue,
                        ),
                        SizedBox(width: 20),
                        Text('Wind speed units:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['kilometers']
                            ? const Text('km/h')
                            : const Text('mph'),
                        Switch(
                            value: state.settings?['kilometers'] ?? false,
                            onChanged: (value) => context
                                .read<SettingsBloc>()
                                .add(SetWindSpeedUnit(units: value))),
                      ],
                    ),
                  ),
                ]),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          WeatherIcons.rain,
                          color: ColorPalette.lightBlue,
                        ),
                        SizedBox(width: 20),
                        Text('Precipation units:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['milimeters']
                            ? const Text('mm')
                            : const Text('in'),
                        Switch(
                            value: state.settings?['milimeters'] ?? false,
                            onChanged: (value) => context
                                .read<SettingsBloc>()
                                .add(SetPrecipUnits(units: value))),
                      ],
                    ),
                  ),
                ]),
              ),
              const Divider(color: Colors.black, thickness: 1.0)
            ],
          );
        },
      ),
    );
  }
}

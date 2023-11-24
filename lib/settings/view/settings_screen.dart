import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(locale!.settings),
          centerTitle: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(10),
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const Icon(
                      Icons.format_paint,
                    ),
                    const SizedBox(width: 20),
                    Text('${locale.theme}:')
                  ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['darkTheme']
                            ? Text('${locale.dark} ')
                            : Text('${locale.light} '),
                        Switch(
                            activeColor: theme.colorScheme.secondary,
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
                thickness: 1,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          WeatherIcons.thermometer,
                        ),
                        const SizedBox(width: 20),
                        Text('${locale.tempUnits}:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['celsius']
                            ? const Text('°C ')
                            : const Text('F '),
                        Switch(
                            activeColor: theme.colorScheme.secondary,
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
                thickness: 1,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          WeatherIcons.strong_wind,
                        ),
                        const SizedBox(width: 20),
                        Text('${locale.windUnits}:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['kilometers']
                            ? const Text('km/h ')
                            : const Text('mph '),
                        Switch(
                            activeColor: theme.colorScheme.secondary,
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
                thickness: 1,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          WeatherIcons.rain,
                        ),
                        const SizedBox(width: 20),
                        Text('${locale.precipUnits}:')
                      ]),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.settings?['milimeters']
                            ? const Text('mm ')
                            : const Text('in '),
                        Switch(
                            activeColor: theme.colorScheme.secondary,
                            value: state.settings?['milimeters'] ?? false,
                            onChanged: (value) => context
                                .read<SettingsBloc>()
                                .add(SetPrecipUnits(units: value))),
                      ],
                    ),
                  ),
                ]),
              ),
              const Divider(thickness: 1.0)
            ],
          );
        },
      ),
    );
  }
}

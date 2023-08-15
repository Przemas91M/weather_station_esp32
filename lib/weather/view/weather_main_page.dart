import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app_bloc.dart';

class WeatherMainPage extends StatelessWidget {
  const WeatherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () => context.read<AppBloc>().add(AppLogOutRequested()),
            icon: const Icon(Icons.exit_to_app))
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Logged in as:'),
          Text(context.select(
              (AppBloc bloc) => bloc.state.user?.displayName ?? 'None')),
        ],
      ),
    );
  }
}

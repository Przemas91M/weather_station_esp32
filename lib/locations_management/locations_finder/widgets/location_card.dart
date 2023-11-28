import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/styling.dart';

import '../../models/location.dart';

class LocationCard extends StatelessWidget {
  final Location locationData;
  const LocationCard({super.key, required this.locationData});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline),
          color: theme.colorScheme.surface),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          locationData.hasStation
              ? const Icon(Icons.location_on)
              : const Icon(Icons.location_off),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locationData.name,
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 10),
              Text(locationData.country)
            ],
          ),
          const SizedBox(
            width: 90,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text(
                  'Click to save location',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

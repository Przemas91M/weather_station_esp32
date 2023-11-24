import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/styling.dart';

class SolarCard extends StatelessWidget {
  final double volts;
  const SolarCard({required this.volts, super.key});
  static const Map<String, Color> chargeLevel = {
    'Charging': Colors.green,
    'Off': Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    int charging = (((volts - 3.75) * 100) ~/ (6.48 - 3.75)).ceil();
    String level = 'Low';
    switch (charging) {
      case > 0:
        level = 'Charging';
        break;
      default:
        level = 'Off';
        break;
    }
    return Container(
      margin:
          const EdgeInsets.only(left: 5.0, bottom: 10.0, right: 5.0, top: 3.0),
      padding: const EdgeInsets.all(15.0),
      width: 150,
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(AppLocalizations.of(context)!.solarCell,
              style: theme.textTheme.displaySmall),
          const SizedBox(height: 7.0),
          Icon(Icons.solar_power_rounded, color: chargeLevel[level], size: 36),
          const SizedBox(height: 7.0),
          Text('$volts V'),
          const SizedBox(height: 7),
          charging > 0 ? Text('$charging %') : const Text('Off')
        ],
      ),
    );
  }
}

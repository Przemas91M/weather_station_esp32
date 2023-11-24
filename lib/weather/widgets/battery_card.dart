import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../style/styling.dart';

class BatteryCard extends StatelessWidget {
  final double volts;
  const BatteryCard({required this.volts, super.key});
  static const Map<String, Color> chargeLevel = {
    'Full': Colors.green,
    'Charging': Colors.amber,
    'Low': Colors.red
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    int charge = (((volts - 3.2) * 100) ~/ (4.2 - 3.2)).ceil();
    String level = 'Low';
    switch (charge) {
      case >= 80:
        level = 'Full';
        break;
      case < 80 && >= 20:
        level = 'Charging';
        break;
      default:
        level = 'Low';
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
          Text(AppLocalizations.of(context)!.battery,
              style: theme.textTheme.displaySmall),
          const SizedBox(height: 7.0),
          Icon(Icons.battery_charging_full_rounded,
              color: chargeLevel[level], size: 36),
          const SizedBox(height: 7.0),
          Text('$volts V'),
          const SizedBox(height: 7),
          Text('$charge %')
        ],
      ),
    );
  }
}

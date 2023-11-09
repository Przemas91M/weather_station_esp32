import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';
import 'package:intl/intl.dart';

import '../models/reading.dart';

class StationReadingsCard extends StatelessWidget {
  const StationReadingsCard({super.key, required this.reading});

  final StationReading reading;

  @override
  Widget build(BuildContext context) {
    //DateTime dateTime = DateTime.now();
    DateTime readTimestamp = DateTime.fromMillisecondsSinceEpoch(
        (reading.timestamp /*+ dateTime.timeZoneOffset.inSeconds)*/ * 1000));
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorPalette.midBlue,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: ColorPalette.midBlue,
                offset: Offset(0.0, 5.0),
                blurRadius: 5.0,
                blurStyle: BlurStyle.normal)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Latest station readings'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                const Icon(
                  Icons.add,
                  color: ColorPalette.yellow,
                ),
                Text('${reading.humidity}%')
              ]),
              Text('${reading.outsideTemperature}°C'),
              Text('UV: ${reading.uvIndex.toStringAsPrecision(1)}')
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
              'Last reading: ${DateFormat('d MMMM y HH:mm:ss').format(readTimestamp)}')
        ],
      ),
    );
  }
}

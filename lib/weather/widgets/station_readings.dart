import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class StationReadingsCard extends StatelessWidget {
  const StationReadingsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Station Readings'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('75%'),
              Text('22°C'),
              Text('UV 2'),
            ],
          )
        ],
      ),
    );
  }
}

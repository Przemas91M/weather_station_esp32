import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.textInput, required this.onTap});

  final String textInput;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorPalette.yellow),
        child: Center(
          child: Text(
            textInput,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

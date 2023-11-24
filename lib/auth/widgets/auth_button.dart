import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/styling.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.textInput, required this.onTap});

  final String textInput;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorPalette.yellow,
            boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline)),
        child: Center(
          child: Text(
            textInput,
            //always blue
            style: const TextStyle(
                color: ColorPalette.midBlue,
                fontWeight: FontWeight.w500,
                fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

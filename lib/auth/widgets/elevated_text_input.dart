import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class ElevatedTextInput extends StatelessWidget {
  const ElevatedTextInput(
      {required this.inputText,
      required this.icon,
      required this.onChanged,
      this.obscureText,
      super.key});

  final String inputText;
  final Icon icon;
  final bool? obscureText;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.midBlue, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: obscureText ?? false,
        onChanged: onChanged,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.midBlue)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.darkBlue)),
            hintStyle: const TextStyle(color: ColorPalette.midBlue),
            hintText: inputText,
            icon: icon,
            iconColor: ColorPalette.midBlue),
        style: const TextStyle(color: ColorPalette.midBlue),
      ),
    );
  }
}

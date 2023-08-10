import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class ElevatedTextInput extends StatelessWidget {
  const ElevatedTextInput(
      {required this.controller,
      required this.inputText,
      required this.icon,
      super.key});

  final TextEditingController controller;
  final String inputText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.midBlue, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.midBlue)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.darkBlue)),
            hintStyle: const TextStyle(color: ColorPalette.midBlue),
            hintText: inputText,
            icon: icon,
            iconColor: ColorPalette.midBlue),
        controller: controller,
        style: const TextStyle(color: ColorPalette.midBlue),
      ),
    );
  }
}

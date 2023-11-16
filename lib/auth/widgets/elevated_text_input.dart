import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/color_palette.dart';

class ElevatedTextInput extends StatelessWidget {
  const ElevatedTextInput(
      {required this.inputText,
      required this.helperText,
      required this.icon,
      required this.onChanged,
      this.obscureText,
      this.errorText,
      this.onEditingComplete,
      super.key});

  final String inputText;
  final String helperText;
  final Icon icon;
  final bool? obscureText;
  final String? errorText;
  final void Function(String) onChanged;
  final void Function(String)? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        decoration: BoxDecoration(
            border: Border.all(color: ColorPalette.midBlue, width: 1.0),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: ColorPalette.lightBlue,
                //offset: Offset(5.0, 5.0),
                blurRadius: 4.0, //check the style
                blurStyle: BlurStyle.normal,
              )
            ]),
        child: TextField(
          obscureText: obscureText ?? false,
          onChanged: onChanged,
          onSubmitted: onEditingComplete,
          decoration: InputDecoration(
              helperText: helperText,
              helperStyle: const TextStyle(color: ColorPalette.darkBlue),
              errorText: errorText,
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorPalette.midBlue)),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorPalette.darkBlue)),
              hintStyle: const TextStyle(color: ColorPalette.midBlue),
              hintText: inputText,
              icon: icon,
              iconColor: ColorPalette.midBlue),
          style: const TextStyle(color: ColorPalette.midBlue),
        ));
  }
}

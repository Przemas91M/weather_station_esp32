import 'package:flutter/material.dart';
import 'package:weather_station_esp32/style/styling.dart';

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
    ThemeData theme = Theme.of(context);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.colorScheme.surface,
            boxShadow: CardStyle.smallShadow(color: theme.colorScheme.outline)),
        child: TextField(
            obscureText: obscureText ?? false,
            onChanged: onChanged,
            onSubmitted: onEditingComplete,
            decoration: InputDecoration(
              helperText: helperText,
              errorText: errorText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.secondary)),
              hintText: inputText,
              icon: icon,
            )));
  }
}

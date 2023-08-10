import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        decoration: InputDecoration(hintText: inputText, icon: icon),
        controller: controller,
      ),
    );
  }
}

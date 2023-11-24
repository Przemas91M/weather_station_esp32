import 'package:flutter/material.dart';

import 'color_palette.dart';

class CardStyle {
  static thinBorder({required Color color}) =>
      Border.all(color: color, width: 1.5);
  static outline({required Color color}) => [
        BoxShadow(color: color, offset: const Offset(3.0, 3.0), blurRadius: 0.0)
      ];
  static smallShadow({required Color color}) => [
        BoxShadow(
            color: color,
            offset: const Offset(
              3.0,
              3.0,
            ),
            blurRadius: 5.0)
      ];
  static bigShadow() => const BoxShadow(
      color: ColorPalette.lightBlue,
      offset: Offset(
        0.0,
        0.0,
      ),
      blurRadius: 10.0);
}

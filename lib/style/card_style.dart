import 'package:flutter/material.dart';

import 'color_palette.dart';

class CardStyle {
  static thinBorder() => Border.all(color: ColorPalette.lightBlue, width: 1.5);
  static outline() => const BoxShadow(
      color: ColorPalette.lightBlue, offset: Offset(3.0, 3.0), blurRadius: 0.0);
  static smallShadow() => const BoxShadow(
      color: ColorPalette.lightBlue,
      offset: Offset(
        0.0,
        0.0,
      ),
      blurRadius: 5.0);
  static bigShadow() => const BoxShadow(
      color: ColorPalette.lightBlue,
      offset: Offset(
        0.0,
        0.0,
      ),
      blurRadius: 10.0);
}

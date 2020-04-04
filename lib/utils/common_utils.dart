import 'dart:ui';

import 'package:flutter/material.dart';

import '../main.dart';

class CommonUtils {

  static Color getRandomColor({ List<Color> colors, Color defColor = Colors.black }) {
    if (colors == null || colors.isEmpty) return defColor;
    else return colors[random.nextInt(colors.length)];
  }

}
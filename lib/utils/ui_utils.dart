import 'dart:ui';

import 'package:flutter/material.dart';

import '../app.dart';

class UiUtils {

  static Color getRandomColor({ List<Color> colors, Color defColor = Colors.black }) {
    if (colors == null || colors.isEmpty) return defColor;
    else return colors[random.nextInt(colors.length)];
  }

/*  static InkWell widgetCircleButton(double size, Color bcgColor,
                                    String icAssetRes, double icScale, Color icColor,
                                    Function onTap) {

    return InkWell(onTap: () => onTap(),
      child: Container(width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bcgColor),
        child: Image.asset(icAssetRes, scale: icScale, color: icColor)));
  }*/

  static Widget widgetCircleButton(double size, Color bcgColor,
                                   String icAssetRes, double icScale, Color icColor,
                                   Function onTap) {
    return RawMaterialButton(
        onPressed: () => onTap(),
        fillColor: bcgColor,
        shape: CircleBorder(),
        padding: EdgeInsets.all(8),
        child: Image.asset(icAssetRes, scale: icScale, color: icColor));
  }

}
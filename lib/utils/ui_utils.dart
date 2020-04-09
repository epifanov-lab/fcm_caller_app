import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UiUtils {

  static Future dialogEditText(BuildContext context, String currentText) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Alert Dialog"),
        content: Text("Dialog Content"),);
    });
  }

  static Widget widgetCircleButton(double size, Color bcgColor,
                                   String icAssetRes, double icScale, Color icColor,
                                   Function onTap) {
    return RawMaterialButton(
        constraints: BoxConstraints(
            minWidth: size, minHeight: size,
            maxWidth: size, maxHeight: size),
        onPressed: () => onTap(),
        fillColor: bcgColor,
        shape: CircleBorder(),
        padding: EdgeInsets.all(8),
        splashColor: invertColor(bcgColor),
        child: Image.asset(icAssetRes, scale: icScale, color: icColor));
  }

  static Color invertColor(Color color) {
    return Color.fromARGB(255, 255 - color.red, 255 - color.green, 255 - color.blue);
  }

}
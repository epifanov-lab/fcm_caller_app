import 'dart:ui';

import 'package:fcmcallerapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UiUtils {

  static Future dialogEditText(BuildContext context, String currentText) {
    return showDialog(context: context, builder: (BuildContext context) {
      TextEditingController controller = TextEditingController(text: currentText);
      return Dialog(
        backgroundColor: colorBcgMain,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                style: appTheme.textTheme.headline2,
                controller: controller,
                autofocus: true,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text('cancel', style: appTheme.textTheme.subtitle1),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () => Navigator.pop(context, controller.text),
                    child: Text('accept', style: appTheme.textTheme.subtitle1),
                  ),
                ],
              )
            ],
          ),
        ));
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
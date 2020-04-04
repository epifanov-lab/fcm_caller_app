import 'package:flutter/material.dart';

import '../app.dart';

class AvatarWidget extends StatelessWidget {
  final String name, initials;
  final int colorIndex;
  final double size;

  AvatarWidget(this.name, this.size)
      : initials = _getNameInitials(name),
        colorIndex = _calcColorIndex(name);

  static String _getNameInitials(String name) {
    String result = '';
    var split = name.split(' ');
    split.forEach((str) => result += str[0]);
    return result;
  }

  static int _calcColorIndex(String name) {
    int charSum = 0;
    name.runes.forEach((char) => charSum += char);
    return charSum % Style.userColors.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          color: Color(Style.avatarBcgColors[colorIndex])),
      child: Center(
        child: Text(
          initials.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
              color: Color(Style.userColors[colorIndex])),
        ),
      ),
    );
  }
}

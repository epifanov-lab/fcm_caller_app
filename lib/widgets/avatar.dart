import 'package:flutter/material.dart';

import '../theme.dart';

class AvatarWidget extends StatelessWidget {
  final String _name, _initials;
  final int _colorIndex;
  final double _size;

  AvatarWidget(this._name, this._size)
      : _initials = _getNameInitials(_name),
        _colorIndex = _calcColorIndex(_name);

  static String _getNameInitials(String name) {
    String result = '';
    var split = name.split(' ');
    split.forEach((str) => result += str[0]);
    return result;
  }

  static int _calcColorIndex(String name) {
    int charSum = 0;
    name.runes.forEach((char) => charSum += char);
    return charSum % userColors.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(_size / 2)),
          color: _name != 'stub' ? Color(avatarBcgColors[_colorIndex]) : Color(0xFF666666)),
      child: Center(
        child: Text(
          _name != 'stub' ? _initials.toUpperCase() : '',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: _size * 0.4,
              fontWeight: FontWeight.bold,
              color: Color(userColors[_colorIndex])),
        ),
      ),
    );
  }
}

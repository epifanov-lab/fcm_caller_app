import 'package:fcmcallerapp/entities/user.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class AvatarWidget extends StatelessWidget {
  final String _name, _initials;
  final int _colorIndex;
  final double _size;

  final Function _onTap;

  AvatarWidget(this._name, this._size, { onTap = _stubFunction })
      : _initials = _getNameInitials(_name),
        _colorIndex = _calcColorIndex(_name),
        _onTap = onTap;

  static void _stubFunction() {}

  static String _getNameInitials(String name) {
    String result = '';
    var split = name.split(' ');
    for (int i = 0; i < 2; i++) result += split[i][0];
    return result;
  }

  static int _calcColorIndex(String name) {
    int charSum = 0;
    name.runes.forEach((char) => charSum += char);
    return charSum % userColors.length;
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => _onTap(),
      constraints: BoxConstraints(
          minWidth: _size, minHeight: _size,
          maxWidth: _size, maxHeight: _size),
      shape: CircleBorder(),
      fillColor: _name != STUB_USER.name ? Color(avatarBcgColors[_colorIndex]) : Color(0xFF666666),
      child: Text(
        _name != 'stub' ? _initials.toUpperCase() : '',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: _size * 0.4,
            fontWeight: FontWeight.bold,
            color: Color(userColors[_colorIndex])),
      ),
    );
  }
}

/*
      width: _size,
      height: _size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(_size / 2)),
          color: _name != STUB_USER.name ? Color(avatarBcgColors[_colorIndex]) : Color(0xFF666666)),
* */
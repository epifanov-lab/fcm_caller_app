import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class AvatarWidget extends StatelessWidget {
  final String _name, _initials;
  final int _colorIndex;
  final double _size;

  final Function _onTap;

  AvatarWidget(this._name, this._size, { onTap = _stubFunction })
      : _initials = _name != null ? _getNameInitials(_name) : '..',
        _colorIndex = _calcColorIndex(_name),
        _onTap = onTap;

  static void _stubFunction() {}

  static String _getNameInitials(String name) {
    String result = '';
    var split = name.split(' ');
    if (split.length > 2) split.removeRange(2, split.length);
    for (int i = 0; i < split.length; i++) {
      if (split[i].isNotEmpty) result += split[i][0];
    }

    return result;
  }

  static int _calcColorIndex(String name) {
    int charSum = 0;
    name.runes.forEach((char) => charSum += char);
    return charSum % appColors.length;
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => _onTap(),
      constraints: BoxConstraints(
          minWidth: _size, minHeight: _size,
          maxWidth: _size, maxHeight: _size),
      shape: CircleBorder(),
      splashColor: UiUtils.invertColor(Color(bcgAppColors[_colorIndex])),
      fillColor: _name != STUB_USER.name ? Color(bcgAppColors[_colorIndex]) : Color(0xFF666666),
      child: Text(
        _name != 'stub' ? _initials.toUpperCase() : '',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: _size * 0.4,
            fontWeight: FontWeight.bold,
            color: Color(_name != STUB_USER.name ? appColors[_colorIndex] : 0xFFFFFFFF)),
      ),
    );
  }
}
import 'dart:ui';

import 'package:flutter/material.dart';

class UserPic {

  static final List<int> _textColors = [0xFFF44336, 0xFFe91e63, 0xFF9C27B0, 0xFF673AB7,
    0xFF3F51B5, 0xFF2196F3, 0xFF03A9F4, 0xFF00BCD4, 0xFF009688,
    0xFF4CAF50, 0xFF8BC34A, 0xFFFF9800, 0xFFFF5722, 0xFF607D8B];

  static final List<int> _bcgColors = _textColors
      .map((color) => Color.alphaBlend(Colors.white70, Color(color)))
      .map((color) => color.value)
      .toList();
}
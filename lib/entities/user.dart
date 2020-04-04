import 'package:fcmcallerapp/utils/names_generator.dart';

import '../app.dart';

class User {

  static final List<int> _colors =
    [0xFFF44336, 0xFFe91e63, 0xFF9C27B0, 0xFF673AB7,
    0xFF3F51B5, 0xFF2196F3, 0xFF03A9F4, 0xFF00BCD4, 0xFF009688,
    0xFF4CAF50, 0xFF8BC34A, 0xFFFF9800, 0xFFFF5722, 0xFF607D8B];

  final String token;
  final String name;
  final int color;

  User._(this.token, this.name, this.color);

  User.generate(String token)
      : this._(token, NamesGenerator.create(),
        _colors[random.nextInt(_colors.length - 1)]);

  User.fromJson(Map<String, dynamic> json)
      : this._(json['token'], json['name'], json['color']);

}
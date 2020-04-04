import 'package:fcmcallerapp/utils/names_generator.dart';

import '../app.dart';

class User {

  final String token;
  final String name;

  User._(this.token, this.name);

  User.generate(String token)
      : this._(token, NamesGenerator.create());

  User.fromJson(Map<String, dynamic> json)
      : this._(json['token'], json['name']);

}
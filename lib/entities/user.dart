import 'dart:convert';

import 'package:fcmcallerapp/utils/names_generator.dart';

const User STUB_USER = const User.stub();

class User {

  final String token;
  final String name;

  User._(this.token, this.name);

  User.generate(String token)
      : this._(token, NamesGenerator.create());

  User.fromJson(Map<String, dynamic> json)
      : this._(json['token'], json['name']);

  const User.stub() : token = 'stub', name = 'stub';

  String toJson() => json.encode({'token': token, 'name': name});
  @override
  String toString() {
    return 'User{name: $name}';
  }

}
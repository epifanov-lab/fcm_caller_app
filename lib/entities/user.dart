import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmcallerapp/utils/names_generator.dart';

const User STUB_USER = const User.stub();

class User {

  final String token;
  final String name;

  User(this.token, this.name);

  User.generate(String token)
      : this(token, NamesGenerator.create());

  User.fromJson(Map<String, dynamic> json)
      : this(json['token'], json['name']);

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this(snapshot['token'], snapshot['name']);

  const User.stub() : token = 'stub-token', name = '... ...';

  String toJson() => json.encode({'token': token, 'name': name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() {
    return 'User{token: $token, name: $name}';
  }

}
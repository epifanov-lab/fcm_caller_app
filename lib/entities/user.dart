import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmcallerapp/utils/names_generator.dart';

User STUB_USER = User.stub();

class User {

  final String id;
  final String token;
  final String type;
  String name;

  User(this.id, this.token, this.type, this.name);

  User.generate(String token)
      : this(_genDocId(token), token, 'mobile', NamesGenerator.create());

  User.fromJson(Map<String, dynamic> json)
      : this(json['id'], json['token'], json['type'], json['name']);

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this(snapshot['id'], snapshot['token'], snapshot['type'], snapshot['name']);

  User.stub() : this( 'stub-id', 'stub-token', 'stub-type', '... ...');

  String toJson() => json.encode({'id': id, 'token': token, 'type': type, 'name': name});

  static String _genDocId(String token) {
    return '${Platform.operatingSystem}-${token.hashCode}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'User{name: $name}';

}
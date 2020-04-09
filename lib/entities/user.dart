import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmcallerapp/utils/names_generator.dart';

User STUB_USER = User.stub();

class User {

  final String token;
  final String docId;
  String name;

  User(this.token, this.docId, this.name);

  User.generate(String token)
      : this(token, _genDocId(token), NamesGenerator.create());

  User.fromJson(Map<String, dynamic> json)
      : this(json['token'], json['docId'], json['name']);

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this(snapshot['token'], snapshot['docId'], snapshot['name']);

  User.stub() : this('stub-token', 'stub-docId', '... ...');

  String toJson() => json.encode({'token': token, 'docId': docId, 'name': name});

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
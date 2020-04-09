import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmcallerapp/entities/user.dart';


class FirestoreService {

  final Firestore _firestore = Firestore.instance..settings(persistenceEnabled: false);

  Future<List> getUsers() {
    print('@@@@@ FS: getUsers');
    return _firestore.collection('users').snapshots().first
        .then((snapshot) => snapshot.documents)
        .then((documents) {
      print('@@@@@ FS: getUsers.result: ${documents.length}');
      List<User> result = List();
      documents.forEach((document) {
        var user = User.fromSnapshot(document);
        print('@@@@@ FS: getUsers.result: ${user.name}');
        result.add(user);
      });
      return result;
    });
  }

  Future<User> register(User user) {
    print('@@@@@ FS: register $user');
    return _firestore.collection('users')
        .document(user.docId)
        .setData(json.decode(user.toJson()))
        .then((docref) => user);
  }

  Future rename(User user) {
    print('@@@@@ FS: renamed $user');
    return _firestore.collection('users')
        .document(user.docId)
        .setData(json.decode(user.toJson()));
  }

}
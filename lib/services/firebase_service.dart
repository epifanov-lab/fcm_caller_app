import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/services/client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class FirebaseService extends RestApi {

  static const String FCM_SERVER_KEY = 'key=AAAAT5n4t90:APA91bFNmsK2qzPc7S-4qF3Ao3fpEUfeEBRLCntF9SFqCC1Gmwgtd-4_oI4uFiHf2JigcwD80toMLWd_Kq36fk6mGhD5_xvDzjv16xcrwstaICnn-GAh_MZtJmrD3XKBxYMP7HGlBgu3';

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final Firestore _firestore = Firestore.instance;

  Future<String> initialize() async {
    _fcm.requestNotificationPermissions(IosNotificationSettings(provisional: true));
    _fcm.subscribeToTopic('calls');

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("@@@@@ f.FcmService onMessage: $message");
        //todo слушать Refresh
      },

      onLaunch: (Map<String, dynamic> message) async {
        print("@@@@@ f.FcmService onLaunch: $message");
      },

      onResume: (Map<String, dynamic> message) async {
        print("@@@@@ f.FcmService onResume: $message");
      },
    );

    return _fcm.getToken();
  }

  @override
  Future<List<User>> getUsers() {
    print('@@@@@ FS: getUsers');
    return _firestore.collection('users').snapshots().first
        .then((snapshot) => snapshot.documents)
        .then((documents) {
          print('@@@@@ FS: getUsers.result: ${documents.length}');
          List<User> result = List();
          documents.forEach((document) {
            print('@@@@@ FS: getUsers.result: ${document.data}');
            var user = User.fromSnapshot(document);
            result.add(user);
          });
          return result;
    });
  }

  @override
  Future<User> register(User user) {
    print('@@@@@ FS: register $user');
    return _firestore.collection('users')
        .add(json.decode(user.toJson()))
              .then((docref) => user);
  }

  @override
  Future call(User from, User to) {
    print('@@@@@ FS: call \nfrom:$from\nto:$to');
    return http.post('https://fcm.googleapis.com/fcm/send',
      headers: {
        'Authorization': FCM_SERVER_KEY,
        'Content-Type': 'application/json'},
      body: json.encode({
        "to": "/topics/calls",
        "collapse_key": "type_a",
        "data" : {
          "body" : from.toJson(),
          "title": from.name
        }
      })).then((response) => print('@@@@@ result: ${response.body}'));
  }

  @override
  Future callAll() {
    print('@@@@@ FS: callAll');
    return http.post('https://fcm.googleapis.com/fcm/send',
        headers: {
          'Authorization': FCM_SERVER_KEY,
          'Content-Type': 'application/json'},
        body: json.encode({
          "to": "/topics/calls",
          "collapse_key": "type_a",
          "data" : {
            "body" : "",
            "title": "Проверка связи!"
          }
        })).then((response) => print('@@@@@ result: ${response.body}'));
  }

  @override
  Future callReceiveAnswer(User from, User to) {
    print('@@@@@ FS: callReceiveAnswer');
  }

  @override
  Future callReceiveDismiss(User from, User to) {
    print('@@@@@ FS: callReceiveDismiss');
  }

  @override
  Future callSendCancel(User from, User to) {
    print('@@@@@ FS: callSendCancel');
  }

}
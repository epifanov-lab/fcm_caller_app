import 'dart:convert';

import 'package:fcmcallerapp/entities/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<dynamic> _onBackgroundMessage(Map<String, dynamic> message) {
  print("@@@@@ f.FcmService onBackgroundMessage: $message");
  return Future.value(null);
}

class FcmService {

  static const String FCM_SERVER_KEY = 'key=AAAAT5n4t90:APA91bFNmsK2qzPc7S-4qF3Ao3fpEUfeEBRLCntF9SFqCC1Gmwgtd-4_oI4uFiHf2JigcwD80toMLWd_Kq36fk6mGhD5_xvDzjv16xcrwstaICnn-GAh_MZtJmrD3XKBxYMP7HGlBgu3';

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<String> initialize() async {
    _fcm.requestNotificationPermissions(IosNotificationSettings(provisional: true));
    _fcm.subscribeToTopic('calls');

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("@@@@@ f.FcmService onMessage: $message");
      },

      onLaunch: (Map<String, dynamic> message) async {
        print("@@@@@ f.FcmService onLaunch: $message");
      },

      onResume: (Map<String, dynamic> message) async {
        print("@@@@@ f.FcmService onResume: $message");
      },

      onBackgroundMessage: _onBackgroundMessage
    );

    return _fcm.getToken();
  }

  Future call(User from, User to) {
    print('@@@@@ FS: call \nfrom:$from\nto:$to');
    return http.post('https://fcm.googleapis.com/fcm/send',
        headers: {
          'Authorization': FCM_SERVER_KEY,
          'Content-Type': 'application/json'},
        body: json.encode({
          'to': '/device/${to.token}',
          'data' : {
            'userType' : 'mobile',
            'body' : from.toJson(),
            'userName': from.name
          }
        })).then((response) => print('@@@@@ result: ${response.body}'))
        .catchError((error) => print('@@@@@ error: $error'));
  }


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
            'userType' : 'mobile',
            "body" : '',
            "title": 'Проверка связи!'
          }
        })).then((response) => print('@@@@@ result: ${response.body}'));
  }

}
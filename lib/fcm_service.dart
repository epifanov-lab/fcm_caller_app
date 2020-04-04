import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  String token;

  Future initialize() async {
    _fcm.requestNotificationPermissions(IosNotificationSettings(provisional: true));
    _fcm.subscribeToTopic('calls');

    token = await _fcm.getToken();
    print('@@@@@ f.FcmService TOKEN: $token');

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
    );
  }
}
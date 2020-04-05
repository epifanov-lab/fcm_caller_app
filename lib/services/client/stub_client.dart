import 'package:fcmcallerapp/entities/user.dart';

import 'client.dart';

class StubClient extends AppClient {

  static User _user;

  static const String DUMMY_TOKEN = 'cuwf27CBQYy-bEPVJyP3Xh:APA91bGmLEQhUA'
      'AlY3uzSS7Mzb5NrTWp7VRCE6pIaRGe6iunJfc585TU1IA2S3uXkSycCGUMySBEly1_1y'
      'BUw2WDnRdj75So78CyhBsmknPRiGtpixrtcnBWhn74gCTW2YobBIKnM40f';

  static List<User> getRandomUsers(int count) {
    List<User> result = List();
    for (int i = 0; i < count; i++) {
      var user = i == 0 ? _user??STUB_USER : User.generate('$DUMMY_TOKEN');
      print('@@@@@ getRandomUsers: $user');
      result.add(user);
    }
    return result;
  }

  @override
  Future<List<User>> users()
    => Future.value(getRandomUsers(10));

  @override
  Future register(User user) {
    print('@@@@@ register: $user');
    _user = user;
    return Future.value({});
  }

  @override
  Future call(User from, User to)
    => Future.value({});

  @override
  Future callReceiveAnswer(User from, User to)
    => Future.value({});

  @override
  Future callReceiveDismiss(User from, User to)
    => Future.value({});

  @override
  Future callSendCancel(User from, User to)
    => Future.value({});

}

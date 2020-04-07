import 'package:fcmcallerapp/entities/user.dart';

abstract class RestApi {
  Future<List<User>> getUsers();
  Future<User> register(User user);
  Future call(User from, User to);
  Future callAll();
  Future callSendCancel(User from, User to);
  Future callReceiveDismiss(User from, User to);
  Future callReceiveAnswer(User from, User to);
}

class StubClient extends RestApi {

  static const String DUMMY_TOKEN = 'cuwf27CBQYy-bEPVJyP3Xh:APA91bGmLEQhUA'
      'AlY3uzSS7Mzb5NrTWp7VRCE6pIaRGe6iunJfc585TU1IA2S3uXkSycCGUMySBEly1_1y'
      'BUw2WDnRdj75So78CyhBsmknPRiGtpixrtcnBWhn74gCTW2YobBIKnM40f';

  static User _user;

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
  Future<List<User>> getUsers()
  => Future.value(getRandomUsers(10));

  @override
  Future<User> register(User user) {
    print('@@@@@ register: $user');
    _user = user;
    return Future.value(user);
  }

  @override
  Future call(User from, User to)
  => Future.value({});

  @override
  Future callAll()
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

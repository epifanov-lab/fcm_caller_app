import 'package:fcmcallerapp/entities/user.dart';

class TestUtils {

  /* length 163 */
  static const String DUMMY_TOKEN = 'cuwf27CBQYy-bEPVJyP3Xh:APA91bGmLEQhUA'
      'AlY3uzSS7Mzb5NrTWp7VRCE6pIaRGe6iunJfc585TU1IA2S3uXkSycCGUMySBEly1_1y'
      'BUw2WDnRdj75So78CyhBsmknPRiGtpixrtcnBWhn74gCTW2YobBIKnM40f';

  static List<User> getRandomUsers(int count) {
    List<User> result = List();
    for (int i = 0; i < count; i++)
      result.add(User.generate('$DUMMY_TOKEN'));
    return result;
  }

  static String generateDummyToken() {
    return 'todo';
  }
}
import 'package:fcmcallerapp/entities/user.dart';
import 'package:flutter/material.dart';

class TestUtils {
  static List<User> getRandomUsers(int count) {
    List<User> result = List();
    for (int i = 0; i < count; i++)
      result.add(User.generate('${dummyToken()}'));
    return result;
  }

  static List<Widget> getUserTextWidgetsList(List<User> users) {
    List<Widget> result = List();
    users.forEach((user) {
      var style = TextStyle(color: Color(user.color));
      var widget = Text(user.name, style: style);
      result.add(widget);
    });
    return result;
  }

  static String dummyToken() {
    return 'token'; //todo
  }
}
// result.add(Text(user.name, style: TextStyle(color: Color(user.color))));
// 163 chars
// cuwf27CBQYy-bEPVJyP3Xh:APA91bGmLEQhUAAlY3uzSS7Mzb5NrTWp7VRCE6pIaRGe6iunJfc585TU1IA2S3uXkSycCGUMySBEly1_1yBUw2WDnRdj75So78CyhBsmknPRiGtpixrtcnBWhn74gCTW2YobBIKnM40f
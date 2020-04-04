import 'package:fcmcallerapp/main.dart';
import 'package:flutter/material.dart';

import 'screens/users_and_avatart.dart';

void main() {
  runApp(FcmCallerApp());
}

class FcmCallerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ui-test-zone',
      theme: Style.appTheme,
      home: TestUsersAndAvatars(),
      debugShowCheckedModeBanner: false,
    );
  }
}

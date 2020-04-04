import 'package:fcmcallerapp/client/client.dart';
import 'package:fcmcallerapp/client/stub_client.dart';
import 'package:fcmcallerapp/style.dart';
import 'package:flutter/material.dart';

import 'fcm_service.dart';
import 'screens/main_screen.dart';

FcmService fcmService = FcmService();
Client client = StubClient();

void main() {
  runApp(FcmCallerApp());
  fcmService.initialize();
}

class FcmCallerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcm-caller-app',
      theme: Style.appTheme,
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
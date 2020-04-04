import 'dart:math';

import 'file:///C:/LAB/fcm_caller_app/lib/services/client/client.dart';
import 'file:///C:/LAB/fcm_caller_app/lib/services/client/stub_client.dart';
import 'file:///C:/LAB/fcm_caller_app/lib/services/storage.dart';
import 'package:flutter/material.dart';

import 'services/fcm_service.dart';
import 'screens/main_screen.dart';

//region global
Random random = Random();
FcmService fcmService = FcmService();
Client client = StubClient();
Storage storage = TemporaryStorage();
//endregion

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

class Style {
  static const Color colorBcgMain = const Color(0xFF333333);

  static final ThemeData appTheme = ThemeData(
      scaffoldBackgroundColor: colorBcgMain,
      appBarTheme: AppBarTheme(
          color: Colors.black
      ),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 24.0),
        subtitle1: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        caption: TextStyle(fontSize: 10.0),
      )
  );
}
import 'dart:math';

import 'package:flutter/material.dart';

import 'file:///C:/LAB/fcm_caller_app/lib/services/client/client.dart';
import 'file:///C:/LAB/fcm_caller_app/lib/services/client/stub_client.dart';
import 'file:///C:/LAB/fcm_caller_app/lib/services/storage.dart';

import 'screens/main_screen.dart';
import 'services/fcm_service.dart';

Random random = Random();
FcmService fcmService = FcmService();
Client client = StubClient();
Storage storage = TemporaryStorage();

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'fcm-caller-app',
    theme: Style.appTheme,
    home: MainScreen(),
    debugShowCheckedModeBanner: false,
  );
}

class FcmCallerApp extends StatelessWidget {
  final Widget _startScreenWidget;

  FcmCallerApp(this._startScreenWidget) {
    fcmService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcm-caller-app',
      theme: Style.appTheme,
      home: _startScreenWidget,
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
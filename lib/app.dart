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

class FcmCallerApp extends StatefulWidget {
  final Widget _startScreenWidget;
  FcmCallerApp(this._startScreenWidget);

  @override
  _FcmCallerAppState createState() => _FcmCallerAppState();
}

class _FcmCallerAppState extends State<FcmCallerApp> {

  @override
  void initState() {
    fcmService.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcm-caller-app',
      theme: Style.appTheme,
      home: widget._startScreenWidget,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Style {
  static const Color colorBcgMain = const Color(0xFF333333);
  static const Color textColorMain = const Color(0xFFFFFFFF);

  static final List<int> userColors =
  [0xFFF44336, 0xFFe91e63, 0xFF9C27B0, 0xFF673AB7,
    0xFF3F51B5, 0xFF2196F3, 0xFF03A9F4, 0xFF00BCD4, 0xFF009688,
    0xFF4CAF50, 0xFF8BC34A, 0xFFFF9800, 0xFFFF5722, 0xFF607D8B];

  static final List<int> avatarBcgColors = userColors
      .map((color) => Color.alphaBlend(Colors.white70, Color(color)))
      .map((color) => color.value)
      .toList();

  static final ThemeData appTheme = ThemeData(
      appBarTheme: AppBarTheme(color: Colors.black),
      scaffoldBackgroundColor: colorBcgMain,

      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        headline2: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        subtitle1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        caption: TextStyle(fontSize: 10.0),
      ).apply(
        bodyColor: textColorMain,
        displayColor: textColorMain
      )
  );
}
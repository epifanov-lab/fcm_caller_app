import 'dart:math';

import 'package:flutter/material.dart';

import 'file:///C:/LAB/fcm_caller_app/lib/services/client/client.dart';
import 'file:///C:/LAB/fcm_caller_app/lib/services/client/stub_client.dart';
import 'file:///C:/LAB/fcm_caller_app/lib/services/storage.dart';

import 'screens/main_screen.dart';
import 'services/fcm_service.dart';
import 'theme.dart';

Random random = Random();
FcmService fcmService = FcmService();
AppClient client = StubClient();
Storage storage = TemporaryStorage();

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'fcm-caller-app',
    theme: appTheme,
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcm-caller-app',
      theme: appTheme,
      home: widget._startScreenWidget,
      debugShowCheckedModeBanner: false,
    );
  }
}
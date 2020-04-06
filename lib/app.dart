import 'dart:math';

import 'package:fcmcallerapp/screens/call_send_screen.dart';
import 'package:fcmcallerapp/services/client.dart';
import 'package:flutter/material.dart';

import 'file:///C:/LAB/fcm_caller_app/lib/services/storage.dart';

import 'screens/main_screen.dart';
import 'services/firebase_service.dart';
import 'theme.dart';

Random random = Random();
FirebaseService fcmService = FirebaseService();
RestApi client = fcmService;
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
  @override
  _FcmCallerAppState createState() => _FcmCallerAppState();
}

class _FcmCallerAppState extends State<FcmCallerApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcm-caller-app',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/call': (context) => CallSendScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
import 'dart:math';

import 'package:fcmcallerapp/screens/call_send_screen.dart';
import 'package:fcmcallerapp/screens/call_receive_screen.dart';
import 'package:fcmcallerapp/services/firestore_service.dart';
import 'package:fcmcallerapp/services/wss_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/main_screen.dart';
import 'services/fcm_service.dart';
import 'theme.dart';

Random random = Random();
FcmService fcm = FcmService();
FirestoreService firestore = FirestoreService();
WssService wss = WssService();

void main() => runApp(FcmCallerApp());

class FcmCallerApp extends StatefulWidget {
  @override
  _FcmCallerAppState createState() => _FcmCallerAppState();
}

class _FcmCallerAppState extends State<FcmCallerApp>  with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    didChangeAppLifecycleState(AppLifecycleState.resumed);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    wss?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)
    => wss?.onLifecycleStateChanged(state);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcm-caller-app',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/callSend': (context) => CallSendScreen(),
        '/callReceive': (context) => CallReceiveScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
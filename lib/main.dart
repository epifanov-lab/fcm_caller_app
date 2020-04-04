import 'package:fcmcallerapp/style.dart';
import 'package:flutter/material.dart';

import 'fcm_service.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(FcmCallerApp());
  FcmService.get().initialize();
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
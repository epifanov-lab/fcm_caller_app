import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CallSendScreen extends StatefulWidget {
  @override
  _CallSendScreenState createState() => _CallSendScreenState();
}

class _CallSendScreenState extends State<CallSendScreen> {

  String _calling = 'в ы з о в';

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AvatarWidget(user.name, 96),
              SizedBox(height: 24),
              Text(user.name, style: appTheme.textTheme.headline1),
              SizedBox(height: 4),
              Text(_calling, style: appTheme.textTheme.subtitle1),
            ],
          ),
        ),
    );
  }
}

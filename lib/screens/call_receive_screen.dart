import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CallReceiveScreen extends StatefulWidget {
  @override
  _CallReceiveScreenState createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen>
    with SingleTickerProviderStateMixin {

  Animation<int> _textAnimation;
  AnimationController _textAnimationController;

  final String _calling = 'вызывает';
  String _splash = '';

  @override
  void initState() {
    super.initState();
    startCallLabelAnimation();
  }

  void startCallLabelAnimation() {
    _textAnimationController = AnimationController(duration: const Duration(milliseconds: 750), vsync: this);
    _textAnimation = IntTween(begin: 0, end: _calling.length).animate(_textAnimationController)
      ..addListener(() {
        setState(() {
          int index = _textAnimation.value;
          _splash = _calling.replaceRange(index, index, '\u25CF');
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _textAnimationController.reverse();
        else if (status == AnimationStatus.dismissed) _textAnimationController.forward();
      });
    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context).settings.arguments??STUB_USER;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 160),
                    AvatarWidget(user.name, 96),
                    SizedBox(height: 24),
                    Text(user.name, style: appTheme.textTheme.headline1),
                    SizedBox(height: 4),
                    Text(_splash, style: appTheme.textTheme.subtitle1),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  UiUtils.widgetCircleButton(56, colorBcgCancel,
                      'assets/icons/ic_cancel.png', 2, Colors.white,
                          () => _cancelCall(context)),
                  UiUtils.widgetCircleButton(56, colorBcgAccept,
                      'assets/icons/ic_call_answer.png', 2, Colors.white,
                          () => _cancelCall(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelCall(BuildContext context) => Navigator.pop(context);
}
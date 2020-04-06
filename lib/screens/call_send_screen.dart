import 'package:fcmcallerapp/entities/user.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CallSendScreen extends StatefulWidget {
  @override
  _CallSendScreenState createState() => _CallSendScreenState();
}

class _CallSendScreenState extends State<CallSendScreen>
    with SingleTickerProviderStateMixin {

  Animation<int> _textAnimation;
  AnimationController _textAnimationController;

  final String _calling = 'вызов';
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
    final User user = ModalRoute.of(context).settings.arguments;
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
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                  ),
                  child: Image.asset(
                      'assets/icons/ic_call_end.png',
                      scale: 1.5, color: Colors.white),
                  margin: EdgeInsets.all(32),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

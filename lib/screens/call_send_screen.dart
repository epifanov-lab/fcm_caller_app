import 'dart:async';

import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:fcmcallerapp/widgets/wss_status_bar.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../theme.dart';

class CallSendScreen extends StatefulWidget {
  @override
  _CallSendScreenState createState() => _CallSendScreenState();
}

class _CallSendScreenState extends State<CallSendScreen>
    with SingleTickerProviderStateMixin {

  Map<String, dynamic> _arguments;

  Animation<int> _textAnimation;
  AnimationController _textAnimationController;

  final String _calling = 'вызываю';
  String _splash = '';

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    startCallLabelAnimation();

    _subscription = wss.data.listen((data) {
      if (data[0] == 'call:get answer') _onRecipientAnswered(context, data);
    });
  }

  void _cancelCall(BuildContext context) {
    wss.sendMessage('call:send cancel', _arguments['id']);
    Navigator.pop(context);
  }

  void _onRecipientAnswered(BuildContext context, List data) {
    Navigator.pop(context, data);
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned(right: 0, child: WssStatusBar(wss.states)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 160),
                          AvatarWidget(_arguments['name'], 96),
                          SizedBox(height: 24),
                          Text(_arguments['name'], style: appTheme.textTheme.headline1),
                          SizedBox(height: 4),
                          Text(_splash, style: appTheme.textTheme.subtitle1),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: UiUtils.widgetCircleButton(56, colorBcgCancel,
                        'assets/icons/ic_call_end.png', 1.5, Colors.white,
                            () => _cancelCall(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
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

}
import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:fcmcallerapp/widgets/avatar.dart';
import 'package:fcmcallerapp/widgets/wss_status_bar.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../theme.dart';

class CallReceiveScreen extends StatefulWidget {
  @override
  _CallReceiveScreenState createState() => _CallReceiveScreenState();
}

class _CallReceiveScreenState extends State<CallReceiveScreen>
    with SingleTickerProviderStateMixin {

  List<dynamic> _arguments;

  Animation<int> _textAnimation;
  AnimationController _textAnimationController;

  AudioPlayer _audioPlayer;

  final String _calling = 'вызывает';
  String _splash = '';

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    startCallLabelAnimation();
    playSound();

    _subscription = wss.data.listen((map) {
      if (map[0] == 'call:get cancel') _onRecipientCancelled(context);
    });
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _audioPlayer.stop();
    _subscription.cancel();
    super.dispose();
  }

  void _cancelCall(BuildContext context) {
    wss.sendMessage('call:send cancel', _arguments[2]);
    Navigator.pop(context);
  }

  void _answerCall(BuildContext context) {
    wss.sendMessage('call:send answer', _arguments[2]);
    Navigator.pop(context);
  }

  void _onRecipientCancelled(BuildContext context) {
    Navigator.pop(context);
  }

  Future playSound() async {
    AudioCache cache = new AudioCache();
    _audioPlayer = await cache.play('sounds/bell.mp3', volume: 0.75);
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
                        AvatarWidget(_arguments[1]['name'], 96),
                        SizedBox(height: 24),
                        Text(_arguments[1]['name'], style: appTheme.textTheme.headline1),
                        SizedBox(height: 4),
                        Text(_splash, style: appTheme.textTheme.subtitle1),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      UiUtils.widgetCircleButton(56, colorBcgCancel,
                          'assets/icons/ic_cancel.png', 2, Colors.white,
                              () => _cancelCall(context)),
                      UiUtils.widgetCircleButton(56, colorBcgAccept,
                          'assets/icons/ic_call_answer.png', 2, Colors.white,
                              () => _answerCall(context)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
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
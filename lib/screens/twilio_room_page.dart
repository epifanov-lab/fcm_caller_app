import 'dart:async';

import 'package:fcmcallerapp/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';


class TwilioRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TwilioRoomPageState();
}

class _TwilioRoomPageState extends State<TwilioRoomPage> {

  List<dynamic> _arguments;

  CameraCapturer _cameraCapturer;
  LocalVideoTrack _localVideoTrack;
  LocalAudioTrack _localAudioTrack;

  Map<String, Widget> _participants = Map<String, Widget>();

  Room _room;
  final Completer<Room> _completer = Completer<Room>();

  @override
  void initState() {
    _cameraCapturer = CameraCapturer(CameraSource.FRONT_CAMERA);
    _localVideoTrack = LocalVideoTrack(true, _cameraCapturer);
    _localAudioTrack = LocalAudioTrack(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Center(child: Text('TWILIO:\nTOKEN: ${_arguments[1]}\nROOMID: ${_arguments[2]}',
            style: appTheme.textTheme.subtitle1)),
      ));
  }

}
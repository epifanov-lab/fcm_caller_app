import 'dart:async';

import 'package:fcmcallerapp/utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';

import '../main.dart';
import '../theme.dart';


class TwilioRoomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TwilioRoomPageState();
}

class _TwilioRoomPageState extends State<TwilioRoomPage> {

  List<dynamic> _arguments;
  String _token, _roomId;

  CameraCapturer _cameraCapturer;
  LocalVideoTrack _localVideoTrack;
  LocalAudioTrack _localAudioTrack;
  bool isConnected = false;

  Room _room;
  Map<String, Widget> _participants = Map<String, Widget>();
  final Completer<Room> _completer = Completer<Room>();

  StreamSubscription _subscription;

  @override
  void initState() {
    _cameraCapturer = CameraCapturer(CameraSource.FRONT_CAMERA);
    _localVideoTrack = LocalVideoTrack(true, _cameraCapturer);
    _localAudioTrack = LocalAudioTrack(true);

    _subscription = wss.data.listen((data) {
      if (data[0] == 'call:get cancel') {
        _room.disconnect();
        Navigator.pop(context);
      }
    });

    Future.delayed(Duration(milliseconds: 300))
        .then((_) =>_connectToRoom())
        .then((_) => setState(() => isConnected = true));

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
  }

  Future<Room> _connectToRoom() async {
    ConnectOptions connectOptions = ConnectOptions(
        _token, roomName: _roomId,
        audioTracks: [_localAudioTrack],
        videoTracks: [_localVideoTrack]
    );

    _room = await TwilioProgrammableVideo.connect(connectOptions)
        ..onConnected.listen(_onConnected)
        ..onConnectFailure.listen(_onConnectFailure)
        ..onParticipantConnected.listen(_onParticipantConnected)
        ..onParticipantDisconnected.listen(_onParticipantDisconnected);

    return _completer.future;
  }

  void _onConnected(Room room) {
    print('Connected to ${room.name}');
    room.remoteParticipants.forEach((participant) {
      setState(() {
        participant.remoteVideoTracks.forEach((RemoteVideoTrackPublication track) {
          if (track.isTrackSubscribed) _participants[participant.identity] = track.remoteVideoTrack.widget(mirror: false);
        });
      });
      participant.onVideoTrackSubscribed.listen((RemoteVideoTrackSubscriptionEvent event) {
        setState(() {
          _participants[participant.identity] = event.remoteVideoTrack.widget(mirror: false);
        });
      });
    });
    _completer.complete(_room);
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    print('Failed to connect to room ${event.room.name} with exception: ${event.exception}');
    _completer.completeError(event.exception);
  }

  void _onParticipantConnected(RoomParticipantConnectedEvent roomEvent) {
    roomEvent.remoteParticipant.onVideoTrackSubscribed.listen((RemoteVideoTrackSubscriptionEvent event) {
      setState(() {
        _participants[roomEvent.remoteParticipant.identity] = event.remoteVideoTrack.widget(mirror: false);
        print('onVideoTrackSubscribed ${roomEvent.remoteParticipant.identity}');
      });
    });
    print('_onParticipantConnected ${roomEvent.remoteParticipant.identity}');
  }

  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent roomEvent) {
    setState(() {
      _participants.remove(roomEvent.remoteParticipant.identity);
    });
    print('_onParticipantDisconnected ${roomEvent.remoteParticipant.identity}');
  }

  @override
  Widget build(BuildContext context) {
    _arguments = ModalRoute.of(context).settings.arguments;
    _token = _arguments[1];
    _roomId = _arguments[2];
    return Scaffold(
      appBar: AppBar(title: Text('FCM-CALLER-APP')),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(children: _remoteVideos()),
            Positioned(
              left: 16, bottom: 16,
              width: 160, height: 160,
              child: isConnected ? _localVideoTrack.widget() : Container(),
            ),
            Positioned(
              right: 32, bottom: 32,
              child: UiUtils.widgetCircleButton(56, colorBcgCancel,
                  'assets/icons/ic_call_end.png', 1.5, Colors.white,
                      () => _cancelCall(context)),
            ),
          ],
        )
      ));
  }

  List<Widget> _remoteVideos () {
    List<Widget> list = [];
    _participants.values.forEach((item) {
      list.add(Expanded(child: item));
      });
    return list;
  }

  _cancelCall(BuildContext context) {
    wss.sendMessage('call:send cancel', _roomId);
  }

}
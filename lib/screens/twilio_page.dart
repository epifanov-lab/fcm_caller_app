import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:web_socket_channel/io.dart';

class EVENTS {
  static const String TOKEN = 'token';
  static const String HELLO = 'hello';
}

class COMMANDS {
  static const String AUTH = 'auth';
  static const String GET_TOKEN = 'get-token';
}

class TwilioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TwilioPageState();
}

class _TwilioPageState extends State<TwilioPage> {

  IOWebSocketChannel _socketChannel;
  bool _isConnected = false;
  bool _isConnectedToRoom = false;

  LocalAudioTrack _localAudioTrack;
  LocalVideoTrack _localVideoTrack;
  CameraCapturer _cameraCapturer;

  String _token;

  Map<String, Widget> _participants = Map<String, Widget>();

  Room _room;
  final Completer<Room> _completer = Completer<Room>();

  @override
  void initState() {
    // TODO: implement initState
    _createConnection();
    _initLocalTracks();
    super.initState();
  }

  void _initLocalTracks() {
    _localAudioTrack = LocalAudioTrack(true);
    _cameraCapturer = CameraCapturer(CameraSource.FRONT_CAMERA);
    _localVideoTrack = LocalVideoTrack(true, _cameraCapturer);
  }

  void _createConnection() async {
    _socketChannel = IOWebSocketChannel.connect('wss://twilio.rtt.space/wss/');
    _socketChannel.stream.listen(_onSocketData, onDone: _onDone);

    setState(() {
      _isConnected = true;
    });
  }

  void _onSocketData(receivedData) {
    print(receivedData);
    dynamic data = jsonDecode(receivedData);
    switch (data['event']) {
      case EVENTS.HELLO:
        Random rnd = Random();

        sendData(COMMANDS.AUTH, {
          "identity": rnd.nextInt(10000000).toString()
        });

        sendData(COMMANDS.GET_TOKEN, {});

        break;

      case EVENTS.TOKEN:
        this._token = data["data"]['token'];
        print('##token');
        print(this._token);

        this.connectToRoom().then((_) {
          print('connected to room');
          setState(() {
            _isConnectedToRoom = true;
          });
        });
        break;
    }
  }

  void sendData(String command, dynamic data) {
    dynamic json = {
      "command": command,
      "data": data
    };
    _socketChannel.sink.add(jsonEncode(json));
  }

  void _onDone() {
    print('socket closed');
    setState(() {
      _isConnected = false;
    });
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

  Future<Room> connectToRoom() async {
    ConnectOptions connectOptions = ConnectOptions(
      this._token,
      roomName: 'temp room',
      audioTracks: [_localAudioTrack],
      videoTracks: [_localVideoTrack]
    );
    _room = await TwilioProgrammableVideo.connect(connectOptions);
    _room.onConnected.listen(_onConnected);
    _room.onConnectFailure.listen(_onConnectFailure);

    _room.onParticipantConnected.listen(_onParticipantConnected);
    _room.onParticipantDisconnected.listen(_onParticipantDisconnected);

    return _completer.future;
  }

  List<Widget> _remoteVideos () {
    double top = 10;
    List<Widget> list = [];

    _participants.values.forEach((item) {
      list.add(Positioned(
        top: top,
        left: 10,
        width: 100,
        height: 100,
        child: item,
      ));

      top += 100;
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: _isConnectedToRoom ? _localVideoTrack.widget() : Container(),
            ),
            Stack(
              children: _remoteVideos(),
            )
          ],
        ),
      ),
    );
  }
}
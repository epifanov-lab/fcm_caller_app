import 'dart:async';

import 'package:fcmcallerapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class WssStatusBar extends StatefulWidget {
  final Subject<Map<String, dynamic>> _states;

  WssStatusBar(this._states);

  @override
  _WssStatusBarState createState() => _WssStatusBarState();
}

class _WssStatusBarState extends State<WssStatusBar> {

  bool _connected = false;
  bool _connectability = false;

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = widget._states.listen((map) {
      setState(() {
        _connected = map['connected'];
        _connectability = map['connectability'];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('WS ', style: appTheme.textTheme.caption),
          _getStatusCircle(8, _connected),
          SizedBox(width: 8),
          Text('Network ', style: appTheme.textTheme.caption),
          _getStatusCircle(8, _connectability),
        ],
      ),
    );
  }

  Widget _getStatusCircle(double size, bool state) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: state ? Colors.green : Colors.red
      ),
    );
  }
}
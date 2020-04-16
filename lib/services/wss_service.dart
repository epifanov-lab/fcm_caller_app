import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:fcmcallerapp/entities/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class WssService {

  User _user;

  final PublishSubject<AppLifecycleState> _lifecycleEvents;
  final Stream<ConnectivityResult> _connectivityEvents;
  Observable<bool> _connectability;

  Subject<IOWebSocketChannel> _channels;
  IOWebSocketChannel _currentChannel;

  StreamController<String> _dataController;
  Stream<List<dynamic>> data;

  Subject<Map<String, dynamic>> states;
  final Map<String, dynamic> _info = {
    'lifecycle': AppLifecycleState.detached,
    'connectivity': ConnectivityResult.none,
    'connectability': false,
    'connected': false,
    'channels_closed': 0
  };

  IOWebSocketChannel _createWsChannel()
        => IOWebSocketChannel.connect('wss://caller.rtt.space/wss/');

  WssService()
      : _lifecycleEvents = PublishSubject(),
        _connectivityEvents = Connectivity().onConnectivityChanged {
    _currentChannel = _createWsChannel();
    _channels = BehaviorSubject.seeded(_currentChannel);

    _dataController = StreamController.broadcast();
    data = _dataController.stream
        .map((event) => json.decode(event) as List<dynamic>);
        //.map((event) => {'event': event[0], 'data': event[1]});

    states = BehaviorSubject.seeded(_info);

    _connectability = Observable.combineLatest([
      _lifecycleEvents.debounceTime(new Duration(milliseconds: 500))
          .doOnEach((n) => _updateStateMapByKey('lifecycle', n.value))
          .map((state) => state == AppLifecycleState.resumed),
      Observable(_connectivityEvents).debounceTime(new Duration(milliseconds: 1000))
          .doOnEach((n) => _updateStateMapByKey('connectivity', n.value))
          .map((state) => (state == ConnectivityResult.mobile || state == ConnectivityResult.wifi))
    ], (states) => _concatBooleans(states));

       _connectability.listen((state) {
         _updateStateMapByKey('connectability', state);
         if (state) {
           if (_currentChannel.closeCode != null)
             _channels.add(_createWsChannel());
         } else {
           if (_currentChannel.closeCode == null)
             _currentChannel.sink.close();
         }
       });

       _channels.distinct().listen((channel) {
         _currentChannel = channel;
         _updateStateMapByKey('connected', true);
         _currentChannel.stream.listen(
                   (message) => _receiveMessage(message),
                    onDone: () {
                     _updateStateMap({
                       'connected': false,
                       'channels_closed': ++_info['channels_closed']
                     });
                    });
         if (_user != null) sendMessage('user add', {'name': _user.name, 'type': 'mobile'});
       });
  }

  void _receiveMessage(message) {
    print('@@@@@ WSS receive: <<< $message');
    _dataController.add(message);
  }

  Future sendMessage(String event, dynamic data) {
    if (_currentChannel.closeCode == null) {
      String message = json.encode([event, data]);
      _currentChannel.sink.add(message);
      print('@@@@@ WSS send: >>> $event: $data');
      return Future.value(null);
    } else return Future.error('Send message to ws failed. Channel is closed.');
  }

  void _updateStateMapByKey(String key, dynamic value) {
    print('@@@@@ WSS state change: $key = $value');
    _info[key] = value;
    states.add(_info);
  }

  void _updateStateMap(Map<String, dynamic> map) {
    print('@@@@@ WSS state change: $map');
    map.keys.forEach((key) {
      _info[key] = map[key];
    });
    states.add(_info);
  }

  void onLifecycleStateChanged(AppLifecycleState state) => _lifecycleEvents.add(state);

  void dispose() {
    _lifecycleEvents.close();
    _channels.close();
    states.close();
    _dataController.close();
  }

  static bool _concatBooleans(Iterable booleans) {
    bool result = true;
    booleans.forEach((b) => result &= b);
    return result;
  }

  setUser(User user) {
    sendMessage('user add', {'name': user.name, 'type': 'mobile'});
    _user = user;
  }

}
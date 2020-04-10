import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class WssService {

  final PublishSubject<AppLifecycleState> _lifecycleEvents;
  final Stream<ConnectivityResult> _connectivityEvents;
  Observable<bool> _connectability;

  Subject<IOWebSocketChannel> _channels;
  IOWebSocketChannel _currentChannel;

  StreamController<String> _data;

  Subject<Map<String, dynamic>> states;
  final Map<String, dynamic> _info = {
    'lifecycle': AppLifecycleState.detached,
    'connectivity': ConnectivityResult.none,
    'connectability': false,
    'channel.hashCode': null,
    'channels_closed': 0
  };

  WssService()
      : _lifecycleEvents = PublishSubject(),
        _connectivityEvents = Connectivity().onConnectivityChanged {
    _currentChannel = _createWsChannel();
    _channels = BehaviorSubject.seeded(_currentChannel);
    _data = StreamController.broadcast();
    states = BehaviorSubject.seeded(_info);

    _connectability = Observable.combineLatest([
      _lifecycleEvents.debounceTime(new Duration(milliseconds: 500))
          .doOnEach((n) => _updateStateMap('lifecycle', n.value))
          .map((state) => state == AppLifecycleState.resumed),
      Observable(_connectivityEvents).debounceTime(new Duration(milliseconds: 1000))
          .doOnEach((n) => _updateStateMap('connectivity', n.value))
          .map((state) => (state == ConnectivityResult.mobile || state == ConnectivityResult.wifi))
    ], (states) => _concatBooleans(states));

       _connectability.listen((state) {
         _updateStateMap('connectability', state);
         if (state) {
           if (_currentChannel.closeCode != null)
             _channels.add(_createWsChannel());
         } else {
           if (_currentChannel.closeCode == null)
             _currentChannel.sink.close();
         }
       });

       _channels.distinct().listen((channel) {
         _updateStateMap('channel.hashCode', channel.hashCode);
         _currentChannel = channel
           ..stream.listen((message) => _receiveMessage(message),
               onDone: () => _updateStateMap('channels_closed', ++_info['channels_closed']));
       });
  }

  Observable events() => Observable(_data.stream);

  void _receiveMessage(message) {
    print('ws <<< $message');
    _data.add(message);
  }

  Future sendMessage(String message) {
    print('ws >>> $message');
    if (_currentChannel.closeCode == null) {
      _currentChannel.sink.add(message);
      return Future.value(null);
    } else return Future.error('Send message to ws failed. channel is closed.');
  }

  IOWebSocketChannel _createWsChannel() => IOWebSocketChannel.connect('ws://echo.websocket.org');

  void _updateStateMap(String key, dynamic value) {
    print('wss: state changes: $key = $value');
    _info[key] = value;
    states.add(_info);
  }

  void onLifecycleStateChanged(AppLifecycleState state) => _lifecycleEvents.add(state);

  void dispose() {
    _lifecycleEvents.close();
    _channels.close();
    states.close();
    _data.close();
  }

  static bool _concatBooleans(Iterable booleans) {
    bool result = true;
    booleans.forEach((b) => result &= b);
    return result;
  }

}
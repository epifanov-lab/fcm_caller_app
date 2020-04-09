import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';

class WssService {

  final PublishSubject<AppLifecycleState> _lifecycleEvents;
  final Stream<ConnectivityResult> _connectivityEvents;

  Observable<bool> _connectability;
  IOWebSocketChannel _channel;

  final Subject<Map<String, dynamic>> changes = BehaviorSubject();
  final Map<String, dynamic> _info = {
    'lifecycle': AppLifecycleState.detached,
    'connectivity': ConnectivityResult.none,
    'connectability': false,
  };

  WssService()
      : _lifecycleEvents = PublishSubject(),
        _connectivityEvents = Connectivity().onConnectivityChanged {
    changes.add(_info);

    _connectability = Observable.combineLatest([
      _lifecycleEvents.debounceTime(new Duration(milliseconds: 500))
          .doOnEach((n) => updateStateMap('lifecycle', n.value))
          .map((state) => state == AppLifecycleState.resumed),
      Observable(_connectivityEvents).debounceTime(new Duration(milliseconds: 1000))
          .doOnEach((n) => updateStateMap('connectivity', n.value))
          .map((state) => (state == ConnectivityResult.mobile || state == ConnectivityResult.wifi))
    ], (states) => _concatBooleans(states));

       _connectability.listen((state) => _onConnectabilityChanges(state));
  }

  void _onConnectabilityChanges(bool state) {
    updateStateMap('connectability', state);
    //todo channel
  }

  void updateStateMap(String key, dynamic value) {
    print('wss: state changes: $key = $value');
    _info[key] = value;
    changes.add(_info);
  }

  void onLifecycleStateChanged(AppLifecycleState state) => _lifecycleEvents.add(state);
  void dispose() {
    _lifecycleEvents.close();
    changes.close();
  }

  static bool _concatBooleans(Iterable booleans) {
    bool result = true;
    booleans.forEach((b) => result &= b);
    return result;
  }

}
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Storage<T> {
  Future<void> put(String key, T value);
  Observable<T> changes(String key, bool forceFirst);
  void set(String key, T value);
  T get(String key);
}

class TemporaryStorage extends Storage {
  final Map<String, dynamic> _map;
  final PublishSubject<dynamic> _changes;

  TemporaryStorage()
      : _map = HashMap(),
        _changes = PublishSubject();

  @override
  Future<void> put(String key, dynamic value) async {
    set(key, value);
    return Future.value(null);
  }

  @override
  Observable<dynamic> changes(String key, bool forceFirst) {
    Observable<dynamic> obsIfFirst = forceFirst ?
      Observable.just(_map.putIfAbsent(key, () => null)) : Observable.empty();
    return Observable.merge([
      obsIfFirst, _changes.where((s) => key == s).map((key) => _map[key])
    ]);
  }

  @override
  void set(String key, value) {
    _map[key] = value;
    _changes.add(key);
  }

  @override
  get(String key) {
    return _map.containsKey(key) ? _map[key] : null;
  }

  /// Single shot (aka eventbus)
  emit(String key, value) {
    set(key, value);
    //_map.remove(key);
  }

}

class SharedPreferencesStorage extends Storage {
  final SharedPreferences _sp;
  final PublishSubject<String> _changes;

  static Future<SharedPreferencesStorage> getInstance() async {
    var sp = await SharedPreferences.getInstance();
    return SharedPreferencesStorage(sp);
  }

  SharedPreferencesStorage(this._sp)
    : _changes = PublishSubject();

  @override
  Future<void> put(String key, dynamic value) async {
    return _sp.setString(key, value).then((b) => _changes.add(key));
  }

  @override
  Observable<String> changes(String key, bool forceFirst) {
    Observable<String> obsIfFirst = forceFirst ?
      Observable.just(_putIfAbsent(key, () => null)) : Observable.empty();
    return Observable.merge([
      obsIfFirst, _changes.where((s) => key == s).map((key) => _sp.getString(key))
    ]);
  }

  _putIfAbsent(String key, String ifAbsent()) {
    if (_sp.containsKey(key))
      return _sp.get(key);
    else {
      var value = ifAbsent();
      _sp.setString(key, value);
      return value;
    }
  }

  @override
  void set(String key, value) {
    _sp.setString(key, value.toString());
    _changes.add(key);
  }

  @override
  String get(String key) {
    return _sp.getString(key);
  }

}
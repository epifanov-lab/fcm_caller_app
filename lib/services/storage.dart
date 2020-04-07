import 'dart:collection';


abstract class Storage<T> {
  void set(String key, T value);
  T get(String key);
}

class TemporaryStorage extends Storage {
  final Map<String, dynamic> _map;

  TemporaryStorage()
      : _map = HashMap();

  @override
  void set(String key, value) => _map[key] = value;

  @override
  get(String key) => _map.containsKey(key) ? _map[key] : null;

}
library prop_map;

import 'dart:collection';

class PropMap extends MapBase<String, Object> {
  final _src = {};

  Object operator [](String key) => _src[key];
  operator []=(String key, Object value) => _src[key] = value;
  Iterable<String> get keys => _src.keys;
  Object remove(String key) => _src.remove(key);
  void clear() => _src.clear();
}

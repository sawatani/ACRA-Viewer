library pager_component;

import 'dart:collection';
import 'package:angular/angular.dart';

@Component(
    selector: 'pager',
    templateUrl: 'pager.html')
class PagerComponent extends MapBase<String, Object> {
  /**
   * Map delegation
   */
  Map map = new HashMap<String, Object>();
  Object operator [](String key) => map[key];
  operator []=(String key, Object value) => map[key] = value;
  Object remove(String key) => map.remove(key);
  Iterable<String> get keys => map.keys;
  void clear() => map.clear();

  PagerComponent() {
    print("PagerComponent is instantiate.");
    map['curValue'] = 27;
    map['max'] = 100;
  }
}

library apps_list_component;

import 'package:acra_viewer/decorator/prop_map.dart';
import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';
import 'package:polymer/polymer.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'apps-list.html')
class AppsListComponent extends PropMap {
  final DynamoDB _db;

  AppsListComponent(this._db) {
    final List<Table> sample = [new Table('TritonNote', 'TritonNote')];
    this['allApps'] = toObservable(sample);
    this['pageLength'] = 26;
    this['pageLengthMax'] = 80;
  }

  Object operator [](String key) {
    print("Getting ${key}");
    if (key == "loaded") return _db.allApps != null;
    return super[key];
  }
}

class Table extends Observable {
  @observable String id;
  @observable String tableName;

  // mandatory field
  @observable int index;
  // mandatory field
  @observable bool selected;

  Table(this.id, this.tableName);
}

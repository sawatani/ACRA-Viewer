library apps_list_component;

import 'package:acra_viewer/decorator/prop_map.dart';
import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'apps-list.html')
class AppsListComponent extends PropMap {
  final DynamoDB _db;
  final Router _router;

  AppsListComponent(this._db, this._router) {
    this['pageLength'] = 26;
    this['pageLengthMax'] = 80;
  }

  Object operator [](String key) {
    if (key == "allApps") return _db.allApps;
    if (key == "loaded") return _db.allApps != null;
    if (key == "goApp") return goApp;
    return super[key];
  }

  void goApp(String appId) {
    _router.go("app.reports-list", {
      'appId': appId
    });
  }
}

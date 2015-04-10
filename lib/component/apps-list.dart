library apps_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'packages/acra_viewer/component/apps-list.html')
class AppsListComponent {
  final DynamoDB _db;
  final Router _router;
  
  int pageLength = 26;
  int pageLengthMax = 80;

  get allApps => _db.allApps;
  get loaded => _db.allApps != null;

  AppsListComponent(this._db, this._router);
  
  void onChange(int value) {
    print("pageLength is changed: ${value}");
    pageLength = value;
  }

  void goApp(String appId) {
    _router.go("app.reports-list", {'appId': appId});
  }
}

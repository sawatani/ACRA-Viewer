library apps_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';
import 'package:acra_viewer/util/main_frame.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'packages/acra_viewer/component/apps-list.html')
class AppsListComponent extends MainFrame {
  final DynamoDB _db;
  
  int pageLength = 26;
  int pageLengthMax = 80;

  get allApps => _db.allApps;
  get loaded => _db.allApps != null;

  AppsListComponent(this._db, Router router): super(router);
  
  void onChange(int value) {
    print("pageLength is changed: ${value}");
    pageLength = value;
  }

  void goApp(String appId) {
    router.go("app.reports-list", {'appId': appId});
  }
}

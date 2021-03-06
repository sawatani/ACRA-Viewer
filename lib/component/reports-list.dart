library reports_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';
import 'package:acra_viewer/decorator/history_back.dart';

@Component(
    selector: 'reports-list',
    templateUrl: 'reports-list.html')
class ReportsListComponent extends HistoryBack {
  final DynamoDB _db;
  App app;
  List<Report> get allReports => app.allReports;

  ReportsListComponent(this._db, RouteProvider routeProvider, Router router) {
    final String appId = routeProvider.parameters['appId'];
    print("Loading App(${appId})");
    try {
      app = _db.getApp(appId);
      app.id; // for test app is not null.
    } catch (ex) {
      router.go("view_default", {});
    }
  }
}

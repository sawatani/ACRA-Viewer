library report_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';
import 'package:acra_viewer/decorator/history_back.dart';

@Component(
    selector: 'report',
    templateUrl: 'packages/acra_viewer/component/report.html')
class ReportComponent extends HistoryBack {
  final DynamoDB _db;
  Report report;

  ReportComponent(this._db, RouteProvider routeProvider, Router router) {
    final String appId = routeProvider.parameters['appId'];
    final String reportId = routeProvider.parameters['reportId'];
    print("Loading Report(${reportId}) in App(${appId})");
    try {
      report = _db.getApp(appId).getReport(reportId);
    } catch (ex) {
      router.go("view_default", {});
    }
  }
}

library report_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'report',
    templateUrl: 'report.html')
class ReportComponent {
  final DynamoDB _db;
  Report report;

  ReportComponent(this._db, RouteProvider routeProvider) {
    final String appId = routeProvider.parameters['appId'];
    final String reportId = routeProvider.parameters['reportId'];
    print("Report(${reportId}) in App(${appId})");
    report = _db.getApp(appId).getReport(reportId);
  }
}

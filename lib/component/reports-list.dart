library reports_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'reports-list',
    templateUrl: 'reports-list.html')
class ReportsListComponent {
  final DynamoDB _db;
  App app;
  List<Report> get allReports => app.allReports;

  ReportsListComponent(this._db, RouteProvider routeProvider) {
    final String appId = routeProvider.parameters['appId'];
    app = _db.getApp(appId);
  }
}

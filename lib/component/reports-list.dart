library reports_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'reports-list',
    templateUrl: 'reports-list.html')
class ReportsListComponent {
  final DynamoDB _db;
  App app;
  List<Report> _cacheReports = null;
  List<Report> get allReports => _cacheReports;

  ReportsListComponent(this._db, RouteProvider routeProvider) {
    final String appId = routeProvider.parameters['appId'];
    app = _db.allApps.firstWhere((a) { return a.id == appId; });
    app.allReports().then((list) {
      _cacheReports = list;
    });
  }
}

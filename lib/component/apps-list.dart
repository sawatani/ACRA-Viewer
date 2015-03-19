library apps_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'apps-list.html')
class AppsListComponent {
  String _appId;
  DynamoDB db;

  String message = "Loading list ...";
  List<App> get allApps => db.allApps;

  AppsListComponent(this.db, RouteProvider routeProvider) {
    _appId = routeProvider.parameters['appId'];
  }
}

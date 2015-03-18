library apps_list_component;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'apps-list.html')
class AppsListComponent {
  String _appId;
  DynamoDB db;

  String message = "Loading list ...";
  List<App> allApps;

  AppsListComponent(this.db, RouteProvider routeProvider) {
    _appId = routeProvider.parameters['appId'];
    obtainApps();
    window.addEventListener("AWS.RENEW_CREDENTIAL", (Event event) {
      obtainApps();
    });
  }

  void obtainApps() {
    print("Start to obtain applications list");
    db.allApps.then((List<App> list) {
      allApps = list;
    }).catchError((error) {
      print("Failed to get applications list: ${error}");
    });
  }
}

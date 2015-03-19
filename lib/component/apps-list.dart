library apps_list_component;

import 'package:angular/angular.dart';
import 'package:acra_viewer/service/dynamodb.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'apps-list.html')
class AppsListComponent {
  String _appId;
  final DynamoDB _db;

  String message = "Loading list ...";
  List<App> get allApps => _db.allApps;

  AppsListComponent(this._db);
}

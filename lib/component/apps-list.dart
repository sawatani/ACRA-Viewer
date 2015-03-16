library apps_list_component;

import 'package:angular/angular.dart';

@Component(
    selector: 'apps-list',
    templateUrl: 'apps-list.html')
class AppsListComponent {
  String _appId;

  bool loaded = false;
  String message = "Loading list ...";

  AppsListComponent(RouteProvider routeProvider) {
    _appId = routeProvider.parameters['appId'];
  }
}

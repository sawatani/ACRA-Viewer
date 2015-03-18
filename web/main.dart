library acra_viewer;

import 'package:acra_viewer/router.dart';
import 'package:acra_viewer/component/apps-list.dart';
import 'package:acra_viewer/service/dynamodb.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';

class ACRAViewerModule extends Module {
  ACRAViewerModule() {
    bind(AppsListComponent);
    bind(DynamoDB);
    bind(RouteInitializerFn, toValue: recipeBookRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
  }
}

void main() {
  Logger.root..level = Level.FINEST
             ..onRecord.listen((LogRecord r) { print(r.message); });

  applicationFactory()
      .addModule(new ACRAViewerModule())
      .run();
}

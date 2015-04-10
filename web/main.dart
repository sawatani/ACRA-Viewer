library acra_viewer;

import 'package:acra_viewer/router.dart';
import 'package:acra_viewer/component/apps-list.dart';
import 'package:acra_viewer/component/reports-list.dart';
import 'package:acra_viewer/component/report.dart';
import 'package:acra_viewer/component/credential.dart';
import 'package:acra_viewer/service/dynamodb.dart';
import 'package:acra_viewer/service/credential.dart';
import 'package:acra_viewer/service/resource_url_resolver_cordova.dart';
import 'package:acra_viewer/util/cordova.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:logging/logging.dart';
import 'package:polymer/polymer.dart';

class ACRAViewerModule extends Module {
  ACRAViewerModule() {
    bind(AppsListComponent);
    bind(ReportsListComponent);
    bind(ReportComponent);
    bind(CredentialComponent);
    bind(Credential);
    bind(DynamoDB);
    bind(RouteInitializerFn, toValue: recipeBookRouteInitializer);
    bind(NgRoutingUsePushState, toValue: new NgRoutingUsePushState.value(false));
    bind(ResourceResolverConfig, toValue: new ResourceResolverConfig.resolveRelativeUrls(false));
    bind(ResourceUrlResolver, toImplementation: ResourceUrlResolverCordova);
  }
}

void main() {
  Logger.root..level = Level.FINEST
             ..onRecord.listen((LogRecord r) { print(r.message); });

  Cordova.initialize();
  Cordova.onReady((event) {
    initPolymer().run(() {
      applicationFactory()
        .addModule(new ACRAViewerModule())
        .run();
    });
  });
}

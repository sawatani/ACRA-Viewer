library acra_viewer_routing;

import 'package:angular/angular.dart';

void recipeBookRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
    'apps': ngRoute(
        path: '/apps',
        view: 'view/apps.html'),
    'app': ngRoute(
        path: '/app/:appName',
        mount: {
          'reports': ngRoute(
              path: '/reports',
              view: 'view/reports.html'),
          'report': ngRoute(
              path: '/report/:index',
              view: 'view/report.html')
        }),
    'view_default': ngRoute(
        defaultRoute: true,
        enter: (RouteEnterEvent e) =>
            router.go('apps', {},
                replace: true))
  });
}

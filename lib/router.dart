library acra_viewer_routing;

import 'package:angular/angular.dart';

void recipeBookRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
    'apps-list': ngRoute(
        path: '/apps',
        viewHtml: '<apps-list/>'),
    'app': ngRoute(
        path: '/app/:appId',
        mount: {
          'reports-list': ngRoute(
              path: '/reports',
              viewHtml: '<reports-list/>'),
          'report': ngRoute(
              path: '/report/:reportId',
              view: '<report/>')
        }),
    'view_default': ngRoute(
        defaultRoute: true,
        enter: (RouteEnterEvent e) =>
            router.go('apps-list', {},
                replace: true))
  });
}
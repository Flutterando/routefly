import 'package:routefly/routefly.dart';

import 'app/app_layout.dart' as a5;
import 'app/tab1/page2/page2_page.dart' as a1;
import 'app/tab1/tab1_page.dart' as a0;
import 'app/tab2/page2/page2_page.dart' as a2;
import 'app/tab2/tab2_page.dart' as a3;
import 'app/tab3/tab3_page.dart' as a4;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/tab1',
    parent: '/',
    uri: Uri.parse('/tab1'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a0.Tab1Page(),
    ),
  ),
  RouteEntity(
    key: '/tab1/page2',
    parent: '/',
    uri: Uri.parse('/tab1/page2'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a1.Page2Page(),
    ),
  ),
  RouteEntity(
    key: '/tab2/page2',
    parent: '/',
    uri: Uri.parse('/tab2/page2'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a2.Page2Page(),
    ),
  ),
  RouteEntity(
    key: '/tab2',
    parent: '/',
    uri: Uri.parse('/tab2'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a3.Tab1Page(),
    ),
  ),
  RouteEntity(
    key: '/tab3',
    parent: '/',
    uri: Uri.parse('/tab3'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a4.Tab1Page(),
    ),
  ),
  RouteEntity(
    key: '/',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a5.AppPage(),
    ),
  ),
];

const routePaths = (
  path: '/',
  tab1: (
    path: '/tab1',
    page2: '/tab1/page2',
  ),
  tab2: (
    path: '/tab2',
    page2: '/tab2/page2',
  ),
  tab3: '/tab3',
);

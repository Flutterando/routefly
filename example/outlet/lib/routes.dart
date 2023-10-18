import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'app/app_page.dart' as a0;
import 'app/dashboard/dashboard_layout.dart' as a1;
import 'app/dashboard/option1/option1_page.dart' as a2;
import 'app/dashboard/option2/option2_page.dart' as a3;
import 'app/dashboard/option3/option3_page.dart' as a4;

final routes = <RouteEntity>[
  RouteEntity(
    key: '/',
    parent: '',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a0.AppPage(),
    ),
  ),
  RouteEntity(
    key: '/dashboard',
    parent: '',
    uri: Uri.parse('/dashboard'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a1.DashboardLayout(),
    ),
  ),
  RouteEntity(
    key: '/dashboard/option1',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option1'),
    routeBuilder: a2.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option2',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option2'),
    routeBuilder: a3.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option3',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option3'),
    routeBuilder: a4.routeBuilder,
  ),
];

// Route Path Object
const routePaths = (
  initialRoute: '/',
  dashboard: (
    initial: '/dashboard',
    option1: '/dashboard/option1',
    option2: '/dashboard/option2',
    option3: '/dashboard/option3',
  ),
  users: (
    inital: '/users',
    $id: (
      init: '/users/[id]',
      edit: '/users/[id]/edit',
    ),
  ),
);

void main(List<String> args) {
  routePaths.initialRoute;
  routePaths.users.$id.edit;
  routePaths.dashboard.initial;
  routePaths.dashboard.option1;

  routePaths.users.$id.init.query({'id': '1'});
}

extension StringRoutePathExtends on String {
  String query(Map<String, String> queries) {
    var newString = this;
    for (var key in queries.keys) {
      final value = queries[key]!;
      newString = newString.replaceAll('[$key]', value);
    }

    return newString;
  }
}

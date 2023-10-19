import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import 'app/app_page.dart' as a4;
import 'app/dashboard/dashboard_layout.dart' as a2;
import 'app/dashboard/option1/option1_page.dart' as a0;
import 'app/dashboard/option2/option2_page.dart' as a1;
import 'app/dashboard/option3/option3_page.dart' as a3;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/',
    parent: '',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a4.AppPage(),
    ),
  ),
  RouteEntity(
    key: '/dashboard',
    parent: '',
    uri: Uri.parse('/dashboard'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a2.DashboardLayout(),
    ),
  ),
  RouteEntity(
    key: '/dashboard/option1',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option1'),
    routeBuilder: a0.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option2',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option2'),
    routeBuilder: a1.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option3',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option3'),
    routeBuilder: a3.routeBuilder,
  ),
];

const routePaths = (
  path: '/',
  dashboard: (
    path: '/dashboard',
    option3: '/dashboard/option3',
    option2: '/dashboard/option2',
    option1: '/dashboard/option1',
  ),
);
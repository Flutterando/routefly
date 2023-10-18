import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import 'app/app_page.dart' as a0;
import 'app/guarded/guarded_page.dart' as a1;
import 'app/users/users_page.dart' as a2;
import 'app/users/[id]/user_page.dart' as a3;

List<RouteEntity> get routes => [
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
    key: '/guarded',
    parent: '',
    uri: Uri.parse('/guarded'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a1.GuardedPage(),
    ),
  ),
  RouteEntity(
    key: '/users',
    parent: '',
    uri: Uri.parse('/users'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a2.UsersPage(),
    ),
  ),
  RouteEntity(
    key: '/users/[id]',
    parent: '',
    uri: Uri.parse('/users/[id]'),
    routeBuilder: a3.routeBuilder,
  ),
];
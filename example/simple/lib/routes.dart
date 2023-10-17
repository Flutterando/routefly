import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import 'app/app_page.dart';
import 'app/users/users_page.dart';
import 'app/users/[id]/user_page.dart';

final routes = <RouteEntity>[
  RouteEntity(
    key: '/',
    parent: '',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const AppPage(),
    ),
  ),
  RouteEntity(
    key: '/users',
    parent: '',
    uri: Uri.parse('/users'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const UsersPage(),
    ),
  ),
  RouteEntity(
    key: '/users/[id]',
    parent: '',
    uri: Uri.parse('/users/[id]'),
    routeBuilder: routeBuilder,
  ),
];
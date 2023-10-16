import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import 'app/users/[id]/user_page.dart';
import 'app/users/users_page.dart';
import 'app/app_page.dart';

final routes = <RouteEntity>[
  RouteEntity(
    uri: Uri.parse('/users/[id]'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const UserPage(),
    ),
  ),RouteEntity(
    uri: Uri.parse('/users'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const UsersPage(),
    ),
  ),RouteEntity(
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const AppPage(),
    ),
  ),
];
import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import 'app/app_page.dart' as a0;

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
];
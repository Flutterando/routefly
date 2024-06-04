import 'dart:async';

import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import '../routes.g.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes,
        middlewares: [_guardRoute],
        routeBuilder: (context, settings, child) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => child,
          );
        },
      ),
    );
  }
}

FutureOr<RouteInformation> _guardRoute(RouteInformation routeInformation) {
  if (routeInformation.uri.path == '/guarded') {
    return routeInformation.redirect(Uri.parse('/'));
  }

  return routeInformation;
}

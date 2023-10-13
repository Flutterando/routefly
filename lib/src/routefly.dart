import 'package:flutter/material.dart';
import 'package:routefly/src/entities/route.dart';
import 'package:routefly/src/router_delegate.dart';

import 'route_information_parser.dart';

class Routefly {
  static PlatformRouteInformationProvider? _provider;

  static void navigate(String path) {
    if (_provider == null) {
      return;
    }

    _provider!.didPushRouteInformation(
      RouteInformation(uri: Uri.parse(path), state: RouteType.navigate),
    );
  }

  static void push(String path) {
    if (_provider == null) {
      return;
    }

    _provider!.didPushRouteInformation(
      RouteInformation(uri: Uri.parse(path), state: RouteType.push),
    );
  }

  static void pop() {
    if (_provider == null) {
      return;
    }

    _provider!.didPopRoute();
  }

  static RouterConfig<Object>? routerConfig({
    required String initialPath,
    required List<RouteEntity> routes,
  }) {
    _provider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(uri: Uri.parse(initialPath), state: RouteType.navigate),
    );

    return RouterConfig(
      routerDelegate: RouteflyRouterDelegate(),
      routeInformationParser: RouteflyInformationParser(routes),
      routeInformationProvider: _provider!,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

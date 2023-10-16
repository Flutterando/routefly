import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';
import 'package:routefly/src/navigation/router_delegate.dart';

import 'navigation/route_information_parser.dart';

class Routefly {
  static PlatformRouteInformationProvider? _provider;
  static RouteflyRouterDelegate? _delegate;

  static Listenable get listenable {
    _verifyInitialization();
    return _delegate!;
  }

  static void navigate(String path, {dynamic arguments}) {
    _verifyInitialization();

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: Uri.parse(path),
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.navigate,
        ),
      ),
    );
  }

  static void replace(String path, {dynamic arguments}) {
    _verifyInitialization();

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: Uri.parse(path),
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.replace,
        ),
      ),
    );
  }

  static void push(String path, {dynamic arguments}) {
    _verifyInitialization();

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: Uri.parse(path),
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.push,
        ),
      ),
    );
  }

  static void pop() {
    _verifyInitialization();

    _delegate!.pop();
  }

  static RouteEntity get _route {
    _verifyInitialization();
    return _delegate!.configurations.last;
  }

  static Uri get uri => _provider!.value.uri;
  static RouteflyQuery get query => RouteflyQuery(
        uri.queryParameters,
        _route.params,
        _route.arguments,
      );

  static void _verifyInitialization() {
    if (_provider == null || _delegate == null) {
      throw RouteflyException('Routefly must be declare in MaterialApp or CupertinoApp.\nPlease, check the docs for more information.');
    }
  }

  static RouterConfig<Object>? routerConfig({
    String initialPath = '',
    required List<RouteEntity> routes,
    String notFoundPath = '404',
    List<NavigatorObserver> observers = const [],
  }) {
    _provider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: Uri.parse(initialPath),
        state: RouteRequest(arguments: null, type: RouteType.navigate),
      ),
    );

    _delegate = RouteflyRouterDelegate(observers);

    return RouterConfig(
      routerDelegate: _delegate!,
      routeInformationParser: RouteflyInformationParser(RouteAggregate(
        routes: routes,
        notFoundPath: notFoundPath,
      )),
      routeInformationProvider: _provider!,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

class RouteflyQuery {
  final Map<String, dynamic> _data;
  final Map<String, String> params;
  final dynamic arguments;

  RouteflyQuery(this.params, this._data, this.arguments);

  dynamic operator [](String key) {
    return _data[key];
  }
}

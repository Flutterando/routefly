import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';
import 'package:routefly/src/navigation/routefly_page.dart';
import 'package:routefly/src/navigation/router_delegate.dart';

import 'navigation/custom_navigator.dart';
import 'navigation/inherited_routefly.dart';
import 'navigation/route_information_parser.dart';

part 'navigation/outlet/outlet_delegate.dart';
part 'navigation/outlet/router_outlet.dart';

abstract class Routefly {
  static PlatformRouteInformationProvider? _provider;
  static RouteflyRouterDelegate? _delegate;

  static Listenable get listenable {
    _verifyInitialization();
    return _delegate!;
  }

  static RouteflyState of(BuildContext context) {
    final page = ModalRoute.of(context)!.settings as RouteflyPage;
    context.dependOnInheritedWidgetOfExactType<InheritedRoutefly>();
    return RouteflyState(page);
  }

  /// Replaces the entire route stack with the requested one
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

  /// Replaces the last route in the stack with the requested one
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

  /// Add route to stack
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

  /// Remove route to stack
  static void pop() {
    _verifyInitialization();

    _delegate!.pop();
  }

  static RouteEntity get _route {
    _verifyInitialization();
    return _delegate!.configurations.last;
  }

  static Uri get uri => _delegate!.currentConfiguration!.uri;
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

  /// Navigator 2.0 configurations
  static RouterConfig<Object>? routerConfig({
    String initialPath = '',
    required List<RouteEntity> routes,
    String notFoundPath = '404',
    List<NavigatorObserver> observers = const [],
    List<RouteMiddleware> middlewares = const [],
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
      routeInformationParser: RouteflyInformationParser(
        RouteAggregate(
          routes: routes,
          notFoundPath: notFoundPath,
        ),
        middlewares,
      ),
      routeInformationProvider: _provider!,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

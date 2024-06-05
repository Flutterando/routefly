// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'custom_navigator.dart';
import 'inherited_routefly.dart';
import 'routefly_page.dart';

/// `RouteflyRouterDelegate` is a custom [RouterDelegate] tailored for the
/// 'Routefly' framework. It manages a list of route configurations and
/// interacts with Flutter's navigation system to build and manage the
/// navigation stack based on these configurations.
class RouteflyRouterDelegate extends RouterDelegate<RouteEntity> //
    with
        ChangeNotifier {
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// A list of observers that listen to navigation events.
  final List<NavigatorObserver> observers;

  /// A list of [RouteEntity] configurations currently being managed
  /// by the delegate.
  List<RouteEntity> configurations = <RouteEntity>[];

  /// Creates an instance of [RouteflyRouterDelegate].
  ///
  /// [observers]: A list of navigation event observers.
  RouteflyRouterDelegate(this.observers);

  @override
  RouteEntity? currentConfiguration;

  @override

  /// Builds the widget representation for the current navigation stack.
  ///
  /// If no configurations are available, it returns an empty [Material] widget.
  Widget build(BuildContext context) {
    if (configurations.isEmpty) {
      return const Material();
    }

    final pages = configurations
        .where((e) => e.parent.isEmpty) //
        .map((e) => e.page)
        .toList();

    return InheritedRoutefly(
      child: CustomNavigator(
        key: _navigatorKey,
        observers: observers,
        pages: pages,
        onPopPage: onPopPage,
      ),
    );
  }

  /// Handles the page popping action.
  ///
  /// It removes the popped page's configuration from the list and notifies
  /// any listeners about the change.
  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result) || route.isFirst) {
      return false;
    }

    final page = route.settings as RouteflyPage;
    page.entity.popCallback?.call(result);
    configurations.removeWhere((e) => e.page.key == page.key);
    notifyListeners();

    return true;
  }

  @override

  /// Handles the route popping action.
  Future<bool> popRoute() {
    return _navigatorKey.currentState!.maybePop();
  }

  @override

  /// Updates the current route configurations based on a new [RouteEntity].
  Future<void> setNewRoutePath(RouteEntity configuration) async {
    final routes = _resolveRoute(configuration);

    if (configuration.type == RouteType.navigate) {
      configurations = _across(routes);
      currentConfiguration = configuration;
    } else if (configuration.type == RouteType.pushNavigate) {
      final acrossRoutes = _across(routes);
      configurations.addAll(
        acrossRoutes.where((element) {
          return !configurations.contains(element);
        }),
      );
      currentConfiguration = configuration;
    } else if (configuration.type == RouteType.replace) {
      configurations.removeLast();
    } else {
      configurations = [...configurations, _prepareRoute(configuration)];
    }

    notifyListeners();
  }

  /// Gets the new list of routes while retaining existing ones.
  List<RouteEntity> _across(List<RouteEntity> routes) {
    final newRoutes = <RouteEntity>[];

    for (final route in routes) {
      final index = configurations.indexOf(route);
      if (index == -1) {
        newRoutes.add(route);
      } else {
        newRoutes.add(configurations[index]);
      }
    }

    return newRoutes;
  }

  /// Resolves the complete list of [RouteEntity] from a given configuration.
  List<RouteEntity> _resolveRoute(RouteEntity configuration) {
    final routes = <RouteEntity>[];

    RouteEntity? route = configuration;

    while (route != null) {
      routes.insert(0, _prepareRoute(route));
      route = route.parentEntity;
    }

    return routes;
  }

  /// Prepares a [RouteEntity] by associating it with a [RouteflyPage] and
  /// taking into account any existing instances of the same route in the
  /// configuration list.
  RouteEntity _prepareRoute(RouteEntity configuration) {
    final count = configurations.where((r) => r == configuration).length;
    return configuration.copyWith(
      page: RouteflyPage.fromEntity(configuration, count),
    );
  }
}

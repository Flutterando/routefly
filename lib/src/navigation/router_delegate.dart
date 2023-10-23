// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'custom_navigator.dart';
import 'inherited_routefly.dart';
import 'routefly_page.dart';

class RouteflyRouterDelegate extends RouterDelegate<RouteEntity> //
    with
        ChangeNotifier {
  final List<NavigatorObserver> observers;

  List<RouteEntity> configurations = <RouteEntity>[];

  RouteflyRouterDelegate(this.observers);

  @override
  RouteEntity? currentConfiguration;

  @override
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
        observers: observers,
        pages: pages,
        onPopPage: onPopPage,
      ),
    );
  }

  bool onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result) || route.isFirst) {
      return false;
    }

    final page = route.settings as RouteflyPage;
    configurations.removeWhere((e) => e.page.key == page.key);
    notifyListeners();

    return true;
  }

  @override
  Future<bool> popRoute() async {
    return configurations.isNotEmpty;
  }

  @override
  Future<void> setNewRoutePath(RouteEntity configuration) async {
    final routes = _resolveRoute(configuration);

    if (configuration.type == RouteType.navigate) {
      configurations = _across(routes);
      currentConfiguration = configuration;
    } else if (configuration.type == RouteType.pushNavigate) {
      final acrossRoutes = _across(routes);
      configurations.addAll(
        acrossRoutes.where((element) {
          final index = configurations.indexOf(element);
          return index == -1;
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

  List<RouteEntity> _resolveRoute(RouteEntity configuration) {
    final routes = <RouteEntity>[];

    RouteEntity? route = configuration;

    while (route != null) {
      routes.insert(0, _prepareRoute(route));
      route = route.parentEntity;
    }

    return routes;
  }

  RouteEntity _prepareRoute(RouteEntity configuration) {
    final count = configurations.where((r) => r == configuration).length;
    return configuration.copyWith(
      page: RouteflyPage.fromEntity(configuration, count),
    );
  }
}

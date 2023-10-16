import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class RouteflyRouterDelegate extends RouterDelegate<RouteEntity> with ChangeNotifier {
  final List<NavigatorObserver> _observers;

  var configurations = <RouteEntity>[];

  RouteflyRouterDelegate(this._observers);

  @override
  Widget build(BuildContext context) {
    if (configurations.isEmpty) {
      return const Material();
    }

    return _CustomNavigator(
      observers: _observers,
      pages: configurations.map((e) => e.page).toList(),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result) || route.isFirst) {
      return false;
    }

    final page = route.settings as _RouteflyPage;
    configurations.removeWhere((e) => e.page.key == page.key);
    notifyListeners();

    return true;
  }

  @override
  Future<bool> popRoute() async {
    return false;
  }

  void pop() {
    if (configurations.length > 1) {
      configurations.removeLast();
      notifyListeners();
    }
  }

  @override
  Future<void> setNewRoutePath(RouteEntity configuration) async {
    final route = _prepareRoute(configuration);

    if (route.type == RouteType.navigate) {
      configurations = [route];
    } else if (route.type == RouteType.replace) {
      configurations.removeLast();
      configurations = [...configurations, route];
    } else {
      configurations = [...configurations, route];
    }

    notifyListeners();
  }

  RouteEntity _prepareRoute(RouteEntity configuration) {
    final count = configurations.where((r) => r == configuration).length;
    return configuration.copyWith(page: _RouteflyPage.fromEntity(configuration, count));
  }
}

class _RouteflyPage extends Page {
  final RouteEntity entity;

  const _RouteflyPage({
    required this.entity,
    required super.name,
    required super.arguments,
    required super.key,
  });

  factory _RouteflyPage.fromEntity(RouteEntity entity, int count) {
    final key = ValueKey('${entity.uri.path}@$count');

    return _RouteflyPage(
      entity: entity,
      name: entity.uri.path,
      arguments: entity.arguments,
      key: key,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    final route = entity.routeBuilder(context, this);
    return route;
  }
}

class _CustomNavigator extends Navigator {
  const _CustomNavigator({
    super.pages,
    super.onPopPage,
    super.observers,
  });

  @override
  NavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends NavigatorState {
  @override
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) async {
    Routefly.push(routeName, arguments: arguments);
    return null;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName, {TO? result, Object? arguments}) async {
    Routefly.replace(routeName, arguments: arguments);
    return null;
  }
}

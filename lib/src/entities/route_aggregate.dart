// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:routefly/src/entities/route_entity.dart';

class RouteAggregate {
  late final List<RouteEntity> routes;
  final String notFoundPath;

  RouteAggregate({
    required List<RouteEntity> routes,
    required this.notFoundPath,
  }) {
    this.routes = _orderRoutes(routes);
  }

  List<RouteEntity> _orderRoutes(List<RouteEntity> routes) {
    final copy = routes.toList();
    final normalRoutes = copy
        .where(
          (e) => !_containsParams(e.uri.pathSegments),
        )
        .toList();
    final paramsRoutes = copy
        .where(
          (e) => _containsParams(e.uri.pathSegments),
        )
        .toList();

    normalRoutes.sort(_compare);
    paramsRoutes.sort(_compare);

    return [...normalRoutes, ...paramsRoutes];
  }

  bool _containsParams(List<String> segments) {
    return segments.any((e) => e.contains(RegExp(r'\[.+\]')));
  }

  int _compare(RouteEntity a, RouteEntity b) {
    return a.uri.pathSegments.length.compareTo(b.uri.pathSegments.length);
  }

  RouteEntity findRoute(String path) {
    var findedRoute = _findRoute(path);

    if (findedRoute != null && findedRoute.parent.isNotEmpty) {
      final parent = _findRoute(findedRoute.parent);
      if (parent != null) {
        return findedRoute.copyWith(parentEntity: parent);
      }
    } else if (findedRoute != null) {
      return findedRoute;
    }

    // not found page
    findedRoute = _findRoute(notFoundPath);

    if (findedRoute != null) {
      return findedRoute;
    }

    return RouteEntity(
      uri: Uri.parse('/404'),
      routeBuilder: (context, settings) {
        return PageRouteBuilder(
          pageBuilder: (context, a1, a2) {
            return Material(
              color: Colors.black,
              child: Center(child: Text('Not found page: \$($path)')),
            );
          },
        );
      },
      key: '/404',
    );
  }

  RouteEntity? _findRoute(String path) {
    for (final route in routes) {
      final candidate = route.addNewInfo(path);
      if (candidate != null) {
        return candidate;
      }
    }
    return null;
  }
}

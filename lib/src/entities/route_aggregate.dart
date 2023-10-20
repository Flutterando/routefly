// ignore_for_file: public_member_api_docs

import 'package:routefly/src/entities/route_entity.dart';
import 'package:routefly/src/exceptions/exceptions.dart';

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

  RouteEntity findRoute(Uri uri) {
    final findedRoute = _findRoute(uri);

    if (findedRoute != null && findedRoute.parent.isNotEmpty) {
      final parent = _findRoute(Uri.parse(findedRoute.parent));
      if (parent != null) {
        return findedRoute.copyWith(parentEntity: parent);
      }
    } else if (findedRoute != null) {
      return findedRoute;
    }

    throw RouteflyException('Route ($uri) not found');
  }

  RouteEntity? _findRoute(Uri uri) {
    for (final route in routes) {
      final candidate = route.addNewInfo(uri);
      if (candidate != null) {
        return candidate;
      }
    }
    return null;
  }
}

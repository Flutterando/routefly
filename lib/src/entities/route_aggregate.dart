import 'package:flutter/material.dart';
import 'package:routefly/src/entities/route_entity.dart';
import 'package:routefly/src/widgets/routefly_logo.dart';

/// Represents an aggregate of routes and provides functionality to order,
/// find, and handle missing routes.
class RouteAggregate {
  /// A list of routes.
  late final List<RouteEntity> routes;

  /// Path that will be used when a route is not found.
  final String notFoundPath;

  /// Creates a [RouteAggregate].
  ///
  /// - [routes]: A list of routes.
  /// - [notFoundPath]: A path that will be used when a route is not found.
  RouteAggregate({
    required List<RouteEntity> routes,
    required this.notFoundPath,
  }) {
    this.routes = _orderRoutes(routes);
  }

  /// Orders the provided [routes] such that routes without parameters come
  /// before routes with parameters. Also, sorts them based on
  /// the length of their path segments.
  ///
  /// - [routes]: The list of routes to be ordered.
  ///
  /// Returns an ordered list of routes.
  List<RouteEntity> _orderRoutes(List<RouteEntity> routes) {
    final copy = routes.toList();

    // Segregate routes without parameters.
    final normalRoutes = copy.where((e) {
      return !_containsParams(e.uri.pathSegments);
    }).toList();

    // Segregate routes with parameters.
    final paramsRoutes = copy.where((e) {
      return _containsParams(e.uri.pathSegments);
    }).toList();

    // Sort both lists.
    normalRoutes.sort(_compare);
    paramsRoutes.sort(_compare);

    return [...normalRoutes, ...paramsRoutes];
  }

  /// Checks if the provided [segments] contain parameters (denoted by '[]').
  ///
  /// Returns `true` if [segments] contain parameters, otherwise `false`.
  bool _containsParams(List<String> segments) {
    return segments.any((e) => e.contains(RegExp(r'\[.+\]')));
  }

  /// Compares two [RouteEntity] objects based on the
  /// length of their path segments.
  int _compare(RouteEntity a, RouteEntity b) {
    return a.uri.pathSegments.length.compareTo(b.uri.pathSegments.length);
  }

  /// Finds and returns the corresponding [RouteEntity] for the provided [uri].
  /// If a parent route exists, it also associates the parent
  /// route to the found route.
  /// If no route is found, a default "not found" route is returned.
  RouteEntity findRoute(Uri uri) {
    var findedRoute = _findRoute(uri);

    if (findedRoute != null && findedRoute.parent.isNotEmpty) {
      final parent = _findRoute(Uri.parse(findedRoute.parent));
      if (parent != null) {
        return findedRoute.copyWith(parentEntity: parent);
      }
    } else if (findedRoute != null) {
      return findedRoute;
    }

    findedRoute = _findRoute(Uri.parse(notFoundPath));

    if (findedRoute != null) {
      return findedRoute;
    }

    return RouteEntity(
      uri: Uri.parse('/404'),
      routeBuilder: (context, settings) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, a1, a2) {
            return _NotFoundDefaultPage(path: uri.toString());
          },
        );
      },
      key: '/404',
    );
  }

  /// Finds and returns the [RouteEntity] that matches the given
  /// [uri] or `null` if not found.
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

/// A default page displayed when a route is not found.
class _NotFoundDefaultPage extends StatelessWidget {
  /// Path of the route that was not found.
  final String path;

  /// Creates a [_NotFoundDefaultPage].
  ///
  /// - [path]: The path of the route that was not found.
  const _NotFoundDefaultPage({required this.path});

  @override
  Widget build(BuildContext context) {
    const paddingSize = 80.0;
    return Material(
      child: Column(
        children: [
          const SizedBox(height: paddingSize),
          const RouteflyLogo(),
          const Spacer(),
          Center(child: SelectableText('Not found page: ($path)')),
          const Spacer(),
          const SizedBox(height: paddingSize),
        ],
      ),
    );
  }
}

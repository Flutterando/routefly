// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';
import 'package:routefly/src/navigation/url_service/url_service.dart';

/// A typedef for a route middleware function that can be used to process and
/// possibly transform the given [RouteInformation] before it's finally used.
typedef RouteMiddleware = FutureOr<RouteInformation> Function(
  RouteInformation routeInformation,
);

/// `RouteflyInformationParser` is a custom [RouteInformationParser] tailored
/// to work with the 'Routefly' framework, providing the ability to process
/// [RouteInformation] through middlewares and convert it to a [RouteEntity].
///
/// This parser works closely with the given [RouteAggregate] to determine
/// the right [RouteEntity] based on the provided information.
class RouteflyInformationParser extends RouteInformationParser<RouteEntity> {
  final RouteAggregate aggregate;

  /// A list of middlewares to process the incoming [RouteInformation].
  final List<RouteMiddleware> middlewares;

  bool _firstAccess = true;

  /// Creates an instance of [RouteflyInformationParser].
  ///
  /// [aggregate] is used to determine the right [RouteEntity] based on
  /// the provided [RouteInformation].
  /// [middlewares] is a list of functions that can be used to process
  /// the incoming [RouteInformation] before it's converted to [RouteEntity].
  RouteflyInformationParser(this.aggregate, this.middlewares);

  @override
  Future<RouteEntity> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final urlService = UrlService.create();

    // Adjust the route information based on the platform-specific path
    // when accessing for the first time.
    if (_firstAccess) {
      var uri = routeInformation.uri;
      final nativePath = urlService.getPath();
      uri = nativePath != null ? Uri.parse(nativePath) : uri;
      _firstAccess = false;
      routeInformation = RouteInformation(
        uri: uri,
        state: routeInformation.state,
      );
    }

    // Process the route information through the provided middlewares.
    for (final middleware in middlewares) {
      routeInformation = await middleware(routeInformation);
    }

    final request = routeInformation.state as RouteRequest?;

    final candidate = aggregate.findRoute(routeInformation.uri);

    final parent = request?.rootNavigator ?? false ? '' : candidate.parent;

    // Use the aggregate to determine the right route and return it.
    return candidate.copyWith(
      type: request?.type ?? RouteType.pushNavigate,
      arguments: request?.arguments,
      parent: parent,
    );
  }

  @override
  RouteInformation restoreRouteInformation(RouteEntity configuration) {
    // Convert a given [RouteEntity] back to [RouteInformation] for restoration.
    return RouteInformation(
      uri: configuration.uri,
      state: RouteRequest(
        arguments: configuration.arguments,
        type: configuration.type,
        rootNavigator: false,
      ),
    );
  }
}

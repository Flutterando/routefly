// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';
import 'package:routefly/src/navigation/url_service/url_service.dart';

typedef RouteMiddleware = FutureOr<RouteInformation> Function(
  RouteInformation routeInformation,
);

class RouteflyInformationParser extends RouteInformationParser<RouteEntity> {
  final RouteAggregate aggregate;
  final List<RouteMiddleware> middlewares;

  bool _firstAccess = true;

  RouteflyInformationParser(this.aggregate, this.middlewares);

  @override
  Future<RouteEntity> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final urlService = UrlService.create();

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

    final request = routeInformation.state as RouteRequest?;

    for (final middleware in middlewares) {
      routeInformation = await middleware(routeInformation);
    }

    return aggregate
        .findRoute(routeInformation.uri) //
        .copyWith(
          type: request?.type ?? RouteType.pushNavigate,
          arguments: request?.arguments,
        );
  }

  @override
  RouteInformation restoreRouteInformation(RouteEntity configuration) {
    return RouteInformation(
      uri: configuration.uri,
      state: RouteRequest(
        arguments: configuration.arguments,
        type: configuration.type,
      ),
    );
  }
}

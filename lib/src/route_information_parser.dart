import 'package:flutter/widgets.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/url_service/url_service.dart';

class RouteflyInformationParser extends RouteInformationParser<RouteEntity> {
  final List<RouteEntity> routes;

  bool _firstAccess = true;

  RouteflyInformationParser(this.routes);

  @override
  Future<RouteEntity> parseRouteInformation(RouteInformation routeInformation) async {
    final urlService = UrlService.create();
    final type = routeInformation.state as RouteType;

    String path = routeInformation.uri.path;
    if (_firstAccess) {
      path = urlService.getPath() ?? routeInformation.uri.path;
      path = path == '/' ? routeInformation.uri.path : path;
      _firstAccess = false;
    }

    return routes.firstWhere((r) => r.path == path).copyWith(type: type);
  }

  @override
  RouteInformation restoreRouteInformation(RouteEntity configuration) {
    return RouteInformation(uri: Uri.parse(configuration.path), state: configuration.type);
  }
}

import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class RouteflyRouterDelegate extends RouterDelegate<RouteEntity> with ChangeNotifier {
  var pages = <Page>[];

  @override
  Widget build(BuildContext context) {
    if (pages.isEmpty) {
      return const Material();
    }

    return Navigator(
      pages: pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  Future<void> setNewRoutePath(RouteEntity configuration) async {
    if (configuration.type == RouteType.navigate) {
      pages = [configuration.page];
    } else {
      pages = [...pages, configuration.page];
    }

    notifyListeners();
  }
}

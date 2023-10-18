// ignore_for_file: public_member_api_docs

import 'package:routefly/routefly.dart';

import 'routefly_page.dart';

class RouteflyState {
  final RouteflyPage _page;
  late final query = RouteflyQuery(
    _page.entity.uri.queryParameters,
    _page.entity.params,
    _page.entity.arguments,
  );

  RouteEntity get route => _page.entity;

  RouteflyState(
    this._page,
  );

  void navigate(String path, {dynamic arguments}) => Routefly.navigate(
        path,
        arguments: arguments,
      );
  void push(String path, {dynamic arguments}) => Routefly.push(
        path,
        arguments: arguments,
      );
  void replace(String path, {dynamic arguments}) => Routefly.replace(
        path,
        arguments: arguments,
      );
  void pop() => Routefly.pop();
}

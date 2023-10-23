import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'routefly_page.dart';

/// Represents the state associated with a Routefly page.
class RouteflyState {
  /// The build context associated with the current widget tree.
  final BuildContext _context;

  /// The current page being handled by Routefly.
  final RouteflyPage _page;

  /// The query parameters derived from the current page's URI.
  late final query = RouteflyQuery(
    _page.entity.uri.queryParameters,
    _page.entity.params,
    _page.entity.arguments,
  );

  /// Retrieves the [RouteEntity] associated with the current page.
  RouteEntity get route => _page.entity;

  /// Creates a new instance of [RouteflyState].
  ///
  /// - `_page` is the current page being handled by Routefly.
  /// - `_context` is the build context associated with the widget tree.
  RouteflyState(
    this._page,
    this._context,
  );

  /// Navigates to a specified path using [Routefly].
  ///
  /// - `path` is the destination route's path.
  /// - `arguments` is an optional set of data to
  /// be passed to the destination route.
  void navigate(
    String path, {
    dynamic arguments,
  }) =>
      Routefly.navigate(
        path,
        arguments: arguments,
      );

  /// Navigates to a specified path using [Routefly] and
  /// pushes the route onto the navigation stack.
  ///
  /// - `path` is the destination route's path.
  /// - `arguments` is an optional set of data to be passed to
  /// the destination route.
  void pushNavigate(String path, {dynamic arguments}) => Routefly.pushNavigate(
        path,
        arguments: arguments,
      );

  /// Pushes the route specified by the path onto the navigation stack.
  ///
  /// - `path` is the destination route's path.
  /// - `arguments` is an optional set of data to be passed
  /// to the destination route.
  /// - `rootNavigator` is an optional flag to determine if
  /// the root navigator should be used.
  void push(
    String path, {
    dynamic arguments,
    bool rootNavigator = false,
  }) =>
      Routefly.push(
        path,
        arguments: arguments,
      );

  /// Replaces the current route with the route specified by the path.
  ///
  /// - `path` is the destination route's path.
  /// - `arguments` is an optional set of data to be passed
  /// to the destination route.
  /// - `rootNavigator` is an optional flag to determine if
  /// the root navigator should be used.
  void replace(
    String path, {
    dynamic arguments,
    bool rootNavigator = false,
  }) =>
      Routefly.replace(
        path,
        arguments: arguments,
      );

  /// Pops the current route off the navigation stack.
  void pop() => Routefly.pop(_context);
}

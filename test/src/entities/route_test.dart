import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/entities/route_entity.dart';

void main() {
  Route routeBuilder(c, s) => MaterialPageRoute(builder: (_) => Container());

  test('return null if path not match', () {
    final route = RouteEntity(uri: Uri.parse('/dashboard'), routeBuilder: routeBuilder, key: '/user/edit');

    expect(route.addNewInfo('/product'), isNull);
  });

  test('return {} if path match but has not params', () {
    final route = RouteEntity(uri: Uri.parse('/dashboard'), routeBuilder: routeBuilder, key: '/user/edit');

    expect(route.addNewInfo('/dashboard'), isNotNull);
  });

  test('return {id: 1} if path match with params', () {
    final route = RouteEntity(uri: Uri.parse('/user/[id]'), routeBuilder: routeBuilder, key: '/user/edit');

    final newRoute = route.addNewInfo('/user/1');

    expect(newRoute?.params, {'id': 1});
  });

  test('return {id: 1, key: "text"} if path match with params', () {
    final route = RouteEntity(uri: Uri.parse('/user/[id]/[key]'), routeBuilder: routeBuilder, key: '/user/edit');
    final newRoute = route.addNewInfo('/user/1/text');

    expect(newRoute?.params, {'id': 1, 'key': 'text'});
  });
}

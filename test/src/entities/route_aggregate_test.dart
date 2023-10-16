import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';

void main() {
  routeBuilder(c, s) => MaterialPageRoute(builder: (_) => Container());

  test('Order Routes', () {
    final aggregate = RouteAggregate(routes: [
      RouteEntity(uri: Uri.parse('/user/edit'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('user/edit/[id]'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/product'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/product/edit/test'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/product/[id]'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/[test]'), routeBuilder: routeBuilder),
    ], notFoundPath: '/404');

    expect(
        aggregate.routes,
        equals([
          RouteEntity(uri: Uri.parse('/product'), routeBuilder: routeBuilder),
          RouteEntity(uri: Uri.parse('/user/edit'), routeBuilder: routeBuilder),
          RouteEntity(uri: Uri.parse('/product/edit/test'), routeBuilder: routeBuilder),
          RouteEntity(uri: Uri.parse('/[test]'), routeBuilder: routeBuilder),
          RouteEntity(uri: Uri.parse('/product/[id]'), routeBuilder: routeBuilder),
          RouteEntity(uri: Uri.parse('user/edit/[id]'), routeBuilder: routeBuilder),
        ]));
  });

  test('find Routes', () {
    final aggregate = RouteAggregate(routes: [
      RouteEntity(uri: Uri.parse('/user/edit'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('user/edit/[id]'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/product'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/product/edit/test'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/product/[id]'), routeBuilder: routeBuilder),
      RouteEntity(uri: Uri.parse('/[test]'), routeBuilder: routeBuilder),
    ], notFoundPath: '/404');

    expect(aggregate.findRoute('/product'), isNotNull);
    expect(aggregate.findRoute('/product/edit/test'), isNotNull);
    expect(aggregate.findRoute('/product/2'), isNotNull);
  });
}

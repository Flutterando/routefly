import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';

void main() {
  Route routeBuilder(c, s) => MaterialPageRoute(builder: (_) => Container());

  test('Order Routes', () {
    final aggregate = RouteAggregate(
      routes: [
        RouteEntity(uri: Uri.parse('/user/edit'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('/user/edit/[id]'), routeBuilder: routeBuilder, key: '/user/edit/[id]'),
        RouteEntity(uri: Uri.parse('/product'), routeBuilder: routeBuilder, key: '/product'),
        RouteEntity(uri: Uri.parse('/product/edit/test'), routeBuilder: routeBuilder, key: '/product/edit/test'),
        RouteEntity(uri: Uri.parse('/product/[id]'), routeBuilder: routeBuilder, key: '/product/[id]'),
        RouteEntity(uri: Uri.parse('/[test]'), routeBuilder: routeBuilder, key: '/[test]'),
      ],
      notFoundPath: '/404',
    );

    expect(
      aggregate.routes,
      equals([
        RouteEntity(uri: Uri.parse('/product'), routeBuilder: routeBuilder, key: '/product'),
        RouteEntity(uri: Uri.parse('/user/edit'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('/product/edit/test'), routeBuilder: routeBuilder, key: '/product/edit/test'),
        RouteEntity(uri: Uri.parse('/[test]'), routeBuilder: routeBuilder, key: '/[test]'),
        RouteEntity(uri: Uri.parse('/product/[id]'), routeBuilder: routeBuilder, key: '/product/[id]'),
        RouteEntity(uri: Uri.parse('/user/edit/[id]'), routeBuilder: routeBuilder, key: '/user/edit/[id]'),
      ]),
    );
  });

  test('find Routes', () {
    final aggregate = RouteAggregate(
      routes: [
        RouteEntity(uri: Uri.parse('/user/edit'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('user/edit/[id]'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('/product'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('/product/edit/test'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('/product/[id]'), routeBuilder: routeBuilder, key: '/user/edit'),
        RouteEntity(uri: Uri.parse('/[test]'), routeBuilder: routeBuilder, key: '/user/edit'),
      ],
      notFoundPath: '/404',
    );

    expect(aggregate.findRoute('/product'), isNotNull);
    expect(aggregate.findRoute('/product/edit/test'), isNotNull);
    expect(aggregate.findRoute('/product/2'), isNotNull);
  });

  test('find Routes with parent', () {
    final parent = RouteEntity(uri: Uri.parse('/dashboard'), routeBuilder: routeBuilder, key: '/dashboard');
    final aggregate = RouteAggregate(
      routes: [
        parent,
        RouteEntity(uri: Uri.parse('/dashboard/option1'), routeBuilder: routeBuilder, key: '/dashboard/option1', parent: '/dashboard'),
        RouteEntity(uri: Uri.parse('/dashboard/option2'), routeBuilder: routeBuilder, key: '/dashboard/option2', parent: '/dashboard'),
      ],
      notFoundPath: '/404',
    );

    final route = aggregate.findRoute('/dashboard/option1');

    expect(route.parentEntity, parent);
  });
}

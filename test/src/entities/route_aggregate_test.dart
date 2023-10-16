import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';

void main() {
  final page = MaterialPage(child: Container());

  test('Order Routes', () {
    final aggregate = RouteAggregate(routes: [
      RouteEntity(uri: Uri.parse('/user/edit'), page: page),
      RouteEntity(uri: Uri.parse('user/edit/[id]'), page: page),
      RouteEntity(uri: Uri.parse('/product'), page: page),
      RouteEntity(uri: Uri.parse('/product/edit/test'), page: page),
      RouteEntity(uri: Uri.parse('/product/[id]'), page: page),
      RouteEntity(uri: Uri.parse('/[test]'), page: page),
    ], notFoundPath: '/404');

    expect(
        aggregate.routes,
        equals([
          RouteEntity(uri: Uri.parse('/product'), page: page),
          RouteEntity(uri: Uri.parse('/user/edit'), page: page),
          RouteEntity(uri: Uri.parse('/product/edit/test'), page: page),
          RouteEntity(uri: Uri.parse('/[test]'), page: page),
          RouteEntity(uri: Uri.parse('/product/[id]'), page: page),
          RouteEntity(uri: Uri.parse('user/edit/[id]'), page: page),
        ]));
  });

  test('find Routes', () {
    final aggregate = RouteAggregate(routes: [
      RouteEntity(uri: Uri.parse('/user/edit'), page: page),
      RouteEntity(uri: Uri.parse('user/edit/[id]'), page: page),
      RouteEntity(uri: Uri.parse('/product'), page: page),
      RouteEntity(uri: Uri.parse('/product/edit/test'), page: page),
      RouteEntity(uri: Uri.parse('/product/[id]'), page: page),
      RouteEntity(uri: Uri.parse('/[test]'), page: page),
    ], notFoundPath: '/404');

    expect(aggregate.findRoute('/product'), isNotNull);
    expect(aggregate.findRoute('/product/edit/test'), isNotNull);
    expect(aggregate.findRoute('/product/2'), isNotNull);
  });
}

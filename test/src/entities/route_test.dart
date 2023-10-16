import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/entities/route_entity.dart';

void main() {
  test('return null if path not match', () {
    final route = RouteEntity(uri: Uri.parse('/dashboard'), page: MaterialPage(child: Container()));

    expect(route.addNewInfo('/product'), null);
  });

  test('return {} if path match but has not params', () {
    final route = RouteEntity(uri: Uri.parse('/dashboard'), page: MaterialPage(child: Container()));

    expect(route.addNewInfo('/dashboard'), {});
  });

  test('return {id: 1} if path match with params', () {
    final route = RouteEntity(uri: Uri.parse('/user/[id]'), page: MaterialPage(child: Container()));

    expect(route.addNewInfo('/user/1'), {'id': 1});
  });

  test('return {id: 1, key: "text"} if path match with params', () {
    final route = RouteEntity(uri: Uri.parse('/user/[id]/[key]'), page: MaterialPage(child: Container()));

    expect(route.addNewInfo('/user/1/text'), {'id': 1, 'key': 'text'});
  });
}

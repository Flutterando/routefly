import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';
import 'package:routefly/src/navigation/route_information_parser.dart';

void main() {
  group('route information parser ...', () {
    test('Should return RouteEntity', () async {
      final parser = RouteflyInformationParser(
        RouteAggregate(
          routes: [],
          notFoundPath: '/404',
        ),
        [],
      );

      final result = await parser.parseRouteInformation(
        RouteInformation(
          uri: Uri.parse('/asd'),
          state: '''
              {"type": "navigate", 
              "arguments": {"id": 1}, 
              "rootNavigator": true}
              ''',
        ),
      );

      expect(
        result,
        isA<RouteEntity>(),
      );
    });

    test('Should return RouterInformation', () {
      final routeEntity = RouteEntity(
        key: '/',
        uri: Uri.parse('/'),
        routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
          ctx,
          settings,
          Container(),
        ),
      );

      final parser = RouteflyInformationParser(
        RouteAggregate(
          routes: [routeEntity],
          notFoundPath: '/404',
        ),
        [],
      );

      final result = parser.restoreRouteInformation(routeEntity);

      expect(
        result,
        isA<RouteInformation>(),
      );
    });
  });
}

// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../entities/route_entity.dart';

class RouteflyPage extends Page {
  final RouteEntity entity;

  const RouteflyPage({
    required this.entity,
    required super.name,
    required super.arguments,
    required super.key,
  });

  factory RouteflyPage.fromEntity(RouteEntity entity, int count) {
    final key = ValueKey('${entity.uri.path}@$count');

    return RouteflyPage(
      entity: entity,
      name: entity.uri.path,
      arguments: entity.arguments,
      key: key,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    final route = entity.routeBuilder(context, this);
    return route;
  }
}

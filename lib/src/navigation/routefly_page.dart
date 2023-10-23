// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../entities/route_entity.dart';

/// `RouteflyPage` is a custom [Page] tailored for the 'Routefly' framework.
///
/// It represents a screen or a part of a navigation stack and is directly
/// associated with a specific [RouteEntity]. This allows it to be more
/// declarative in terms of how it interacts with Flutter's navigation system
/// and the 'Routefly' framework.
class RouteflyPage extends Page {
  /// The associated [RouteEntity] that defines the properties and behavior
  /// of this page.
  final RouteEntity entity;

  /// Constructs a [RouteflyPage].
  ///
  /// The [entity], [name], [arguments], and [key] are required.
  ///
  /// - [entity]: The associated [RouteEntity] for this page.
  /// - [name]: A string identifier for this page.
  /// - [arguments]: Any arguments required for this page.
  /// - [key]: A unique key for this page, used to control its position in the
  /// navigation stack.
  const RouteflyPage({
    required this.entity,
    required super.name,
    required super.arguments,
    required super.key,
  });

  /// Creates a new instance of [RouteflyPage] from a given [RouteEntity].
  ///
  /// The unique key for the page is generated based on the entity's URI path
  /// and the provided [count]. This ensures that even if the same path is
  /// navigated to multiple times, each instance can be uniquely identified.
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

  /// Creates the [Route] for this page using the associated [RouteEntity]'s
  /// route builder.
  Route createRoute(BuildContext context) {
    final route = entity.routeBuilder(context, this);
    return route;
  }
}

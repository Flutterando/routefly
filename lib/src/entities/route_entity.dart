import 'dart:convert';

import 'package:flutter/material.dart';

/// Typedef for a function that builds a [Route] based on the provided context
/// and route settings.
typedef RouteBuilder = Route Function(
  BuildContext context,
  RouteSettings settings,
);

/// Enumeration defining the type of the route action.
enum RouteType {
  /// for navigation
  navigate,

  /// for push
  push,

  /// for replace
  replace,
}

/// Represents a route entity with its associated configurations.
@immutable
class RouteEntity {
  /// The URI of the route.
  final Uri uri;

  /// The route builder function.
  final RouteBuilder routeBuilder;

  /// The page associated with the route.
  late final Page page;

  /// The type of the route.
  final RouteType type;

  /// The key of the route.
  final String key;

  /// The parent of the route.
  final String parent;

  /// The parent entity of the route.
  final RouteEntity? parentEntity;

  /// The parameters of the route.
  final Map<String, dynamic> params;

  ///
  final dynamic arguments;

  /// Creates a [RouteEntity] with the provided parameters.
  RouteEntity({
    required this.uri,
    required this.routeBuilder,
    required this.key,
    this.parent = '',
    this.parentEntity,
    Page? page,
    this.params = const {},
    this.arguments,
    this.type = RouteType.navigate,
  }) {
    this.page = page ?? MaterialPage(child: Container());
  }

  /// Creates a new [RouteEntity] by copying existing values and replacing
  /// them with new ones if provided.
  RouteEntity copyWith({
    Uri? uri,
    String? parent,
    String? key,
    RouteEntity? parentEntity,
    RouteBuilder? routeBuilder,
    RouteType? type,
    Page? page,
    dynamic arguments,
    Map<String, dynamic>? params,
  }) {
    return RouteEntity(
      uri: uri ?? this.uri,
      parentEntity: parentEntity ?? this.parentEntity,
      routeBuilder: routeBuilder ?? this.routeBuilder,
      type: type ?? this.type,
      page: page ?? this.page,
      arguments: arguments ?? this.arguments,
      params: params ?? this.params,
      key: key ?? this.key,
      parent: parent ?? this.parent,
    );
  }

  /// Adds new info based on a candidate URI and returns a new [RouteEntity].
  RouteEntity? addNewInfo(Uri uriCandidate) {
    final params = <String, dynamic>{};

    if (uri.pathSegments.length != uriCandidate.pathSegments.length) {
      return null;
    }

    for (var i = 0; i < uri.pathSegments.length; i++) {
      final segment = uri.pathSegments[i];
      final segmentCandidate = uriCandidate.pathSegments[i];

      if (segment.contains('[')) {
        final key = segment.replaceFirst('[', '').replaceFirst(']', '');
        final value = num.tryParse(segmentCandidate) ?? segmentCandidate;
        params[key] = value;
        continue;
      }

      if (segment != segmentCandidate) {
        return null;
      }
    }

    return copyWith(
      uri: uriCandidate,
      params: params,
    );
  }

  @override
  String toString() => 'RouteEntity => $key';

  @override
  bool operator ==(covariant RouteEntity other) =>
      identical(this, other) //
      ||
      other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Represents a request to manage a route with its associated configurations.
class RouteRequest {
  /// The arguments of the route.
  final dynamic arguments;

  /// The type of the route.
  final RouteType type;

  /// Creates a [RouteRequest] with the provided arguments and type.
  RouteRequest({
    required this.arguments,
    required this.type,
  });

  /// Converts the [RouteRequest] to a map representation.
  Map<String, dynamic> toMap() => <String, dynamic>{'type': type.name};

  /// Creates a [RouteRequest] from its map representation.
  factory RouteRequest.fromMap(Map<String, dynamic> map) {
    return RouteRequest(
      arguments: map['arguments'],
      type: RouteType.values.firstWhere(
        (element) => element.name == map['type'],
      ),
    );
  }

  /// Converts the [RouteRequest] to its JSON representation.
  String toJson() => json.encode(toMap());

  /// Creates a [RouteRequest] from its JSON representation.
  factory RouteRequest.fromJson(String source) {
    return RouteRequest.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}

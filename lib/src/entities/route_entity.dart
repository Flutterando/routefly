// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

typedef RouteBuilder = Route Function(BuildContext context, RouteSettings settings);

class RouteEntity {
  final Uri uri;
  final RouteBuilder routeBuilder;
  late final Page page;
  final RouteType type;
  final Map<String, dynamic> params;
  final dynamic arguments;

  RouteEntity({
    required this.uri,
    required this.routeBuilder,
    Page? page,
    this.params = const {},
    this.arguments,
    this.type = RouteType.navigate,
  }) {
    this.page = page ?? MaterialPage(child: Container());
  }

  RouteEntity copyWith({
    Uri? uri,
    RouteBuilder? routeBuilder,
    RouteType? type,
    Page? page,
    dynamic arguments,
    Map<String, dynamic>? params,
  }) {
    return RouteEntity(
      uri: uri ?? this.uri,
      routeBuilder: routeBuilder ?? this.routeBuilder,
      type: type ?? this.type,
      page: page ?? this.page,
      arguments: arguments ?? this.arguments,
      params: params ?? this.params,
    );
  }

  RouteEntity? addNewInfo(String path) {
    final params = <String, dynamic>{};
    final uriCandidate = Uri.parse(path);

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
  String toString() {
    return 'RouteEntity => ${uri.path}';
  }

  @override
  bool operator ==(covariant RouteEntity other) {
    if (identical(this, other)) return true;

    return other.uri.path == uri.path;
  }

  @override
  int get hashCode {
    return uri.path.hashCode;
  }
}

class RouteRequest {
  final dynamic arguments;
  final RouteType type;
  RouteRequest({
    required this.arguments,
    required this.type,
  });
}

enum RouteType { navigate, push, replace }

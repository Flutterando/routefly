// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

typedef RouteBuilder = Route Function(
  BuildContext context,
  RouteSettings settings,
);

@immutable
class RouteEntity {
  final Uri uri;
  final RouteBuilder routeBuilder;
  late final Page page;
  final RouteType type;
  final String key;
  final String parent;
  final RouteEntity? parentEntity;
  final Map<String, dynamic> params;
  final dynamic arguments;

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
    return 'RouteEntity => $key';
  }

  @override
  bool operator ==(covariant RouteEntity other) {
    if (identical(this, other)) return true;

    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RouteRequest {
  final dynamic arguments;
  final RouteType type;
  RouteRequest({
    required this.arguments,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
    };
  }

  factory RouteRequest.fromMap(Map<String, dynamic> map) {
    return RouteRequest(
      arguments: map['arguments'] as dynamic,
      type: RouteType.values.firstWhere(
        (element) => element.name == map['type'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteRequest.fromJson(String source) => RouteRequest.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

enum RouteType { navigate, push, replace }

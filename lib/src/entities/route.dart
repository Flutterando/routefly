// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class RouteEntity {
  final String path;
  final Page page;
  final RouteType type;

  RouteEntity({
    required this.path,
    required this.page,
    this.type = RouteType.navigate,
  });

  RouteEntity copyWith({
    String? path,
    Page? page,
    RouteType? type,
  }) {
    return RouteEntity(
      path: path ?? this.path,
      page: page ?? this.page,
      type: type ?? this.type,
    );
  }
}

enum RouteType { navigate, push }

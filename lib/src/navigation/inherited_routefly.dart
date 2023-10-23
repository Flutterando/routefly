import 'package:flutter/material.dart';
import 'package:routefly/src/routefly.dart';

/// `InheritedRoutefly` is an [InheritedNotifier] that provides the
/// [Routefly] instance to its descendants.
class InheritedRoutefly extends InheritedNotifier<Listenable> {
  /// `InheritedRoutefly` is an [InheritedNotifier] that provides the
  /// [Routefly] instance to its descendants.
  InheritedRoutefly({
    super.key,
    required super.child,
  }) : super(notifier: Routefly.listenable);
}

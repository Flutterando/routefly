// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:routefly/src/routefly.dart';

class InheritedRoutefly extends InheritedNotifier<Listenable> {
  InheritedRoutefly({
    super.key,
    required super.child,
  }) : super(notifier: Routefly.listenable);
}

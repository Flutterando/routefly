// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../routefly.dart';

class CustomNavigator extends Navigator {
  const CustomNavigator({
    super.key,
    super.pages,
    super.onPopPage,
    super.observers,
  });

  @override
  NavigatorState createState() => _CustomNavigatorState();
}

class _CustomNavigatorState extends NavigatorState {
  @override
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    Routefly.push(routeName, arguments: arguments);
    return null;
  }

  @override
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) async {
    Routefly.replace(routeName, arguments: arguments);
    return null;
  }
}

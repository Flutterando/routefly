// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../routefly.dart';

/// `CustomNavigator` extends Flutter's [Navigator] class, providing
/// a customized navigation mechanism suitable for the 'Routefly' framework.
///
/// This navigator utilizes a custom navigator state (`_CustomNavigatorState`)
/// to override and adapt some navigation methods like `pushNamed` and
/// `pushReplacementNamed` for the Routefly framework's requirements.
class CustomNavigator extends Navigator {
  /// Constructs a [CustomNavigator].
  ///
  /// Inherits parameters from the [Navigator] constructor such as
  /// [key], [pages], [onPopPage], and [observers].
  const CustomNavigator({
    super.key,
    super.pages,
    super.onPopPage,
    super.observers,
  });

  @override
  NavigatorState createState() => _CustomNavigatorState();
}

/// The private navigator state class `_CustomNavigatorState`
/// for [CustomNavigator].
///
/// This state class provides custom implementations for methods
/// like `pushNamed`
/// and `pushReplacementNamed` to integrate with the 'Routefly' framework.
class _CustomNavigatorState extends NavigatorState {
  @override

  /// Pushes a named route into the navigation stack.
  ///
  /// Instead of using the default navigator mechanism, this method uses
  /// the 'Routefly' framework's `push` method to handle the named
  /// route navigation.
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    Routefly.push(routeName, arguments: arguments);
    return null;
  }

  @override

  /// Pushes a named route into the navigation stack and removes the
  /// current route.
  ///
  /// Instead of the default mechanism, this uses the 'Routefly' framework's
  /// `replace` method for route replacement.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) async {
    Routefly.replace(routeName, arguments: arguments);
    return null;
  }
}

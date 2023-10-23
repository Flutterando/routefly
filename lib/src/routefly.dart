import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';
import 'package:routefly/src/entities/route_aggregate.dart';
import 'package:routefly/src/navigation/routefly_page.dart';
import 'package:routefly/src/navigation/router_delegate.dart';

import 'navigation/custom_navigator.dart';
import 'navigation/inherited_routefly.dart';
import 'navigation/route_information_parser.dart';

part 'navigation/outlet/outlet_delegate.dart';
part 'navigation/outlet/router_outlet.dart';

/// Typedef for a function that builds a [Route] based on the provided context
typedef RouteBuilderWithChild = Route Function(
  BuildContext context,
  RouteSettings settings,
  Widget child,
);

/// [Routefly] provides a folder-based route management inspired by NextJS.
/// It's a solution created by the Flutterando community for Flutter
/// applications.
///
/// By organizing your code files within specific directories, Routefly
/// allows automatic route creation. When a file is added to the "pages"
/// directory,
/// it becomes instantly accessible as a route. For optimal results, ensure you
/// structure
/// your folders appropriately inside the "lib/app" directory.
abstract class Routefly {
  static PlatformRouteInformationProvider? _provider;
  static RouteflyRouterDelegate? _delegate;

  /// The default route builder used by [Routefly].
  static late RouteBuilderWithChild defaultRouteBuilder;

  /// Provides a [Listenable] object to listen to route changes.
  static Listenable get listenable {
    _verifyInitialization();
    return _delegate!;
  }

  /// Accesses the current route state using [InheritedWidget]
  /// in the given [context].
  static RouteflyState of(BuildContext context) {
    final page = ModalRoute.of(context)!.settings as RouteflyPage;
    context.dependOnInheritedWidgetOfExactType<InheritedRoutefly>();
    return RouteflyState(page, context);
  }

  /// Adds a new route on top of the existing stack.
  static void pushNavigate(String path, {dynamic arguments}) {
    _verifyInitialization();

    final uri = currentUri.resolve(path);

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: uri,
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.pushNavigate,
        ),
      ),
    );
  }

  /// Replaces the entire route stack with the given route.
  static void navigate(String path, {dynamic arguments}) {
    _verifyInitialization();

    final uri = currentUri.resolve(path);

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: uri,
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.navigate,
        ),
      ),
    );
  }

  /// Replaces only the last route in the stack with the provided route.
  static void replace(String path, {dynamic arguments}) {
    _verifyInitialization();
    final uri = currentUri.resolve(path);

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: uri,
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.replace,
        ),
      ),
    );
  }

  /// Adds a new route on top of the existing stack.
  static void push(String path, {dynamic arguments}) {
    _verifyInitialization();
    final uri = currentUri.resolve(path);

    _provider!.didPushRouteInformation(
      RouteInformation(
        uri: uri,
        state: RouteRequest(
          arguments: arguments,
          type: RouteType.push,
        ),
      ),
    );
  }

  /// Removes the last route from the stack.
  static void pop(BuildContext context) {
    _verifyInitialization();

    Navigator.of(context).pop();
  }

  static RouteEntity get _route {
    _verifyInitialization();
    return _delegate!.configurations.last;
  }

  /// Route path uri
  static Uri get currentUri => _delegate!.currentConfiguration!.uri;

  /// Original route path
  static String get currentOriginalPath => _delegate!.currentConfiguration!.key;

  /// Route Parameters
  static RouteflyQuery get query => RouteflyQuery(
        currentUri.queryParameters,
        _route.params,
        _route.arguments,
      );

  static void _verifyInitialization() {
    if (_provider == null || _delegate == null) {
      throw RouteflyException('Routefly must be declare in MaterialApp '
          'or CupertinoApp.\nPlease, check the docs for more information.');
    }
  }

  /// A utility method to create a [MaterialPageRoute].
  ///
  /// This method simplifies the process of creating a [MaterialPageRoute]
  /// by wrapping the given [child] widget into it, and using
  /// the provided [settings].
  ///
  /// Parameters:
  /// * [context]: The build context, typically obtained from
  /// a widget's build method.
  /// * [settings]: Configuration values for the route created by this builder.
  /// * [child]: The widget that will be shown when this route
  /// is pushed onto the navigator.
  ///
  /// Returns:
  /// A [MaterialPageRoute] with the given settings and child.
  static Route materialRouteBuilder(
    BuildContext context,
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => child,
    );
  }

  /// A utility method to create a [CupertinoPageRoute].
  ///
  /// This method simplifies the process of creating a [CupertinoPageRoute]
  /// by wrapping the given [child] widget into it, and
  /// using the provided [settings].
  ///
  /// Parameters:
  /// * [context]: The build context, typically obtained from a
  /// widget's build method.
  /// * [settings]: Configuration values for the route created by this builder.
  /// * [child]: The widget that will be shown when this route is
  /// pushed onto the navigator.
  ///
  /// Returns:
  /// A [CupertinoPageRoute] with the given settings and child.
  static Route cupertinoRouteBuilder(
    BuildContext context,
    RouteSettings settings,
    Widget child,
  ) {
    return CupertinoPageRoute(
      settings: settings,
      builder: (context) => child,
    );
  }

  /// Initializes and returns configurations for Navigator 2.0.
  static RouterConfig<Object>? routerConfig({
    String initialPath = '',
    required List<RouteEntity> routes,
    String notFoundPath = '404',
    RouteBuilderWithChild? routeBuilder,
    List<NavigatorObserver> observers = const [],
    List<RouteMiddleware> middlewares = const [],
  }) {
    defaultRouteBuilder = routeBuilder ?? materialRouteBuilder;

    _provider ??= PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: Uri.parse(initialPath),
        state: RouteRequest(arguments: null, type: RouteType.navigate),
      ),
    );

    _delegate ??= RouteflyRouterDelegate([
      HeroController(),
      ...observers,
    ]);

    return RouterConfig(
      routerDelegate: _delegate!,
      routeInformationParser: RouteflyInformationParser(
        RouteAggregate(
          routes: routes,
          notFoundPath: notFoundPath,
        ),
        middlewares,
      ),
      routeInformationProvider: _provider,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}

/// An extension on `RouteInformation` that provides helper methods
/// for routing operations, such as redirecting, rewriting,
/// and extracting queries.
extension RouteInformationExtension on RouteInformation {
  /// Redirects the current URI to a new URI.
  RouteInformation redirect(Uri newUri) {
    return RouteInformation(
      uri: newUri,
      state: request ?? state,
    );
  }

  /// Retrieves query and parameters for a given path.
  RouteflyQuery? query(String path) {
    final data = <String, dynamic>{};
    final uriCandidate = Uri.parse(path);

    if (uri.pathSegments.length != uriCandidate.pathSegments.length) {
      return null;
    }

    for (var i = 0; i < uriCandidate.pathSegments.length; i++) {
      final segmentCandidate = uriCandidate.pathSegments[i];
      final segment = uri.pathSegments[i];

      if (segmentCandidate.contains('[')) {
        final key = segmentCandidate //
            .replaceFirst('[', '')
            .replaceFirst(']', '');
        final value = num.tryParse(segment) ?? segment;
        data[key] = value;
        continue;
      }

      if (segment != segmentCandidate) {
        return null;
      }
    }

    return RouteflyQuery(
      uri.queryParameters,
      data,
      request?.arguments,
    );
  }

  /// Rewrites the current URI with a new URI.
  RouteInformation rewrite(Uri newUri) {
    return RouteInformation(
      uri: newUri,
      state: request ?? state,
    );
  }

  /// Retrieves the route request object.
  RouteRequest? get request => state as RouteRequest?;
}

/// An extension on `String` to simplify the handling of route paths.
extension RoutePathsStringExtension on String {
  /// Dynamically replaces path parameters with their corresponding values.
  String changes(Map<String, String> queries) {
    var newPath = this;

    for (final key in queries.keys) {
      final param = queries[key]!;
      newPath = newPath.replaceFirst('[$key]', param);
    }

    return newPath;
  }
}

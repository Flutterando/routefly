// ignore_for_file: public_member_api_docs

part of '../../routefly.dart';

/// `OutletRouterDelegate` is a custom [RouterDelegate] tailored to handle
/// routing for the 'Routefly' framework, utilizing the path filtering and
/// observer functionalities.
///
/// The delegate works in close association with `Routefly` to manage the
/// navigational stack based on the provided configurations and filter criteria.
///
/// It uses a custom navigator (`CustomNavigator`) to showcase pages based
/// on the computed set of configurations that are relevant to the
/// current state.
class OutletRouterDelegate extends RouterDelegate<RouteEntity> //
    with
        ChangeNotifier {
  /// An optional filtering function that returns true if a given path
  /// should be included in the navigation stack.
  final bool Function(String path)? pathFilter;

  /// A list of observers that can be used to listen to the navigation
  /// events happening within this router delegate.
  final List<NavigatorObserver> observers;

  /// Creates a new instance of [OutletRouterDelegate].
  ///
  /// [pathFilter] can be provided to filter the routes based on a custom
  /// criteria.
  /// [observers] can be provided to observe the navigational changes.
  OutletRouterDelegate({required this.pathFilter, this.observers = const []});

  @override
  Widget build(BuildContext context) {
    // Retrieves the current routing state from the context.
    final state = Routefly.of(context);

    // Derive the current route entity and its parent path.
    final entity = state.route;
    final parent = entity.uri.path;

    // Computes the list of pages based on the configurations and filtering
    // criteria.
    final pages = Routefly._delegate!.configurations //
        .where((e) => e.parent == parent)
        .where((e) => pathFilter?.call(e.uri.toString()) ?? true)
        .map((e) => e.page)
        .toList();

    // If no pages match the criteria, display an empty container.
    if (pages.isEmpty) {
      return Container();
    }

    // Returns a custom navigator with the computed pages.
    return CustomNavigator(
      pages: pages,
      onPopPage: Routefly._delegate!.onPopPage,
      observers: observers,
    );
  }

  @override

  /// Determines whether the current route can be popped.
  ///
  /// This implementation always returns false, indicating that
  /// the route cannot be popped.
  Future<bool> popRoute() async {
    return false;
  }

  @override

  /// An empty implementation for setting a new route path.
  ///
  /// Future enhancements or extensions can provide a meaningful
  /// implementation based on use-cases.
  Future<void> setNewRoutePath(RouteEntity configuration) async {}
}

part of '../../routefly.dart';

/// `RouterOutlet` is a [StatefulWidget] that serves as an outlet for routing
/// navigation within the 'Routefly' framework.
///
/// This widget utilizes the [OutletRouterDelegate] to handle the routing logic
/// based on provided configurations and path filters.
class RouterOutlet extends StatefulWidget {
  /// An optional filtering function that returns true if a given path
  /// should be included in the navigation stack.
  final bool Function(String path)? pathFilter;

  /// Constructs a [RouterOutlet].
  ///
  /// Optionally, [pathFilter] can be provided to filter the routes based
  /// on custom criteria.
  const RouterOutlet({super.key, this.pathFilter});

  @override
  State<RouterOutlet> createState() => _RouterOutletState();
}

/// The private state class for [RouterOutlet], responsible for initializing
/// the [OutletRouterDelegate] and providing the logic for building the
/// router with the delegate.
class _RouterOutletState extends State<RouterOutlet> {
  /// The router delegate instance that manages the navigation logic
  /// for this outlet.
  late OutletRouterDelegate _delegate;

  @override
  void initState() {
    super.initState();

    // Initializes the router delegate with provided path filter and
    // a set of default observers.
    _delegate = OutletRouterDelegate(
      pathFilter: widget.pathFilter,
      observers: [
        HeroController(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Returns a router widget that utilizes the initialized delegate
    // for navigation.
    return Router(
      routerDelegate: _delegate,
    );
  }
}

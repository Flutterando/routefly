part of '../../routefly.dart';

/// Nested Navigation.
class RouterOutlet extends StatefulWidget {
  /// filter path for nested navigation.
  /// if return true, the path will be handled by nested navigation.
  final bool Function(String path)? pathFilter;

  /// Nested Navigation.
  const RouterOutlet({super.key, this.pathFilter});

  @override
  State<RouterOutlet> createState() => _RouterOutletState();
}

class _RouterOutletState extends State<RouterOutlet> {
  late OutletRouterDelegate _delegate;

  @override
  void initState() {
    super.initState();

    _delegate = OutletRouterDelegate(
      pathFilter: widget.pathFilter,
      observers: [
        HeroController(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: _delegate,
    );
  }
}

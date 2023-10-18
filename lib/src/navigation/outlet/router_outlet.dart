part of '../../routefly.dart';

/// Nested Navigation.
class RouterOutlet extends StatelessWidget {
  /// Nested Navigation.
  const RouterOutlet({super.key});

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: OutletRouterDelegate(),
    );
  }
}

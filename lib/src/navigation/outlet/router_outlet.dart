part of '../../routefly.dart';

/// Nested Navigation.
class RouterOutlet extends StatelessWidget {
  /// The parent path of the outlet.
  final String? parentPath;

  /// Nested Navigation.
  const RouterOutlet({super.key, this.parentPath});

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: OutletRouterDelegate(parentPath),
    );
  }
}

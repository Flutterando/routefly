part of '../../routefly.dart';

class RouterOutlet extends StatelessWidget {
  const RouterOutlet({super.key});

  @override
  Widget build(BuildContext context) {
    return Router(
      routerDelegate: OutletRouterDelegate(),
    );
  }
}

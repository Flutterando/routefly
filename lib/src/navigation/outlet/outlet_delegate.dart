part of '../../routefly.dart';

class OutletRouterDelegate extends RouterDelegate<RouteEntity> with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    final state = Routefly.of(context);
    final entity = state.route;

    final configurations = Routefly._delegate!.configurations.where((e) => e.parent == entity.key);
    if (configurations.isEmpty) {
      return Container();
    }

    return CustomNavigator(
      pages: configurations.map((e) => e.page).toList(),
      onPopPage: Routefly._delegate!.onPopPage,
    );
  }

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  Future<void> setNewRoutePath(RouteEntity configuration) async {}
}

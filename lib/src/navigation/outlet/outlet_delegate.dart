// ignore_for_file: public_member_api_docs

part of '../../routefly.dart';

class OutletRouterDelegate extends RouterDelegate<RouteEntity> //
    with
        ChangeNotifier {
  final String? parentPath;

  OutletRouterDelegate(this.parentPath);

  @override
  Widget build(BuildContext context) {
    final state = Routefly.of(context);
    final entity = state.route;
    final parent = parentPath ?? entity.parent;

    final configurations = Routefly._delegate!.configurations.where(
      (e) => e.parent == parent,
    );
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

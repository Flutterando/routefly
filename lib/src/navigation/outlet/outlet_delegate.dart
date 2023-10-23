// ignore_for_file: public_member_api_docs

part of '../../routefly.dart';

class OutletRouterDelegate extends RouterDelegate<RouteEntity> //
    with
        ChangeNotifier {
  final bool Function(String path)? pathFilter;
  final List<NavigatorObserver> observers;

  OutletRouterDelegate({required this.pathFilter, this.observers = const []});

  @override
  Widget build(BuildContext context) {
    final state = Routefly.of(context);
    final entity = state.route;
    final parent = entity.uri.path;

    final pages = Routefly._delegate!.configurations //
        .where((e) => e.parent == parent)
        .where((e) => pathFilter?.call(e.uri.toString()) ?? true)
        .map((e) => e.page)
        .toList();

    if (pages.isEmpty) {
      return Container();
    }

    return CustomNavigator(
      pages: pages,
      onPopPage: Routefly._delegate!.onPopPage,
      observers: observers,
    );
  }

  @override
  Future<bool> popRoute() async {
    return false;
  }

  @override
  Future<void> setNewRoutePath(RouteEntity configuration) async {}
}

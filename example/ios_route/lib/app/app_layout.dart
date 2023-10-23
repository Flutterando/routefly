import 'package:flutter/cupertino.dart';
import 'package:ios_route/routes.dart';
import 'package:routefly/routefly.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late final CupertinoTabController controller;

  @override
  void initState() {
    super.initState();
    controller = CupertinoTabController();
    Routefly.listenable.addListener(_listener);
  }

  _listener() {
    final index = switch (Routefly.currentOriginalPath) {
      '/tab1' => 0,
      '/tab2' => 1,
      '/tab3' => 2,
      _ => 0,
    };

    controller.index = index == -1 ? 0 : index;
  }

  @override
  void dispose() {
    Routefly.listenable.removeListener(_listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: controller,
      tabBar: CupertinoTabBar(
        onTap: (value) {
          if (value == 0) {
            Routefly.pushNavigate(routePaths.tab1.path);
          } else if (value == 1) {
            Routefly.pushNavigate(routePaths.tab2.path);
          } else if (value == 2) {
            Routefly.pushNavigate(routePaths.tab3);
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star_fill),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock_solid),
            label: 'Recents',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_alt_circle_fill),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill),
            label: 'Keypad',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return RouterOutlet(
            pathFilter: (path) => path.startsWith(routePaths.tab1.path),
          );
        } else if (index == 1) {
          return RouterOutlet(
            pathFilter: (path) => path.startsWith(routePaths.tab2.path),
          );
        } else if (index == 2) {
          return RouterOutlet(
            pathFilter: (path) => path.startsWith(routePaths.tab3),
          );
        }
        return Container();
      },
    );
  }
}

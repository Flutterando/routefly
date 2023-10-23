import 'package:flutter/cupertino.dart';
import 'package:routefly/routefly.dart';

import '../routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      routerConfig: Routefly.routerConfig(
        initialPath: routePaths.tab1.path,
        routes: routes,
        routeBuilder: Routefly.cupertinoRouteBuilder,
      ),
    );
  }
}

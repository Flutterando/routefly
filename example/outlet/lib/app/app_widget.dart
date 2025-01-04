import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'app_widget.route.dart';

part 'app_widget.g.dart';

@Main('lib/app')
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: Routefly.routerConfig(
        routes: routes,
      ),
    );
  }
}

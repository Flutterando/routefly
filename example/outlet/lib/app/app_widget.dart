import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import '../routes.g.dart';

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

import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'app_widget.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RouteflyLogo(
              size: 200,
            ),
            ElevatedButton(
              onPressed: () {
                Routefly.navigate(routePaths.dashboard.option1);
              },
              child: const Text('Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

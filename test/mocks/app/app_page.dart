import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Routefly.navigate('/dashboard');
          },
          child: const Text('Dashboard'),
        ),
      ),
    );
  }
}

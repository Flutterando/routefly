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
            Routefly.push('/users', arguments: 1);
          },
          child: const Text('Navegar para usuario'),
        ),
      ),
    );
  }
}

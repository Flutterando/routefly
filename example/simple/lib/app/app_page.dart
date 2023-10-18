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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Routefly.push('/users', arguments: 1);
              },
              child: const Text('To User'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                Routefly.push('/guarded');
              },
              child: const Text('Guarded Route'),
            ),
          ],
        ),
      ),
    );
  }
}

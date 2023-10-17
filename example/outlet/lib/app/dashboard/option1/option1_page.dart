import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

Route routeBuilder(BuildContext context, RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, a1, a2) => const Option1Page(),
    transitionsBuilder: (_, a1, a2, child) {
      return FadeTransition(
        opacity: a1,
        child: child,
      );
    },
  );
}

class Option1Page extends StatelessWidget {
  const Option1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Option 1'),
      ),
      backgroundColor: Colors.red,
      body: ElevatedButton(
        onPressed: () {
          Routefly.push('/dashboard/option2');
        },
        child: const Text('Push Option 2'),
      ),
    );
  }
}

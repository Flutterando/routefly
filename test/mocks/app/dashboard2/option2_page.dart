import 'package:flutter/material.dart';

Route routeBuilder(BuildContext context, RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, a1, a2) => const Option2Page(),
    transitionsBuilder: (_, a1, a2, child) {
      return FadeTransition(
        opacity: a1,
        child: child,
      );
    },
  );
}

class Option2Page extends StatelessWidget {
  const Option2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Option 2'),
      ),
      backgroundColor: Colors.amber,
    );
  }
}

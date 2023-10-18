import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: Routefly.listenable,
                builder: (context, snapshot) {
                  final path = Routefly.uri.pathSegments.isEmpty //
                      ? ''
                      : Routefly.uri.pathSegments.last;
                  return ListView(
                    children: [
                      ListTile(
                        title: const Text('Option 1'),
                        selected: path == 'option1',
                        onTap: () {
                          Routefly.navigate('/dashboard/option1');
                        },
                      ),
                      ListTile(
                        title: const Text('Option 2'),
                        selected: path == 'option2',
                        onTap: () {
                          Routefly.navigate('/dashboard/option2');
                        },
                      ),
                      ListTile(
                        title: const Text('Option 3'),
                        selected: path == 'option3',
                        onTap: () {
                          Routefly.navigate('/dashboard/option3');
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const Expanded(
              flex: 3,
              child: RouterOutlet(),
            ),
          ],
        ),
      ),
    );
  }
}

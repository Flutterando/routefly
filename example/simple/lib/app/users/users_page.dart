import 'package:example/routes.dart';
import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    final count = Routefly.query.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Users $count'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Routefly.push(routePaths.users.$id.changes({'idx': '2'}));
          },
          child: const Text('Usuario 2'),
        ),
      ),
    );
  }
}

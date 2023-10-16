import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final id = Routefly.query['id'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Routefly.pop();
          },
          child: Text('User id: $id'),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:ios_route/routes.dart';
import 'package:routefly/routefly.dart';

class Tab1Page extends StatefulWidget {
  const Tab1Page({super.key});

  @override
  State<Tab1Page> createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Recents'),
      ),
      child: SafeArea(
        child: CupertinoListSection(
          children: [
            CupertinoListTile(
              title: const Text('Config 1'),
              onTap: () {
                Routefly.push(routePaths.tab2.page2);
              },
            ),
            CupertinoListTile(
              title: const Text('Config 2'),
              onTap: () {},
            ),
            CupertinoListTile(
              title: const Text('Config 3'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

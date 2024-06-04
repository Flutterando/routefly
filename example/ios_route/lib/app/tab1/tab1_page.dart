import 'package:flutter/cupertino.dart';
import 'package:ios_route/routes.g.dart';
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
        middle: Text('Favorites'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton.filled(
              child: Text('$count'),
              onPressed: () {
                setState(() {
                  count++;
                });
              },
            ),
            const SizedBox(height: 20.0),
            CupertinoButton.filled(
              child: const Text('Navigate to Page 2'),
              onPressed: () {
                Routefly.push(routePaths.tab1.page2);
              },
            ),
            const SizedBox(height: 20.0),
            CupertinoButton.filled(
              child: const Text('Push Directly to Page 2'),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute<void>(
                    builder: (BuildContext context) {
                      return CupertinoPageScaffold(
                        navigationBar: const CupertinoNavigationBar(
                          middle: Text('Page 2 of tab 1'),
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: const Text('Back'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

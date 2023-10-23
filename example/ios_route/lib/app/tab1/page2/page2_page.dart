import 'package:flutter/cupertino.dart';
import 'package:routefly/routefly.dart';

class Page2Page extends StatelessWidget {
  const Page2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Tab 1 PAGE 2'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CupertinoButton.filled(
                child: const Text('Back'),
                onPressed: () {
                  Routefly.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

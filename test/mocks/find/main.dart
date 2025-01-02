import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import 'main.route.dart';

part 'main.g.dart';

@Main('lib/app')
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    test();
    return const Placeholder();
  }
}

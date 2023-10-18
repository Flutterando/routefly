// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:routefly/src/usecases/generate_routes.dart';

Future<void> main(List<String> args) async {
  final flag = args.isEmpty ? '--generate' : args.first;

  final appDir = Directory('./lib/app');
  final routeFile = File('${appDir.parent.path}/routes.dart');

  final generate = GenerateRoutes(appDir, routeFile);

  Stream<ConsoleResponse>? stream;

  if (flag == '--generate') {
    stream = generate.call();
  } else if (flag == '--watch') {
    stream = _startWatch(generate, appDir);
  } else if (flag == '--init') {
    _init(generate, appDir);
    exit(0);
  }

  if (stream != null) {
    await for (var c in stream) {
      c.log();
    }
  }
}

Stream<ConsoleResponse> _startWatch(GenerateRoutes generate, Directory appDir) async* {
  yield* generate();
  yield const ConsoleResponse(message: '-- WATCHING --');
  yield* appDir
      .watch(events: FileSystemEvent.all, recursive: true) //
      .asyncExpand((event) => generate());
}

void _init(GenerateRoutes generate, Directory appDir) {
  final appWidget = File('${appDir.path}/app_widget.dart');
  final appPage = File('${appDir.path}/app_page.dart');

  if (appWidget.existsSync() || appPage.existsSync()) {
    return;
  }

  appWidget.createSync(recursive: true);
  appPage.createSync(recursive: true);

  appWidget.writeAsStringSync('''import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import '../routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routefly.routerConfig(
        routes: routes,
      ),
    );
  }
}
''');
  appPage.writeAsStringSync('''import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
''');

  generate();
}

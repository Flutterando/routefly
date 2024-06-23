import 'dart:io';

import 'package:routefly/src/usecases/generate_routes.dart';

Future<void> main(List<String> args) async {
  final flags = _listStringToMap(args);
  final runMode = _getRunMode(flags);

  final appDir = Directory(flags['app-dir'] ?? './lib/app');
  final routeFile = File('${appDir.parent.path}/routes.g.dart');

  final generate = GenerateRoutes(appDir, routeFile);

  Stream<ConsoleResponse>? stream;

  if (runMode == '--generate') {
    stream = generate.call();
  } else if (runMode == '--watch') {
    stream = _startWatch(generate, appDir);
  } else if (runMode == '--init') {
    _init(generate, appDir);
    exit(0);
  }

  if (stream != null) {
    await for (final c in stream) {
      c.log();
    }
  }
}

Map<String, dynamic> _listStringToMap(List<String> list) {
  final map = <String, dynamic>{};
  for (var i = 0; i < list.length; i++) {
    if (list[i].startsWith('--')) {
      if (!list[i].contains('=')) {
        map[list[i].substring(2)] = true;
        continue;
      }
      final key = list[i].substring(2, list[i].indexOf('='));
      final value = list[i].substring(list[i].indexOf('=') + 1);
      map[key] = value;
    }
  }
  return map;
}

String _getRunMode(Map<String, dynamic> flags) {
  if (flags['watch'] == true) return '--watch';
  if (flags['init'] == true) return '--init';
  return '--generate';
}

Stream<ConsoleResponse> _startWatch(
  GenerateRoutes generate,
  Directory appDir,
) async* {
  yield* generate();
  yield const ConsoleResponse(message: '-- WATCHING --');
  yield* appDir
      .watch(recursive: true) //
      .where(
        (event) =>
            event.path.endsWith('_page.dart') //
            ||
            event.path.endsWith('_layout.dart'),
      )
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

  appWidget.writeAsStringSync('''
import 'package:flutter/material.dart';
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
  appPage.writeAsStringSync('''
import 'package:flutter/material.dart';

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

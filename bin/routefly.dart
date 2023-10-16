import 'dart:io';

void main(List<String> args) {
  final flag = args.isEmpty ? '--generate' : args.first;
  final verbose = args.contains('--verbose');

  if (flag == '--generate') {
    _generate();
  } else if (flag == '--watch') {
    _watch(verbose);
  } else if (flag == '--init') {
    _init(verbose);
  }
}

void _init(bool verbose) {
  final dir = Directory('./lib/app');
  final appWidget = File('${dir.path}/app_widget.dart');
  final appPage = File('${dir.path}/app_page.dart');

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

  _generate();
}

void _watch(bool verbose) {
  final dir = Directory('./lib/app');

  _generate();
  dir.watch(events: FileSystemEvent.all, recursive: true).listen((event) {
    try {
      _generate();
      print('---WATCHING---');
    } catch (e) {
      if (verbose) {
        print(e);
      }
    }
  });
}

void _generate() {
  final dir = Directory('./lib/app');

  final files = dir
      .listSync(recursive: true) //
      .where((file) => file.path.endsWith('_page.dart'))
      .whereType<File>()
      .toList();

  final routeContent = files.map(_mapToEntity).join(',');

  final routeFileContent = '''${_generateImports(files)}
final routes = <RouteEntity>[
  $routeContent,
];''';

  final routeFile = File('./lib/routes.dart');
  routeFile.writeAsStringSync(routeFileContent);

  print('Routes Generated!🚀');
}

String _generateImports(List<File> files) {
  final imports = files //
      .map((file) => file.path.replaceFirst('./lib/', '').replaceAll('\\', '/'))
      .map((e) => "import '$e';")
      .join('\n');
  return '''import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

$imports
''';
}

String _mapToEntity(File file) {
  return '''RouteEntity(
    uri: Uri.parse('${_pathResolve(file)}'),
    ${_getPageOrRouteName(file)},
  )''';
}

String _getPageOrRouteName(File file) {
  final content = file.readAsLinesSync();
  final line = content.firstWhere((line) => line.contains(RegExp(r'class \w+Page ')));
  final routeBuilderLine = content.firstWhere((line) => line.contains('Route routeBuilder(BuildContext context, RouteSettings settings)'), orElse: () => '');
  final className = line.replaceFirst('class ', '').replaceFirst(RegExp(r' extends.+'), '');

  if (routeBuilderLine.isNotEmpty) {
    return 'routeBuilder: routeBuilder';
  }

  return '''routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const $className(),
    )''';
}

String _pathResolve(File file) {
  var path = file.path //
      .replaceFirst(RegExp(r'.+/app'), '');

  if (Platform.isWindows) {
    path = path.replaceAll('\\', '/');
  }

  path = (path.split('/')..removeLast()).join('/');

  return path.isEmpty ? '/' : path;
}

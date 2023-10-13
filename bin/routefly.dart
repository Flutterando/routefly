import 'dart:io';

void main(List<String> args) {
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

  print('Route Generated!🚀');
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
  path: '${_pathResolve(file)}',
  page: ${_getPageOrRouteName(file)},
)''';
}

String _getPageOrRouteName(File file) {
  final content = file.readAsLinesSync();
  final line = content.firstWhere((line) => line.contains(RegExp(r'class \w+Page ')));
  final className = line.replaceFirst('class ', '').replaceFirst(RegExp(r' extends.+'), '');

  if (line.contains('extends Page')) {
    return '$className()';
  }
  return 'const MaterialPage(child: $className())';
}

String _pathResolve(File file) {
  var path = file.path //
      .replaceFirst(RegExp(r'.+/app'), '');

  if (Platform.isWindows) {
    path = path.replaceAll('\\', '/');
  }

  path = (path.split('/')..removeLast()).join('/');

  return path;
}

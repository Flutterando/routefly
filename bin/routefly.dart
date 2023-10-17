// ignore_for_file: public_member_api_docs, sort_constructors_first
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
      .where((file) => file.path.endsWith('_page.dart') || file.path.endsWith('_layout.dart'))
      .whereType<File>()
      .toList();

  var entries = <RouteEntityEntry>[];

  for (var i = 0; i < files.length; i++) {
    entries.add(_mapToEntity(files[i], i));
  }

  entries = _addParents(entries);

  if (entries.isEmpty) {
    return;
  }

  final routeContent = entries.map((e) => e.toString()).join(',\n  ');

  final routeFileContent = '''${_generateImports(files)}
final routes = <RouteEntity>[
  $routeContent,
];''';

  final routeFile = File('./lib/routes.dart');
  routeFile.writeAsStringSync(routeFileContent);

  print('Routes Generated!🚀');
}

List<RouteEntityEntry> _addParents(List<RouteEntityEntry> entries) {
  final layouts = entries.where((e) => e.isLayout).toList();
  final entriesOrder = entries.toList()..sort((a, b) => a.path.compareTo(b.path));

  layouts.sort((a, b) => a.path.compareTo(b.path));

  for (var layout in layouts) {
    for (var i = 0; i < entriesOrder.length; i++) {
      var entry = entriesOrder[i];
      final isParent = entry.path.startsWith(layout.path) && layout.path != entry.path;
      entry = entry.copyWith(parent: isParent ? layout.path : '');
      entriesOrder[i] = entry;
    }
  }

  return entriesOrder;
}

RouteEntityEntry _mapToEntity(File file, int index) {
  final isLayout = file.path.endsWith('_layout.dart');
  final path = _pathResolve(file);
  final builder = _getBuilder(file, index);

  return RouteEntityEntry(
    isLayout: isLayout,
    path: path,
    builder: builder,
  );
}

String _generateImports(List<File> files) {
  final imports = files //
      .map(
        (file) => (file.path.replaceFirst('./lib/', '').replaceAll('\\', '/'), files.indexOf(file)),
      )
      .map((e) => "import '${e.$1}' as a${e.$2};")
      .join('\n');
  return '''import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

$imports
''';
}

String _getBuilder(File file, int index) {
  final content = file.readAsLinesSync();
  final line = content.firstWhere((line) => line.contains(RegExp(r'class \w+[(Page)|(Layout)] ')));
  final routeBuilderLine = content.firstWhere((line) => line.contains('Route routeBuilder(BuildContext context, RouteSettings settings)'), orElse: () => '');
  final className = line.replaceFirst('class ', '').replaceFirst(RegExp(r' extends.+'), '');

  if (routeBuilderLine.isNotEmpty) {
    return 'a$index.routeBuilder';
  }

  return '''(ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a$index.$className(),
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

class RouteEntityEntry {
  final String path;
  final String parent;
  final String builder;
  final bool isLayout;

  RouteEntityEntry({
    required this.path,
    this.parent = '',
    this.isLayout = false,
    required this.builder,
  });

  @override
  String toString() {
    return '''RouteEntity(
    key: '$path',
    parent: '$parent',
    uri: Uri.parse('$path'),
    routeBuilder: $builder,
  )''';
  }

  RouteEntityEntry copyWith({
    String? path,
    String? parent,
    String? builder,
    bool? isLayout,
  }) {
    return RouteEntityEntry(
      path: path ?? this.path,
      parent: parent ?? this.parent,
      builder: builder ?? this.builder,
      isLayout: isLayout ?? this.isLayout,
    );
  }
}

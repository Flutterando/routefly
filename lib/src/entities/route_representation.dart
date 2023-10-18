import 'dart:io';

import 'package:routefly/src/exceptions/exceptions.dart';

class RouteRepresentation {
  final String path;
  final String parent;
  final String builder;
  final bool isLayout;
  final File file;
  final int index;

  RouteRepresentation({
    required this.path,
    required this.file,
    this.parent = '',
    required this.index,
    this.isLayout = false,
    required this.builder,
  });

  static RouteRepresentation withAppDir(Directory appDir, File file, int index) {
    final isLayout = file.path.endsWith('_layout.dart');
    final path = _pathResolve(file, appDir);
    final builder = _getBuilder(file, index);

    return RouteRepresentation(
      isLayout: isLayout,
      path: path,
      builder: builder,
      file: file,
      index: index,
    );
  }

  static String _pathResolve(
    File file,
    Directory appDir,
  ) {
    var path = file.parent.path //
        .replaceFirst(appDir.path, '');

    if (Platform.isWindows) {
      path = path.replaceAll('\\', '/');
    }

    return path.isEmpty ? '/' : path;
  }

  static String _getBuilder(File file, int index) {
    final content = file.readAsLinesSync();

    for (var i = 0; i < content.length; i++) {
      var line = content[i];
      line = line.replaceFirst(RegExp(r'//.+'), '');
      content[i] = line;
    }

    final line = content.firstWhere(
      (line) => line.contains(RegExp(r'class \w+[(Page)|(Layout)] ')),
      orElse: () => '',
    );

    if (line.isEmpty) {
      throw RouteflyException(
        '${file.path.split(Platform.pathSeparator).last} don\'t contains Page or Layout Widget.',
      );
    }

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

  String get import {
    final path = file.path.replaceFirst('./lib/', '').replaceAll('\\', '/');
    return "import '$path' as a$index;";
  }

  @override
  String toString() {
    return '''RouteEntity(
    key: '$path',
    parent: '$parent',
    uri: Uri.parse('$path'),
    routeBuilder: $builder,
  )''';
  }

  RouteRepresentation copyWith({
    String? path,
    String? parent,
    String? builder,
    bool? isLayout,
    File? file,
    int? index,
  }) {
    return RouteRepresentation(
      path: path ?? this.path,
      file: file ?? this.file,
      parent: parent ?? this.parent,
      builder: builder ?? this.builder,
      isLayout: isLayout ?? this.isLayout,
      index: index ?? this.index,
    );
  }
}

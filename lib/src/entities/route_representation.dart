import 'dart:io';

import 'package:routefly/src/exceptions/exceptions.dart';

/// Represents a route in the application.
class RouteRepresentation {
  /// The path for the route.
  final String path;

  /// The parent path for nested routes.
  final String parent;

  /// The function used to build the route.
  final String builder;

  /// Determines if the route is a layout.
  final bool isLayout;

  /// The file containing the route representation.
  final File file;

  /// Index for managing route instances.
  final int index;

  /// Constructs a new [RouteRepresentation].
  ///
  /// Parameters:
  /// - [path]: The path for the route.
  /// - [file]: The file containing the route representation.
  /// - [parent]: The parent path for nested routes. Defaults to an
  /// empty string.
  /// - [index]: Index for managing route instances.
  /// - [isLayout]: Determines if the route is a layout. Defaults to false.
  /// - [builder]: The function used to build the route.
  RouteRepresentation({
    required this.path,
    required this.file,
    this.parent = '',
    required this.index,
    this.isLayout = false,
    required this.builder,
  });

  /// Constructs a [RouteRepresentation] based on an app directory.
  ///
  /// Parameters:
  /// - [appDir]: The application directory.
  /// - [file]: The file containing the route representation.
  /// - [index]: Index for managing route instances.
  static RouteRepresentation withAppDir(
    Directory appDir,
    File file,
    int index,
  ) {
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

  /// Resolves the path for the given [file] relative to [appDir].
  static String _pathResolve(
    File file,
    Directory appDir,
  ) {
    var path = file.parent.path.replaceFirst(appDir.path, '');

    if (Platform.isWindows) {
      path = path.replaceAll(r'\', '/');
    }

    path = path.replaceAll(RegExp(r'\(.*?\)/'), '/');

    return path.isEmpty ? '/' : path;
  }

  /// Fetches the builder function from the given [file].
  static String _getBuilder(File file, int index) {
    final content = file.readAsLinesSync();

    for (var i = 0; i < content.length; i++) {
      var line = content[i];
      line = line.replaceFirst(RegExp('//.+'), '');
      content[i] = line;
    }

    final line = content.firstWhere(
      (line) => line.contains(RegExp(r'class \w+[(Page)|(Layout)] ')),
      orElse: () => '',
    );

    if (line.isEmpty) {
      throw RouteflyException(
        '${file.path.split(Platform.pathSeparator).last} '
        "don't contains Page or Layout Widget.",
      );
    }

    final routeBuilderLine = content.firstWhere(
      (line) => line.contains(
        'Route routeBuilder(BuildContext context, RouteSettings settings)',
      ),
      orElse: () => '',
    );
    final className = line //
        .replaceFirst('class ', '')
        .replaceFirst(RegExp(' extends.+'), '');

    if (routeBuilderLine.isNotEmpty) {
      return 'a$index.routeBuilder';
    }

    return '''(ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a$index.$className(),
    )''';
  }

  /// Generates the import statement for the route.
  String get import {
    final path = file.path.replaceFirst('./lib/', '').replaceAll(r'\', '/');
    return "import '$path' as a$index;";
  }

  @override
  String toString() {
    return [
      'RouteEntity(',
      "    key: '$path',",
      if (parent.isNotEmpty) "    parent: '$parent',",
      "    uri: Uri.parse('$path'),",
      '    routeBuilder: $builder,',
      '  )',
    ].join('\n');
  }

  /// Returns a copy of the current [RouteRepresentation] with
  /// optional modifications.
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

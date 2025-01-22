import 'dart:io';

import 'package:meta/meta.dart';
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

  /// The function used to build the route.
  final String routeBuilderFunction;

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
    this.routeBuilderFunction = '',
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
    String widgetSuffix,
    File file,
    int index,
  ) {
    final isLayout = file.path.endsWith('layout.dart');
    final path = pathResolve(file, appDir);
    final routeBuilderFunction = _getBuilder(file, widgetSuffix, index);
    final builder = 'b${index}Builder';

    return RouteRepresentation(
      isLayout: isLayout,
      path: path,
      builder: builder,
      routeBuilderFunction: routeBuilderFunction,
      file: file,
      index: index,
    );
  }

  /// Resolves the path for the given [file] relative to [appDir].
  @visibleForTesting
  static String pathResolve(
    File file,
    Directory appDir,
  ) {
    var path = file.path;

    if (Platform.isWindows) {
      path = path.replaceAll(r'\', '/');
    }

    path = path
        .split('/') //
        .where((e) => !RegExp(r'\(.+\)').hasMatch(e))
        .join('/');

    path = _removeSuffix(path);
    path = path.replaceFirst(appDir.path, '');

    return path.isEmpty ? '/' : path;
  }

  static String _removeSuffix(String path) {
    // Remover sufixo
    var newPath = path.replaceAll(RegExp(r'(_page|_layout)\.dart$'), '');

    // Remover duplicação após a última barra
    final lastPart = newPath.split('/').last;
    if (newPath.endsWith('/$lastPart/$lastPart')) {
      newPath = newPath.replaceAll(RegExp('/$lastPart\$'), '');
    }

    return newPath;
  }

  /// Fetches the builder function from the given [file].
  static String _getBuilder(File file, String widgetSuffix, int index) {
    final content = file.readAsLinesSync();

    for (var i = 0; i < content.length; i++) {
      var line = content[i];
      line = line.replaceFirst(RegExp('//.+'), '');
      content[i] = line;
    }

    final line = content.firstWhere(
      (line) => line.contains(RegExp('class \\w+[($widgetSuffix)|(Layout)] ')),
      orElse: () => '',
    );

    if (line.isEmpty) {
      throw RouteflyException(
        "'${file.path.replaceAll(r'\', '/')}' "
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
      return 'Route b${index}Builder(BuildContext context, RouteSettings settings) => a$index.routeBuilder(context, settings);';
    }

    return '''Route b${index}Builder(BuildContext ctx, RouteSettings settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a$index.$className(),
    );''';
  }

  /// Generates the import statement for the route.
  String getImport(String mainFilePath) {
    final parent = File(mainFilePath).parent.path.replaceAll(r'\', '/');
    final fixPath = parent.isEmpty ? '${Platform.pathSeparator}lib/' : '$parent/';
    final path = file.path.replaceFirst(fixPath, '').replaceAll(r'\', '/');
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
    String? routeBuilderFunction,
    String? widgetSuffix,
  }) {
    return RouteRepresentation(
      path: path ?? this.path,
      file: file ?? this.file,
      parent: parent ?? this.parent,
      builder: builder ?? this.builder,
      isLayout: isLayout ?? this.isLayout,
      index: index ?? this.index,
      routeBuilderFunction: routeBuilderFunction ?? this.routeBuilderFunction,
    );
  }
}

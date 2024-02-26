/// Route generation utility for Routefly package.
///
/// This script automates the process of generating routes for
/// a Flutter application using the Routefly package.

import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:meta/meta.dart';
import 'package:routefly/src/exceptions/exceptions.dart';

import '../entities/route_representation.dart';

/// Constants for error messages visible for testing.
@visibleForTesting
const errorMessages = (
  notFoundDirApp: 'AppDir not exists😢',
  noRoutesCreated: 'No routes created😒',
);

/// Class to generate routes.
@immutable
class GenerateRoutes {
  /// Directory default is lib/app
  final Directory appDir;

  /// route.dart file default is lib/routes.dart
  final File routeFile;

  /// Constructs a [GenerateRoutes] instance.
  const GenerateRoutes(this.appDir, this.routeFile);

  /// Generates routes based on the given app directory and route file.
  Stream<ConsoleResponse> call() async* {
    if (!appDir.existsSync()) {
      yield ConsoleResponse(
        message: errorMessages.notFoundDirApp,
        type: ConsoleResponseType.error,
      );
      return;
    }

    final files = appDir
        .listSync(recursive: true) //
        .where(
          (file) =>
              file.path.endsWith('_page.dart') //
              ||
              file.path.endsWith('_layout.dart'),
        )
        .whereType<File>()
        .toList();

    if (files.isEmpty) {
      yield ConsoleResponse(
        message: errorMessages.noRoutesCreated,
      );
      return;
    }

    final entries = <RouteRepresentation>[];

    for (var i = 0; i < files.length; i++) {
      try {
        entries.add(RouteRepresentation.withAppDir(appDir, files[i], i));
      } on RouteflyException catch (e) {
        yield ConsoleResponse(
          message: e.message,
          type: ConsoleResponseType.warning,
        );
      }
    }

    _addParents(entries);
    final paths = entries.map((e) => e.path).toList();

    final routeContent = entries.map((e) => e.toString()).join(',\n  ');

    final routeFileContent = '''${_generateImports(entries)}
List<RouteEntity> get routes => [
  $routeContent,
];

${generateRecords(paths)}''';

    routeFile.writeAsStringSync(routeFileContent);

    yield const ConsoleResponse(
      message: 'Generated! lib/routes.dart 🚀',
      type: ConsoleResponseType.success,
    );
  }

  /// Generates records for the given paths.
  @visibleForTesting
  String generateRecords(List<String> paths) {
    final mapPaths = _transformToMap(paths);
    final pathBuffer = StringBuffer();

    pathBuffer.writeln('const routePaths = (');
    pathBuffer.writeln(_generateRoutePaths(mapPaths));
    pathBuffer.writeln(');');

    return pathBuffer.toString();
  }

  String _generateRoutePaths(
    Map<String, dynamic> jsonMap, [
    String prefix = '',
    int depth = 1,
  ]) {
    final output = <String>[];

    if (jsonMap.isNotEmpty && !jsonMap.containsKey('path')) {
      output.add(
        "${_indentation(depth)}path: '${prefix.isEmpty ? '/' : prefix}',",
      );
    }

    jsonMap.forEach((key, value) {
      var newKey = key == 'path'
          ? 'path'
          : key //
              .replaceAll('[', r'$')
              .replaceAll(']', '');
      newKey = snackCaseToCamelCase(newKey);
      if (value.isEmpty) {
        output.add("${_indentation(depth)}$newKey: '$prefix/$key',");
      } else {
        final nested = _generateRoutePaths(value, '$prefix/$key', depth + 1);
        output.add(
          '${_indentation(depth)}$newKey: (\n$nested\n${_indentation(depth)}),',
        );
      }
    });

    return output.join('\n');
  }

  /// Converts snake_case to camelCase.
  String snackCaseToCamelCase(String key) {
    final segments = key.split('_');
    final firstSegment = segments.first;
    final restSegments = segments.sublist(1);
    final camelCaseSegments = restSegments
        .map((segment) => segment[0].toUpperCase() + segment.substring(1));
    return firstSegment + camelCaseSegments.join();
  }

  String _indentation(int depth) {
    return '  ' * depth;
  }

  Map<String, dynamic> _transformToMap(List<String> paths) {
    final resultMap = <String, dynamic>{};

    for (final path in paths) {
      final segments = path //
          .split('/')
          .where((segment) => segment.isNotEmpty)
          .toList();

      var currentMap = resultMap;
      for (var i = 0; i < segments.length; i++) {
        final segment = segments[i];

        if (currentMap[segment] == null) {
          if (i == segments.length - 1) {
            currentMap[segment] = <String, dynamic>{};
          } else {
            currentMap[segment] = <String, dynamic>{};
            currentMap = currentMap[segment]!;
          }
        } else {
          currentMap = currentMap[segment];
        }
      }
    }

    return resultMap;
  }

  void _addParents(List<RouteRepresentation> routes) {
    final layoutPaths = routes //
        .where((route) => route.isLayout)
        .map((route) => route.path)
        .toList();

    for (var i = 0; i < routes.length; i++) {
      final route = routes[i];
      for (final layoutPath in layoutPaths) {
        var pathCondition = layoutPath;
        if (layoutPath != '/') {
          pathCondition = '$layoutPath/';
        }
        if (route.path != layoutPath //
            &&
            route.path.startsWith(pathCondition)) {
          routes[i] = route.copyWith(parent: layoutPath);
          break;
        }
      }
    }
  }

  String _generateImports(List<RouteRepresentation> entries) {
    final imports = entries.map((e) => e.import).toList();
    imports.sort((a, b) => a.compareTo(b));
    final importsText = imports.join('\n');
    return '''import 'package:routefly/routefly.dart';

$importsText
''';
  }
}

/// Class to represent console response.
@immutable
class ConsoleResponse {
  /// Message to be displayed.
  final String message;

  /// Type of the message.
  final ConsoleResponseType type;

  /// Constructs a [ConsoleResponse] instance.
  const ConsoleResponse({
    required this.message,
    this.type = ConsoleResponseType.info,
  });

  /// Logs the console response.
  void log() {
    AnsiPen? pen;

    if (type == ConsoleResponseType.info) {
      pen = AnsiPen()
        ..reset()
        ..xterm(13);
    } else if (type == ConsoleResponseType.success) {
      pen = AnsiPen()
        ..reset()
        ..xterm(10);
    } else if (type == ConsoleResponseType.warning) {
      pen = AnsiPen()
        ..reset()
        ..xterm(3);
    } else if (type == ConsoleResponseType.error) {
      pen = AnsiPen()
        ..reset()
        ..xterm(9);
    }

    print(pen?.call(message));
  }

  @override
  bool operator ==(covariant ConsoleResponse other) {
    if (identical(this, other)) return true;

    return other.message == message && other.type == type;
  }

  @override
  int get hashCode => message.hashCode ^ type.hashCode;

  @override
  String toString() => 'ConsoleResponse(message: $message, type: $type)';
}

/// Enum for types of console responses.
/// Used to color the console output.
enum ConsoleResponseType {
  /// Error type.
  error,

  /// Success type.
  success,

  /// Info type.
  info,

  /// Warning type.
  warning,
}

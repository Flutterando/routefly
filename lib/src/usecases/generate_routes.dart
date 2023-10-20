// ignore_for_file: public_member_api_docs, sort_constructors_first,
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:routefly/src/exceptions/exceptions.dart';

import '../entities/route_representation.dart';

const errorMessages = (
  notFoundDirApp: 'AppDir not exists😢',
  noRoutesCreated: 'No routes created😒',
);

typedef RecordObject = ({
  String key,
  String parent,
  String path,
  String? specialKey,
});

class GenerateRoutes {
  final Directory appDir;
  final File routeFile;

  const GenerateRoutes(this.appDir, this.routeFile);

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

    var entries = <RouteRepresentation>[];

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

    entries = _addParents(entries);
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

  String generateRecords(List<String> paths) {
    final mapPaths = _transformToMap(paths);
    final pathBuffer = StringBuffer();

    pathBuffer.writeln('const routePaths = (');
    pathBuffer.writeln(_generateRoutePaths(mapPaths));
    pathBuffer.writeln(');');

    return pathBuffer.toString();
  }

  String _generateRoutePaths(Map<String, dynamic> jsonMap, [String prefix = '', int depth = 1]) {
    final output = <String>[];

    // Adicionando a chave path sempre que houver sub-rotas
    if (jsonMap.isNotEmpty && !jsonMap.containsKey('path')) {
      output.add(
        "${_indentation(depth)}path: '${prefix.isEmpty ? '/' : prefix}',",
      );
    }

    jsonMap.forEach((key, value) {
      final newKey = key == 'path' ? 'path' : key.replaceAll('[', r'$').replaceAll(']', '');
      if (value.isEmpty) {
        output.add("${_indentation(depth)}$newKey: '$prefix/$key',");
      } else {
        final nested = _generateRoutePaths(value, '$prefix/$key', depth + 1);
        output.add('${_indentation(depth)}$newKey: (\n$nested\n${_indentation(depth)}),');
      }
    });

    return output.join('\n');
  }

  String _indentation(int depth) {
    return '  ' * depth;
  }

  Map<String, dynamic> _transformToMap(List<String> paths) {
    final resultMap = <String, dynamic>{};

    for (final path in paths) {
      final segments = path.split('/').where((segment) => segment.isNotEmpty).toList();

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

  List<RouteRepresentation> _addParents(List<RouteRepresentation> entries) {
    final layouts = entries.where((e) => e.isLayout).toList();
    final entriesOrder = entries.toList()
      ..sort(
        (a, b) => a.path.compareTo(b.path),
      );

    layouts.sort((a, b) => a.path.compareTo(b.path));

    for (final layout in layouts) {
      for (var i = 0; i < entriesOrder.length; i++) {
        var entry = entriesOrder[i];
        final isParent = entry.path //
                .startsWith(layout.path) &&
            layout.path != entry.path;
        entry = entry.copyWith(parent: isParent ? layout.path : '');
        entriesOrder[i] = entry;
      }
    }

    return entriesOrder;
  }

  String _generateImports(List<RouteRepresentation> entries) {
    final imports = entries.map((e) => e.import).toList();
    imports.sort((a, b) => a.compareTo(b));
    final importsText = imports.join('\n');
    return '''import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

$importsText
''';
  }
}

class ConsoleResponse {
  final String message;
  final ConsoleResponseType type;

  const ConsoleResponse({
    required this.message,
    this.type = ConsoleResponseType.info,
  });

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

enum ConsoleResponseType { error, success, info, warning }

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:routefly/src/exceptions/exceptions.dart';

import '../entities/route_representation.dart';

const errorMessages = (
  notFoundDirApp: 'AppDir not exists😢',
  noRoutesCreated: 'No routes created😒',
);

class GenerateRoutes {
  final Directory appDir;
  final File routeFile;

  GenerateRoutes(this.appDir, this.routeFile);

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
        .where((file) => file.path.endsWith('_page.dart') || file.path.endsWith('_layout.dart'))
        .whereType<File>()
        .toList();

    if (files.isEmpty) {
      yield ConsoleResponse(
        message: errorMessages.noRoutesCreated,
        type: ConsoleResponseType.info,
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

    final routeContent = entries.map((e) => e.toString()).join(',\n  ');

    final routeFileContent = '''${_generateImports(entries)}
List<RouteEntity> get routes => [
  $routeContent,
];''';

    routeFile.writeAsStringSync(routeFileContent);

    yield const ConsoleResponse(
      message: 'Generated! lib/routes.dart 🚀',
      type: ConsoleResponseType.success,
    );
  }

  List<RouteRepresentation> _addParents(List<RouteRepresentation> entries) {
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

  String _generateImports(List<RouteRepresentation> entries) {
    final imports = entries //
        .map((e) => e.import)
        .join('\n');
    return '''import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

$imports
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
}

enum ConsoleResponseType { error, success, info, warning }

import 'dart:io';

import 'package:meta/meta.dart';
import 'package:routefly/src/entities/main_file_entity.dart';
import 'package:routefly/src/usecases/generate_routes.dart';

(MainFileEntity?, ConsoleResponse?) _result({
  MainFileEntity? mainFile,
  ConsoleResponse? response,
}) {
  return (mainFile, response);
}

class FindMainFile {
  const FindMainFile();

  (MainFileEntity?, ConsoleResponse?) call(Directory appDir) {
    final mainFile = findMainFile(appDir);
    if (mainFile == null) {
      return _result(
        response: ConsoleResponse(
          message: errorMessages.noMainFile,
          type: ConsoleResponseType.error,
        ),
      );
    }

    final baseDir = getBasePath(mainFile);
    return _result(
      mainFile: MainFileEntity(
        noExtensionFilePath: _removeExtension(mainFile.path),
        appDir: baseDir,
        fileName: _fileNameGenerated(mainFile, ''),
      ),
    );
  }

  @visibleForTesting
  File? findMainFile(Directory appDir) {
    return appDir //
        .listSync(recursive: true)
        .where((entity) => entity is File && entity.path.endsWith('.dart'))
        .cast<File?>()
        .firstWhere(validateMainFile, orElse: () => null);
  }

  @visibleForTesting
  Directory getBasePath(File mainFile) {
    final content = mainFile.readAsStringSync();
    final regex = RegExp(r'@Main\((.*)\)');
    final match = regex.firstMatch(content);
    final basePath = match //
        ?.group(1)
        ?.replaceAll('"', '')
        .replaceAll("'", '')
        .trim();
    return Directory(basePath ?? 'lib/');
  }

  @visibleForTesting
  bool validateMainFile(File? mainFile) {
    final content = mainFile!.readAsStringSync();

    final mainAnnotationMatch = RegExp(r'@Main\(.*\)');
    if (!mainAnnotationMatch.hasMatch(content)) {
      return false;
    }

    final hasRouteflyImport = content.contains("import 'package:routefly/routefly.dart';");
    if (!hasRouteflyImport) {
      return false;
    }

    final routeImport = content.contains("import '${_fileNameGenerated(mainFile, '.route.dart')}';");
    if (!routeImport) {
      return false;
    }

    final expectedPart = _fileNameGenerated(mainFile);
    final hasCorrectPart = content.contains(expectedPart);
    if (!hasCorrectPart) {
      return false;
    }

    return true;
  }

  String _fileNameGenerated(File mainFile, [String ext = '.g.dart']) {
    final fileName = mainFile.path.split(Platform.pathSeparator).last;
    return fileName.replaceAll('.dart', ext);
  }

  String _removeExtension(String path) {
    return path.replaceAll('.dart', '');
  }

  String _pathToGeneratedFile(File mainFile) {
    final fileName = mainFile.path.split(Platform.pathSeparator).last;
    final newFileName = _fileNameGenerated(mainFile);
    return mainFile.path.replaceFirst(fileName, newFileName);
  }
}

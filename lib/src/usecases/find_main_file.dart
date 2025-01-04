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

/// Find the main file of the project
class FindMainFile {
  /// Find the main file of the project
  const FindMainFile();

  /// Find the main file of the project
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

    final (baseDir, pageSuffix) = getAnnotationInfos(mainFile);
    return _result(
      mainFile: MainFileEntity(
        noExtensionFilePath: _removeExtension(mainFile.path),
        appDir: baseDir,
        pageSuffix: pageSuffix,
        fileName: _fileNameGenerated(mainFile, ''),
      ),
    );
  }

  /// Find the main file of the project
  @visibleForTesting
  File? findMainFile(Directory appDir) {
    return appDir //
        .listSync(recursive: true)
        .where((entity) => entity is File && entity.path.endsWith('.dart'))
        .cast<File?>()
        .firstWhere(validateMainFile, orElse: () => null);
  }

  /// Get the base path of the project
  @visibleForTesting
  (Directory, String) getAnnotationInfos(File mainFile) {
    final content = mainFile.readAsStringSync();
    final regex = RegExp(r'@Main\(\s*([^,)]*)\s*(?:,\s*([^)]*)\s*)?\)');

    final match = regex.firstMatch(content);
    final basePath = match //
            ?.group(1)
            ?.replaceAll('"', '')
            .replaceAll("'", '')
            .trim() ??
        'lib/app/';

    final pageSuffix = match //
            ?.group(2)
            ?.replaceAll('"', '')
            .replaceAll("'", '')
            .trim() ??
        'page';

    return (
      Directory(basePath.isEmpty ? 'lib/app/' : basePath),
      pageSuffix.isEmpty ? 'page' : pageSuffix,
    );
  }

  /// Validate if the file has the correct annotation and imports
  @visibleForTesting
  bool validateMainFile(File? mainFile) {
    final content = mainFile!.readAsStringSync();

    final mainAnnotationMatch = RegExp(r'@Main\(.*\)');
    if (!mainAnnotationMatch.hasMatch(content)) {
      return false;
    }

    final routeImport = content //
        .contains("import '${_fileNameGenerated(mainFile, '.route.dart')}';");
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
}

import 'dart:io';

class MainFileEntity {
  final String fileName;
  final String noExtensionFilePath;
  final Directory appDir;
  final String pageSuffix;

  MainFileEntity({
    required this.fileName,
    required this.noExtensionFilePath,
    required this.appDir,
    required this.pageSuffix,
  });
}

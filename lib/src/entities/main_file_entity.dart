import 'dart:io';

class MainFileEntity {
  final String fileName;
  final String noExtensionFilePath;
  final Directory appDir;

  MainFileEntity({
    required this.fileName,
    required this.noExtensionFilePath,
    required this.appDir,
  });
}

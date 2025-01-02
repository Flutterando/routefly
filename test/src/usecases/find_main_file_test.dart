import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/usecases/find_main_file.dart';

void main() {
  test('get MainFileEntity', () async {
    final (mainFile, console) = const FindMainFile().call(Directory('./test/mocks/find'));

    expect(console, null);
    expect(mainFile?.noExtensionFilePath, './test/mocks/find/main');
    expect(mainFile?.appDir.path, 'lib/app');
  });

  test('Find file by Meta @Main', () async {
    final file = const FindMainFile().findMainFile(Directory('./test/mocks/find/'));
    expect(file?.path, './test/mocks/find/main.dart');
  });

  test('Get basePath from @Main', () async {
    final dir = const FindMainFile().getBasePath(File('./test/mocks/find/main.dart'));
    expect(dir.path, 'lib/app');
  });
}

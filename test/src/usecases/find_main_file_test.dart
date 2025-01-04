import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/usecases/find_main_file.dart';

class FileMock extends Fake implements File {
  final String mockText;

  FileMock(this.mockText);

  @override
  String readAsStringSync({Encoding encoding = utf8}) {
    return mockText;
  }
}

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

  group('get annotation infos | ', () {
    test('Get basePath, suffix from @Main', () async {
      final (baseDir, suffix) = const FindMainFile().getAnnotationInfos(FileMock('@Main("lib/ui/", "view")'));

      expect(baseDir.path, 'lib/ui/');
      expect(suffix, 'view');
    });

    test('Get basePath from @Main only baseDir', () async {
      final (baseDir, suffix) = const FindMainFile().getAnnotationInfos(FileMock('    @Main("lib/ui/")'));

      expect(baseDir.path, 'lib/ui/');
      expect(suffix, 'page');
    });

    test('Get basePath from @Main withless params', () async {
      final (baseDir, suffix) = const FindMainFile().getAnnotationInfos(FileMock('@Main()'));

      expect(baseDir.path, 'lib/app/');
      expect(suffix, 'page');
    });
  });
}

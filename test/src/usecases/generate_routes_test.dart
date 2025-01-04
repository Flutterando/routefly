import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/entities/main_file_entity.dart';
import 'package:routefly/src/entities/route_representation.dart';
import 'package:routefly/src/usecases/generate_routes.dart';

class FileMock implements File {
  String contents = '';

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }

  @override
  void writeAsStringSync(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) {
    this.contents = contents;
  }
}

void main() {
  group('pathResolve', () {
    test('pathResolve with index page', () {
      final file = File('./test/mocks/app/dashboard/option1/option1_page.dart');
      final appDir = Directory('./test/mocks/app');
      final path = RouteRepresentation.pathResolve(file, appDir);

      expect(path, '/dashboard/option1');
    });

    test('pathResolve page', () {
      final file = File('./test/mocks/app/dashboard/option1_page.dart');
      final appDir = Directory('./test/mocks/app');
      final path = RouteRepresentation.pathResolve(file, appDir);

      expect(path, '/dashboard/option1');
    });

    test('pathResolve with index layout', () {
      final file = File('./test/mocks/app/dashboard/option1/option1_layout.dart');
      final appDir = Directory('./test/mocks/app');
      final path = RouteRepresentation.pathResolve(file, appDir);

      expect(path, '/dashboard/option1');
    });

    test('pathResolve layout', () {
      final file = File('./test/mocks/app/dashboard/option1_layout.dart');
      final appDir = Directory('./test/mocks/app');
      final path = RouteRepresentation.pathResolve(file, appDir);

      expect(path, '/dashboard/option1');
    });

    test('pathResolve page with group', () {
      final file = File('./test/mocks/app/(dashboard)/option1_page.dart');
      final appDir = Directory('./test/mocks/app');
      final path = RouteRepresentation.pathResolve(file, appDir);

      expect(path, '/option1');
    });

    test('pathResolve initial page', () {
      final file = File('./test/mocks/app/app_page.dart');
      final appDir = Directory('./test/mocks/app');
      final path = RouteRepresentation.pathResolve(file, appDir);

      expect(path, '/');
    });
  });

  test('snack case to camel', () {
    const usecase = GenerateRoutes();

    expect(usecase.snackCaseToCamelCase('test_camel_case'), 'testCamelCase');
    expect(usecase.snackCaseToCamelCase('test_one'), 'testOne');
    expect(usecase.snackCaseToCamelCase('test'), 'test');
  });

  test('Generate routePahtStrings', () {
    const usecase = GenerateRoutes();
    final paths = <String>[
      '/',
      '/dashboard',
      '/product',
      '/user',
      '/user/[id]',
      '/dashboard/option1',
      '/dashboard/option2',
      '/dashboard/option3',
      '/dashboard/option4',
      '/test_camel_case',
    ];
    final text = usecase.generateRecords(paths);

    expect(text, r'''const routePaths = (
  path: '/',
  dashboard: (
    path: '/dashboard',
    option1: '/dashboard/option1',
    option2: '/dashboard/option2',
    option3: '/dashboard/option3',
    option4: '/dashboard/option4',
  ),
  product: '/product',
  user: (
    path: '/user',
    $id: '/user/[id]',
  ),
  testCamelCase: '/test_camel_case',
);
''');
  });

  test('return message if appDir not exists', () {
    final notExistsDir = Directory('./test2');
    const usecase = GenerateRoutes();
    final stream = usecase.call(
      MainFileEntity(
        appDir: notExistsDir,
        fileName: '',
        noExtensionFilePath: '',
        pageSuffix: '',
      ),
    );

    final response = ConsoleResponse(
      message: errorMessages.notFoundDirApp,
      type: ConsoleResponseType.error,
    );

    expect(stream, emits(response));
  });
}

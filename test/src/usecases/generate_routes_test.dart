import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
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
  final appDir = Directory('./test/mocks/app');
  final routeFile = FileMock();

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
    final usecase = GenerateRoutes(appDir, routeFile);

    expect(usecase.snackCaseToCamelCase('test_camel_case'), 'testCamelCase');
    expect(usecase.snackCaseToCamelCase('test_one'), 'testOne');
    expect(usecase.snackCaseToCamelCase('test'), 'test');
  });

  test('Generate routePahtStrings', () {
    final notExistsDir = Directory('./test2');
    final usecase = GenerateRoutes(notExistsDir, routeFile);
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
    final usecase = GenerateRoutes(notExistsDir, routeFile);
    final stream = usecase.call();

    final response = ConsoleResponse(
      message: errorMessages.notFoundDirApp,
      type: ConsoleResponseType.error,
    );

    expect(stream, emits(response));
  });

  test('return message if files is empty', () {
    final existsDir = Directory('./test/mocks/app2');
    final usecase = GenerateRoutes(existsDir, routeFile);
    final response = ConsoleResponse(
      message: errorMessages.noRoutesCreated,
    );

    final stream = usecase.call();

    expect(stream, emits(response));
  });

  test('Generate Routes', () async {
    final usecase = GenerateRoutes(appDir, routeFile);
    final stream = usecase.call();

    await expectLater(
      stream,
      emitsInOrder([
        const ConsoleResponse(
          message: "'./test/mocks/app/dashboard/option4/option4_page.dart' don't contains Page or Layout Widget.",
          type: ConsoleResponseType.warning,
        ),
        const ConsoleResponse(
          message: 'Generated! lib/routes.dart 🚀',
          type: ConsoleResponseType.success,
        ),
      ]),
    );

    expect(routeFile.contents, routeFileContents);
  });
}

const routeFileContents = '''import 'package:routefly/routefly.dart';

import './test/mocks/app/app_page.dart' as a0;
import './test/mocks/app/dashboard/dashboard_layout.dart' as a1;
import './test/mocks/app/dashboard/option1/option1_page.dart' as a2;
import './test/mocks/app/dashboard/option2/option2_page.dart' as a3;
import './test/mocks/app/dashboard/option3/option3_page.dart' as a4;
import './test/mocks/app/dashboard2/dashboard2_layout.dart' as a6;
import './test/mocks/app/dashboard2/option1_page.dart' as a7;
import './test/mocks/app/dashboard2/option2_page.dart' as a8;
import './test/mocks/app/dashboard2/option3_page.dart' as a9;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a0.AppPage(),
    ),
  ),
  RouteEntity(
    key: '/dashboard',
    uri: Uri.parse('/dashboard'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a1.DashboardLayout(),
    ),
  ),
  RouteEntity(
    key: '/dashboard/option1',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option1'),
    routeBuilder: a2.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option2',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option2'),
    routeBuilder: a3.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option3',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option3'),
    routeBuilder: a4.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard2',
    uri: Uri.parse('/dashboard2'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a6.DashboardLayout(),
    ),
  ),
  RouteEntity(
    key: '/dashboard2/option1',
    parent: '/dashboard2',
    uri: Uri.parse('/dashboard2/option1'),
    routeBuilder: a7.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard2/option2',
    parent: '/dashboard2',
    uri: Uri.parse('/dashboard2/option2'),
    routeBuilder: a8.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard2/option3',
    parent: '/dashboard2',
    uri: Uri.parse('/dashboard2/option3'),
    routeBuilder: a9.routeBuilder,
  ),
];

const routePaths = (
  path: '/',
  dashboard: (
    path: '/dashboard',
    option1: '/dashboard/option1',
    option2: '/dashboard/option2',
    option3: '/dashboard/option3',
  ),
  dashboard2: (
    path: '/dashboard2',
    option1: '/dashboard2/option1',
    option2: '/dashboard2/option2',
    option3: '/dashboard2/option3',
  ),
);
''';

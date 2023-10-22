import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
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
    ];
    final text = usecase.generateRecords(paths);

    expect(text, r'''const routePaths = (
  path: '/',
  dashboard: (
    path: '/dashboard',
    option1: '/dashboard/option1',
    option2: '/dashboard/option2',
    option3: '/dashboard/option3',
  ),
  product: '/product',
  user: (
    path: '/user',
    $id: '/user/[id]',
  ),
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
          message: "option4_page.dart don't contains Page or Layout Widget.",
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

const routeFileContents = '''import 'package:flutter/material.dart';
import 'package:routefly/routefly.dart';

import './test/mocks/app/app_page.dart' as a5;
import './test/mocks/app/dashboard/dashboard_layout.dart' as a2;
import './test/mocks/app/dashboard/option1/option1_page.dart' as a0;
import './test/mocks/app/dashboard/option2/option2_page.dart' as a1;
import './test/mocks/app/dashboard/option3/option3_page.dart' as a3;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a5.AppPage(),
    ),
  ),
  RouteEntity(
    key: '/dashboard',
    uri: Uri.parse('/dashboard'),
    routeBuilder: (ctx, settings) => Routefly.defaultRouteBuilder(
      ctx,
      settings,
      const a2.DashboardLayout(),
    ),
  ),
  RouteEntity(
    key: '/dashboard/option1',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option1'),
    routeBuilder: a0.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option2',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option2'),
    routeBuilder: a1.routeBuilder,
  ),
  RouteEntity(
    key: '/dashboard/option3',
    parent: '/dashboard',
    uri: Uri.parse('/dashboard/option3'),
    routeBuilder: a3.routeBuilder,
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
);
''';

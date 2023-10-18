import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/usecases/generate_routes.dart';

class FileMock implements File {
  var contents = '';

  @override
  noSuchMethod(Invocation invocation) {
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
      type: ConsoleResponseType.info,
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
          message: 'option4_page.dart don\'t contains Page or Layout Widget.',
          type: ConsoleResponseType.warning,
        ),
        const ConsoleResponse(
          message: 'Routes Generated!🚀',
          type: ConsoleResponseType.success,
        ),
      ]),
    );

    expect(routeFile.contents, routeFileContents);
  });
}

const routeFileContents =
    '''import 'package:routefly/routefly.dart';
import 'package:flutter/material.dart';

import './test/mocks/app/app_page.dart' as a0;
import './test/mocks/app/dashboard/dashboard_layout.dart' as a1;
import './test/mocks/app/dashboard/option1/option1_page.dart' as a2;
import './test/mocks/app/dashboard/option2/option2_page.dart' as a3;
import './test/mocks/app/dashboard/option3/option3_page.dart' as a4;

List<RouteEntity> get routes => [
  RouteEntity(
    key: '/',
    parent: '',
    uri: Uri.parse('/'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a0.AppPage(),
    ),
  ),
  RouteEntity(
    key: '/dashboard',
    parent: '',
    uri: Uri.parse('/dashboard'),
    routeBuilder: (ctx, settings) => MaterialPageRoute(
      settings: settings,
      builder: (context) => const a1.DashboardLayout(),
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
];''';

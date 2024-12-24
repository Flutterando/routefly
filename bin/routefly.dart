import 'dart:io';

import 'package:routefly/src/usecases/find_main_file.dart';
import 'package:routefly/src/usecases/generate_routes.dart';

Future<void> main(List<String> args) async {
  final flag = args.isEmpty ? '--generate' : args.first;

  const findMainFile = FindMainFile();
  const generate = GenerateRoutes();

  Stream<ConsoleResponse>? stream;

  if (flag == '--generate') {
    final (mainFile, console) = findMainFile.call(Directory('lib'));
    if (console != null) {
      console.log();
      exit(1);
    }
    stream = generate.call(mainFile!);
  } else if (flag == '--watch') {
    stream = _startWatch(generate, findMainFile);
  }

  if (stream != null) {
    await for (final c in stream) {
      c.log();
    }
  }
}

Stream<ConsoleResponse> _startWatch(
  GenerateRoutes generate,
  FindMainFile find,
) async* {
  final lib = Directory('lib');
  final (mainFile, console) = find.call(lib);
  if (console != null) {
    yield console;
  }

  if (mainFile != null) {
    yield* generate(mainFile);
  }
  yield const ConsoleResponse(message: '-- WATCHING --');
  yield* lib
      .watch(recursive: true) //
      .where(
        (event) =>
            event.path.endsWith('_page.dart') //
            ||
            event.path.endsWith('_layout.dart'),
      )
      .asyncExpand((event) async* {
    final (mainFile, console) = find.call(lib);
    if (console != null) {
      yield console;
    }

    if (mainFile != null) {
      yield* generate(mainFile);
    }
  });
}

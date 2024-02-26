import 'package:flutter_test/flutter_test.dart';
import 'package:routefly/src/navigation/url_service/url_service.dart';

void main() {
  group('html url service ...', () {
    test('create', () {
      final urlService = UrlService.create();
      expect(urlService.getPath(), isA<void>());
    });
    test('create', () {
      final urlService = UrlService.create();
      final path = urlService.resolvePath(
        'https://dart.dev/guides/libraries/library-tour#numbers',
      );
      expect(path, isA<String>());
    });
  });
}

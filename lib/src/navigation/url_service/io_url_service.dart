// ignore_for_file: public_member_api_docs

import 'url_service.dart';

class IOUrlService extends UrlService {
  @override
  String? getPath() => null;
}

UrlService create() {
  return IOUrlService();
}

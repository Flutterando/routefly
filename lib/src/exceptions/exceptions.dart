class RouteflyException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  RouteflyException(this.message, [this.stackTrace]);

  @override
  String toString() {
    return 'RouteflyException: $message\n${stackTrace ?? StackTrace.current}';
  }
}

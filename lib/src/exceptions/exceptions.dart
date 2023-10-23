/// Routefly Exception representation
/// [message]: Exception info
/// [stackTrace]: traces
class RouteflyException implements Exception {
  /// Exception info
  final String message;

  /// traces
  final StackTrace? stackTrace;

  /// Routefly Exception representation
  /// [message]: Exception info
  /// [stackTrace]: traces
  RouteflyException(this.message, [this.stackTrace]);
}

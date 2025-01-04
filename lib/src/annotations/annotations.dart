/// Annotation to mark the main entry point of the application.
///
/// This annotation is used to specify the directory and the suffix for the main
/// page files.
///
/// The [baseDir] parameter specifies the directory where the main page files
/// are located.
/// The default value is `'lib/'`.
///
/// The [pageSuffix] parameter specifies the suffix for the main page files.
/// The default value is `'page'`.
///
/// Example usage:
///
/// ```dart
/// @Main('lib/pages/', 'view')
/// class MyApp {}
/// ```
class Main {
  /// The directory where the main page files are located.
  final String baseDir;

  /// The suffix for the main page files.
  final String pageSuffix;

  /// Annotation to mark the main entry point of the application.
  ///
  /// This annotation is used to specify the directory and the suffix for
  /// the main page files.
  ///
  /// The [baseDir] parameter specifies the directory where the main page files
  /// are located.
  /// The default value is `'lib/'`.
  ///
  /// The [pageSuffix] parameter specifies the suffix for the main page files.
  /// The default value is `'page'`.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// @Main('lib/pages/', 'view')
  /// class MyApp {}
  /// ```
  const Main([this.baseDir = 'lib/', this.pageSuffix = 'page']);
}

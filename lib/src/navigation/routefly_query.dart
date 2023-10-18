/// Route Parameters
class RouteflyQuery {
  final Map<String, dynamic> _data;

  /// Get url params
  /// ```dart
  /// // /product?filter=text
  ///
  /// Routefly.query.params['filter']
  /// ```
  final Map<String, String> params;

  /// Route arguments
  final dynamic arguments;

  /// Route Parameters
  RouteflyQuery(this.params, this._data, this.arguments);

  /// Get query of dynamic routes
  /// ```dart
  /// // /user/2
  ///
  /// Routefly.query['id']
  /// ```
  dynamic operator [](String key) {
    return _data[key];
  }
}
